import 'dart:convert';
import '../../../core/database/database_service.dart';
import '../../../core/utils/encryption_service.dart';
import '../models/password_entry.dart';
import './password_repository.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final DatabaseService _db;
  final EncryptionService _encryption;

  PasswordRepositoryImpl(this._db, this._encryption);

  @override
  Future<List<PasswordEntry>> getAllPasswords() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('passwords');
    return Future.wait(
      maps.map((map) => _mapToPasswordEntry(map)).toList(),
    );
  }

  @override
  Future<PasswordEntry?> getPassword(String id) async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToPasswordEntry(maps.first);
  }

  @override
  Future<void> addPassword(PasswordEntry entry) async {
    await _db.transaction((txn) async {
      // Insert password entry
      await txn.insert(
        'passwords',
        await _passwordEntryToMap(entry),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Add audit log
      await txn.insert('audit_logs', {
        'id': DateTime.now().toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
        'action': 'ADD_PASSWORD',
        'details': jsonEncode({
          'passwordId': entry.id,
          'title': entry.title,
          'category': entry.category,
        }),
      });

      // Add tags
      for (final tag in entry.tags) {
        await txn.insert(
          'tags',
          {'name': tag},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        
        final tagMap = await txn.query(
          'tags',
          where: 'name = ?',
          whereArgs: [tag],
        );
        
        if (tagMap.isNotEmpty) {
          await txn.insert(
            'password_tags',
            {
              'passwordId': entry.id,
              'tagId': tagMap.first['id'],
            },
          );
        }
      }

      // Update search history
      await txn.insert(
        'search_history',
        {
          'id': DateTime.now().toIso8601String(),
          'query': entry.title,
          'timestamp': DateTime.now().toIso8601String(),
          'resultCount': 1,
        },
      );

      // Add to favorites if marked
      if (entry.isFavorite) {
        await txn.insert(
          'favorites',
          {
            'id': DateTime.now().toIso8601String(),
            'itemId': entry.id,
            'itemType': 'password',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      }
    });
  }

  @override
  Future<void> updatePassword(PasswordEntry entry) async {
    await _db.transaction((txn) async {
      // Get old entry for comparison
      final oldEntryMaps = await txn.query(
        'passwords',
        where: 'id = ?',
        whereArgs: [entry.id],
      );

      if (oldEntryMaps.isNotEmpty) {
        final oldEntry = await _mapToPasswordEntry(oldEntryMaps.first);
        
        // Update password entry
        await txn.update(
          'passwords',
          await _passwordEntryToMap(entry),
          where: 'id = ?',
          whereArgs: [entry.id],
        );

        // Add history entry
        if (entry.history.isNotEmpty) {
          final latestHistory = entry.history.last;
          await txn.insert(
            'password_history',
            {
              'id': DateTime.now().toIso8601String(),
              'passwordId': entry.id,
              'timestamp': latestHistory.timestamp.toIso8601String(),
              'changes': jsonEncode(latestHistory.changes),
              'reason': latestHistory.reason,
            },
          );
        }

        // Update tags
        await txn.delete(
          'password_tags',
          where: 'passwordId = ?',
          whereArgs: [entry.id],
        );

        for (final tag in entry.tags) {
          await txn.insert(
            'tags',
            {'name': tag},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
          
          final tagMap = await txn.query(
            'tags',
            where: 'name = ?',
            whereArgs: [tag],
          );
          
          if (tagMap.isNotEmpty) {
            await txn.insert(
              'password_tags',
              {
                'passwordId': entry.id,
                'tagId': tagMap.first['id'],
              },
            );
          }
        }

        // Update favorites
        if (entry.isFavorite != oldEntry.isFavorite) {
          if (entry.isFavorite) {
            await txn.insert(
              'favorites',
              {
                'id': DateTime.now().toIso8601String(),
                'itemId': entry.id,
                'itemType': 'password',
                'timestamp': DateTime.now().toIso8601String(),
              },
            );
          } else {
            await txn.delete(
              'favorites',
              where: 'itemId = ? AND itemType = ?',
              whereArgs: [entry.id, 'password'],
            );
          }
        }

        // Add audit log
        await txn.insert('audit_logs', {
          'id': DateTime.now().toIso8601String(),
          'timestamp': DateTime.now().toIso8601String(),
          'action': 'UPDATE_PASSWORD',
          'details': jsonEncode({
            'passwordId': entry.id,
            'title': entry.title,
            'category': entry.category,
            'changes': entry.history.last.changes,
          }),
        });
      }
    });
  }

  @override
  Future<void> deletePassword(String id) async {
    await _db.transaction((txn) async {
      // Get password info for audit log
      final passwordInfo = await txn.query(
        'passwords',
        columns: ['title', 'category'],
        where: 'id = ?',
        whereArgs: [id],
      );

      // Delete password
      await txn.delete(
        'passwords',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Add audit log
      if (passwordInfo.isNotEmpty) {
        await txn.insert('audit_logs', {
          'id': DateTime.now().toIso8601String(),
          'timestamp': DateTime.now().toIso8601String(),
          'action': 'DELETE_PASSWORD',
          'details': jsonEncode({
            'passwordId': id,
            'title': passwordInfo.first['title'],
            'category': passwordInfo.first['category'],
          }),
        });
      }

      // Remove from favorites
      await txn.delete(
        'favorites',
        where: 'itemId = ? AND itemType = ?',
        whereArgs: [id, 'password'],
      );
    });
  }

  @override
  Future<List<PasswordEntry>> searchPasswords(String query) async {
    final db = await _db.database;
    
    // Add search to history
    await db.insert(
      'search_history',
      {
        'id': DateTime.now().toIso8601String(),
        'query': query,
        'timestamp': DateTime.now().toIso8601String(),
        'resultCount': 0,  // Will update after search
      },
    );

    final List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      where: 'title LIKE ? OR username LIKE ? OR email LIKE ? OR url LIKE ? OR notes LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%', '%$query%'],
    );

    final results = await Future.wait(
      maps.map((map) => _mapToPasswordEntry(map)).toList(),
    );

    // Update search history with result count
    await db.update(
      'search_history',
      {'resultCount': results.length},
      where: 'query = ?',
      whereArgs: [query],
    );

    return results;
  }

  Future<PasswordEntry> _mapToPasswordEntry(Map<String, dynamic> map) async {
    // Get tags
    final db = await _db.database;
    final tagMaps = await db.rawQuery('''
      SELECT t.name
      FROM tags t
      JOIN password_tags pt ON t.id = pt.tagId
      WHERE pt.passwordId = ?
    ''', [map['id']]);

    final tags = tagMaps.map((t) => t['name'] as String).toList();

    // Get history
    final historyMaps = await db.query(
      'password_history',
      where: 'passwordId = ?',
      whereArgs: [map['id']],
      orderBy: 'timestamp DESC',
    );

    final history = historyMaps.map((h) => PasswordEntryHistory(
      timestamp: DateTime.parse(h['timestamp'] as String),
      changes: jsonDecode(h['changes'] as String) as Map<String, dynamic>,
      reason: h['reason'] as String?,
    )).toList();

    return PasswordEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      username: map['username'] as String?,
      email: map['email'] as String?,
      password: _encryption.decryptData(map['password'] as String),
      url: map['url'] as String?,
      notes: map['notes'] as String?,
      lastModified: DateTime.parse(map['lastModified'] as String),
      category: map['category'] as String,
      tags: tags,
      lastUsed: map['lastUsed'] != null 
          ? DateTime.parse(map['lastUsed'] as String) 
          : null,
      passwordLastChanged: DateTime.parse(map['passwordLastChanged'] as String),
      isFavorite: map['isFavorite'] == 1,
      hasCustomExpirationSettings: map['hasCustomExpirationSettings'] == 1,
      passwordExpirationDays: map['passwordExpirationDays'] as int?,
      notifyOnExpiration: map['notifyOnExpiration'] == 1,
      neverExpires: map['neverExpires'] == 1,
      history: history,
    );
  }

  Future<Map<String, dynamic>> _passwordEntryToMap(PasswordEntry entry) async {
    return {
      'id': entry.id,
      'title': entry.title,
      'username': entry.username,
      'email': entry.email,
      'password': _encryption.encryptData(entry.password),
      'url': entry.url,
      'notes': entry.notes,
      'lastModified': entry.lastModified.toIso8601String(),
      'category': entry.category,
      'lastUsed': entry.lastUsed?.toIso8601String(),
      'passwordLastChanged': entry.passwordLastChanged.toIso8601String(),
      'isFavorite': entry.isFavorite ? 1 : 0,
      'hasCustomExpirationSettings': entry.hasCustomExpirationSettings ? 1 : 0,
      'passwordExpirationDays': entry.passwordExpirationDays,
      'notifyOnExpiration': entry.notifyOnExpiration ? 1 : 0,
      'neverExpires': entry.neverExpires ? 1 : 0,
    };
  }
} 