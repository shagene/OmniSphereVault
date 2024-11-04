import 'package:sqflite/sqflite.dart';
import 'package:sqflite_cipher/sqflite_cipher.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../utils/encryption_service.dart';
import 'dart:async';

class DatabaseService {
  static const String _databaseName = "omnisphere_vault.db";
  static const int _databaseVersion = 1;
  final EncryptionService _encryptionService;

  DatabaseService._privateConstructor(this._encryptionService);
  static DatabaseService? _instance;
  
  static Future<DatabaseService> getInstance() async {
    _instance ??= DatabaseService._privateConstructor(await EncryptionService.initialize());
    return _instance!;
  }

  static Database? _database;
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Get encryption key from secure storage
    final encryptionKey = await _encryptionService.getDatabaseKey();

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
      password: encryptionKey,  // Encrypt database
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        username TEXT,
        email TEXT,
        password TEXT NOT NULL,
        url TEXT,
        notes TEXT,
        lastModified TEXT NOT NULL,
        category TEXT NOT NULL,
        tags TEXT,
        lastUsed TEXT,
        passwordLastChanged TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        hasCustomExpirationSettings INTEGER NOT NULL DEFAULT 0,
        passwordExpirationDays INTEGER,
        notifyOnExpiration INTEGER NOT NULL DEFAULT 1,
        neverExpires INTEGER NOT NULL DEFAULT 0,
        strengthScore INTEGER,
        template TEXT,
        customFields TEXT
      )
    ''');

    // Add audit logging table
    await db.execute('''
      CREATE TABLE audit_logs (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        action TEXT NOT NULL,
        details TEXT,
        userId TEXT,
        ipAddress TEXT
      )
    ''');

    // Add templates table
    await db.execute('''
      CREATE TABLE password_templates (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        pattern TEXT NOT NULL,
        description TEXT,
        defaultCategory TEXT,
        requiredFields TEXT
      )
    ''');

    // Add security policies table
    await db.execute('''
      CREATE TABLE security_policies (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        minLength INTEGER NOT NULL,
        requireUppercase INTEGER NOT NULL,
        requireLowercase INTEGER NOT NULL,
        requireNumbers INTEGER NOT NULL,
        requireSpecial INTEGER NOT NULL,
        maxAge INTEGER,
        preventReuse INTEGER NOT NULL,
        enforceHistory INTEGER NOT NULL
      )
    ''');

    // Add backup metadata table
    await db.execute('''
      CREATE TABLE backup_metadata (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        size INTEGER NOT NULL,
        version TEXT NOT NULL,
        encrypted INTEGER NOT NULL,
        checksum TEXT NOT NULL,
        path TEXT NOT NULL
      )
    ''');

    // Add search history table
    await db.execute('''
      CREATE TABLE search_history (
        id TEXT PRIMARY KEY,
        query TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        resultCount INTEGER NOT NULL
      )
    ''');

    // Add user preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        lastModified TEXT NOT NULL
      )
    ''');

    // Add tags table
    await db.execute('''
      CREATE TABLE tags (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        color INTEGER,
        description TEXT
      )
    ''');

    // Add password-tag relationship table
    await db.execute('''
      CREATE TABLE password_tags (
        passwordId TEXT NOT NULL,
        tagId TEXT NOT NULL,
        PRIMARY KEY (passwordId, tagId),
        FOREIGN KEY (passwordId) REFERENCES passwords (id) ON DELETE CASCADE,
        FOREIGN KEY (tagId) REFERENCES tags (id) ON DELETE CASCADE
      )
    ''');

    // Add favorites table
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        itemId TEXT NOT NULL,
        itemType TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Create indices for better performance
    await _createIndices(db);
    
    // Insert default data
    await _insertDefaultData(db);
  }

  Future<void> _createIndices(Database db) async {
    // Existing indices
    await db.execute('CREATE INDEX idx_passwords_category ON passwords(category)');
    await db.execute('CREATE INDEX idx_passwords_title ON passwords(title)');
    await db.execute('CREATE INDEX idx_passwords_lastModified ON passwords(lastModified)');
    
    // New indices
    await db.execute('CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp)');
    await db.execute('CREATE INDEX idx_search_history_query ON search_history(query)');
    await db.execute('CREATE INDEX idx_tags_name ON tags(name)');
    await db.execute('CREATE INDEX idx_favorites_itemType ON favorites(itemType)');
    await db.execute('CREATE INDEX idx_backup_metadata_timestamp ON backup_metadata(timestamp)');
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insert default security policy
    await db.insert('security_policies', {
      'id': '1',
      'name': 'Default Policy',
      'minLength': 12,
      'requireUppercase': 1,
      'requireLowercase': 1,
      'requireNumbers': 1,
      'requireSpecial': 1,
      'maxAge': 90,
      'preventReuse': 1,
      'enforceHistory': 1,
    });

    // Insert default password template
    await db.insert('password_templates', {
      'id': '1',
      'name': 'Standard Password',
      'pattern': 'Aa#@',
      'description': 'Standard password template with all character types',
      'defaultCategory': 'General',
      'requiredFields': '["username","password"]',
    });

    // Insert default user preferences
    await db.insert('user_preferences', {
      'key': 'theme',
      'value': 'system',
      'lastModified': DateTime.now().toIso8601String(),
    });
  }

  // Add health check method
  Future<Map<String, dynamic>> checkDatabaseHealth() async {
    final db = await database;
    final results = <String, dynamic>{};

    try {
      // Check table counts
      for (final table in [
        'passwords',
        'categories',
        'password_history',
        'audit_logs',
        'password_templates',
        'security_policies',
        'backup_metadata',
        'search_history',
        'user_preferences',
        'tags',
        'password_tags',
        'favorites',
      ]) {
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $table'),
        );
        results['${table}_count'] = count;
      }

      // Check database size
      final dbPath = await getDatabasesPath();
      final dbFile = File(dbPath);
      results['database_size'] = await dbFile.length();

      // Check indices
      final indices = await db.rawQuery('SELECT * FROM sqlite_master WHERE type = "index"');
      results['indices_count'] = indices.length;

      // Perform integrity check
      final integrityCheck = await db.rawQuery('PRAGMA integrity_check');
      results['integrity_check'] = integrityCheck.first.values.first;

      results['status'] = 'healthy';
    } catch (e) {
      results['status'] = 'error';
      results['error'] = e.toString();
    }

    return results;
  }

  // Add performance monitoring
  Future<Map<String, dynamic>> getPerformanceMetrics() async {
    final db = await database;
    final metrics = <String, dynamic>{};

    // Get cache stats
    final cacheStats = await db.rawQuery('PRAGMA cache_stats');
    metrics['cache_stats'] = cacheStats;

    // Get page size and cache size
    metrics['page_size'] = Sqflite.firstIntValue(
      await db.rawQuery('PRAGMA page_size'),
    );
    metrics['cache_size'] = Sqflite.firstIntValue(
      await db.rawQuery('PRAGMA cache_size'),
    );

    return metrics;
  }

  // Add database optimization
  Future<void> optimizeDatabase() async {
    final db = await database;
    
    // Analyze database
    await db.execute('ANALYZE');
    
    // Optimize indices
    await db.execute('PRAGMA optimize');
    
    // Clean up unused space
    await vacuum();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  // Utility methods
  Future<void> backup(String path) async {
    final db = await database;
    final backupPath = join(path, 'backup_${DateTime.now().toIso8601String()}.db');
    final File dbFile = File(await getDatabasesPath());
    await dbFile.copy(backupPath);
  }

  Future<void> restore(String backupPath) async {
    final db = await database;
    await db.close();
    _database = null;
    
    final File backupFile = File(backupPath);
    final String dbPath = join(await getDatabasesPath(), _databaseName);
    await backupFile.copy(dbPath);
  }

  Future<void> vacuum() async {
    final db = await database;
    await db.execute('VACUUM');
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('passwords');
      await txn.delete('categories');
      await txn.delete('password_history');
      await txn.delete('settings');
    });
  }

  // Transaction helper
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
} 