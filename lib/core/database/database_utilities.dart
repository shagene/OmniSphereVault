import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import './database_service.dart';

class DatabaseUtilities {
  static Future<String> getDatabasePath() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, 'omnisphere_vault.db');
  }

  static Future<bool> databaseExists() async {
    final path = await getDatabasePath();
    return File(path).exists();
  }

  static Future<void> createBackup(String backupName) async {
    final db = await DatabaseService.getInstance();
    final String dbPath = await getDatabasePath();
    final String backupPath = join(
      (await getApplicationDocumentsDirectory()).path,
      'backups',
      '$backupName.db',
    );

    // Create backups directory if it doesn't exist
    final backupDir = Directory(dirname(backupPath));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    // Copy database file
    await File(dbPath).copy(backupPath);
  }

  static Future<List<String>> getBackups() async {
    final backupDir = Directory(
      join((await getApplicationDocumentsDirectory()).path, 'backups'),
    );
    
    if (!await backupDir.exists()) return [];

    final List<FileSystemEntity> files = await backupDir
        .list()
        .where((entity) => entity.path.endsWith('.db'))
        .toList();
        
    return files
        .map((file) => basename(file.path))
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Sort newest first
  }

  static Future<void> restoreBackup(String backupName) async {
    final db = await DatabaseService.getInstance();
    final String dbPath = await getDatabasePath();
    final String backupPath = join(
      (await getApplicationDocumentsDirectory()).path,
      'backups',
      backupName,
    );

    // Close current database connection
    await db.close();

    // Restore from backup
    await File(backupPath).copy(dbPath);
  }

  static Future<void> deleteBackup(String backupName) async {
    final String backupPath = join(
      (await getApplicationDocumentsDirectory()).path,
      'backups',
      backupName,
    );
    
    final file = File(backupPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<int> getDatabaseSize() async {
    final String dbPath = await getDatabasePath();
    final File dbFile = File(dbPath);
    if (await dbFile.exists()) {
      return await dbFile.length();
    }
    return 0;
  }

  static Future<void> optimizeDatabase() async {
    final db = await DatabaseService.getInstance();
    await db.vacuum();
  }

  static Future<Map<String, int>> getTableStatistics() async {
    final db = await DatabaseService.getInstance();
    final database = await db.database;
    
    final tables = ['passwords', 'categories', 'password_history', 'settings'];
    final Map<String, int> stats = {};
    
    for (final table in tables) {
      final result = await database.rawQuery('SELECT COUNT(*) as count FROM $table');
      stats[table] = Sqflite.firstIntValue(result) ?? 0;
    }
    
    return stats;
  }
} 