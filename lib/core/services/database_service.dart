import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'line_database.db');

    return await openDatabase(
      path,
      version: 11, // Added order_index removed
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 8) {
      await db.execute('DROP TABLE IF EXISTS tasks');
      await db.execute('DROP TABLE IF EXISTS default_tasks');
      await _createDB(db, newVersion);
    }

    if (oldVersion >= 9 && oldVersion < 11) {
      // Migration to remove order_index if it exists
      try {
        final tableInfo = await db.rawQuery('PRAGMA table_info(tasks)');
        final hasOrderIndex = tableInfo.any(
          (column) => column['name'] == 'order_index',
        );

        if (hasOrderIndex) {
          await db.execute('ALTER TABLE tasks RENAME TO tasks_old');
          await _createDB(db, newVersion);
          await db.execute('''
            INSERT INTO tasks (id, name, desc, task_date, start_time, end_time, completed, category, one_time, is_deleted, server_updated_at, importance_type, is_dirty, embedding, default_task_id)
            SELECT id, name, desc, task_date, start_time, end_time, completed, category, one_time, is_deleted, server_updated_at, importance_type, is_dirty, embedding, default_task_id
            FROM tasks_old
          ''');
          await db.execute('DROP TABLE tasks_old');
        }
      } catch (e) {
        print('DB Migration Error: $e');
      }
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Tasks Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        desc TEXT,
        task_date TEXT NOT NULL,
        start_time TEXT,
        end_time TEXT,
        completed INTEGER NOT NULL DEFAULT 0,
        category TEXT NOT NULL,
        one_time INTEGER NOT NULL DEFAULT 1,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        server_updated_at TEXT NOT NULL,
        importance_type TEXT,
        is_dirty INTEGER NOT NULL DEFAULT 0,
        embedding TEXT,
        default_task_id TEXT
      )
    ''');

    // Default Tasks Table (Recurring)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS default_tasks (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        desc TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        category TEXT NOT NULL,
        weekdays TEXT NOT NULL,
        importance_type TEXT,
        server_updated_at TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        is_dirty INTEGER NOT NULL DEFAULT 0,
        embedding TEXT,
        hide_on TEXT
      )
    ''');

    // Settings Table (for last_sync_timestamp, etc.)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
