import '../../../core/database/database_service.dart';
import '../models/audit_log_entry.dart';
import './audit_log_repository.dart';
import 'dart:convert';

class AuditLogRepositoryImpl implements AuditLogRepository {
  final DatabaseService _db;

  AuditLogRepositoryImpl(this._db);

  @override
  Future<List<AuditLogEntry>> getAuditLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? action,
    int? limit,
    int? offset,
  }) async {
    final db = await _db.database;
    
    String whereClause = '1=1';
    final List<dynamic> whereArgs = [];

    if (startDate != null) {
      whereClause += ' AND timestamp >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereClause += ' AND timestamp <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    if (action != null) {
      whereClause += ' AND action = ?';
      whereArgs.add(action);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'audit_logs',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => AuditLogEntry(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      action: map['action'] as String,
      details: jsonDecode(map['details'] as String) as Map<String, dynamic>,
      userId: map['userId'] as String?,
      ipAddress: map['ipAddress'] as String?,
    )).toList();
  }

  @override
  Future<void> addAuditLog(AuditLogEntry entry) async {
    final db = await _db.database;
    
    await db.insert('audit_logs', {
      'id': entry.id,
      'timestamp': entry.timestamp.toIso8601String(),
      'action': entry.action,
      'details': jsonEncode(entry.details),
      'userId': entry.userId,
      'ipAddress': entry.ipAddress,
    });
  }

  @override
  Future<void> clearAuditLogs({DateTime? before}) async {
    final db = await _db.database;
    
    String? whereClause;
    List<dynamic>? whereArgs;

    if (before != null) {
      whereClause = 'timestamp < ?';
      whereArgs = [before.toIso8601String()];
    }

    await _db.transaction((txn) async {
      // Add meta log before clearing
      await txn.insert('audit_logs', {
        'id': DateTime.now().toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
        'action': 'CLEAR_AUDIT_LOGS',
        'details': jsonEncode({
          'clearBefore': before?.toIso8601String(),
        }),
      });

      // Clear logs
      await txn.delete(
        'audit_logs',
        where: whereClause,
        whereArgs: whereArgs,
      );
    });
  }

  @override
  Future<Map<String, int>> getAuditLogStats() async {
    final db = await _db.database;
    
    final stats = <String, int>{};

    // Get total count
    final totalCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM audit_logs'),
    );
    stats['totalCount'] = totalCount ?? 0;

    // Get counts by action
    final actionCounts = await db.rawQuery('''
      SELECT action, COUNT(*) as count
      FROM audit_logs
      GROUP BY action
    ''');

    for (final row in actionCounts) {
      stats[row['action'] as String] = row['count'] as int;
    }

    // Get today's count
    final todayCount = Sqflite.firstIntValue(
      await db.rawQuery('''
        SELECT COUNT(*)
        FROM audit_logs
        WHERE date(timestamp) = date('now')
      '''),
    );
    stats['todayCount'] = todayCount ?? 0;

    return stats;
  }

  @override
  Future<void> exportAuditLogs(String path, {DateTime? startDate, DateTime? endDate}) async {
    final logs = await getAuditLogs(
      startDate: startDate,
      endDate: endDate,
    );

    final jsonLogs = logs.map((log) => {
      'id': log.id,
      'timestamp': log.timestamp.toIso8601String(),
      'action': log.action,
      'details': log.details,
      'userId': log.userId,
      'ipAddress': log.ipAddress,
    }).toList();

    await File(path).writeAsString(
      jsonEncode({
        'exportDate': DateTime.now().toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'logs': jsonLogs,
      }),
    );
  }
} 