import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/schdules/data/models/task_model.dart';
import '../../features/schdules/data/models/default_task_model.dart';
import 'database_service.dart';

class SyncService {
  final DatabaseService databaseService;
  final SupabaseClient supabase;

  static const String lastSyncKey = 'last_sync_timestamp';

  SyncService({required this.databaseService, required this.supabase});

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> sync() async {
    try {
      if (!await _hasInternet()) {
        print("SyncService: No internet connection. Skipping sync.");
        return;
      }

      final user = supabase.auth.currentUser;
      if (user == null) {
        print("SyncService: No user logged in. Skipping sync.");
        return;
      }

      final userId = user.id;
      final db = await databaseService.database;

      // Get last sync timestamp from settings table
      final List<Map<String, dynamic>> settings = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: [lastSyncKey],
      );

      final lastSyncStr = settings.isNotEmpty ? settings.first['value'] : null;
      final lastSync = lastSyncStr != null
          ? DateTime.parse(lastSyncStr).toUtc()
          : DateTime.fromMillisecondsSinceEpoch(0).toUtc();

      print(
        "SyncService: Starting delta sync for user $userId. Last sync: $lastSync",
      );

      // 1. Pull changes from Supabase (Remote -> Local)
      final response = await supabase
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .gt('server_updated_at', lastSync.toIso8601String());

      final remoteData = response as List<dynamic>;
      int pullCount = 0;

      for (final json in remoteData) {
        final remoteTask = TaskModel.fromSupabaseJson(json);

        // Check local version
        final List<Map<String, dynamic>> localMaps = await db.query(
          'tasks',
          where: 'id = ?',
          whereArgs: [remoteTask.id],
        );

        if (localMaps.isEmpty) {
          await db.insert('tasks', remoteTask.toMap());
          pullCount++;
        } else {
          final localTask = TaskModel.fromMap(localMaps.first);
          if (remoteTask.serverUpdatedAt.isAfter(localTask.serverUpdatedAt)) {
            await db.update(
              'tasks',
              remoteTask.toMap(),
              where: 'id = ?',
              whereArgs: [remoteTask.id],
            );
            pullCount++;
          }
        }
      }

      // 2. Push local changes to Supabase (Local -> Remote)
      final List<Map<String, dynamic>> localChangesMaps = await db.query(
        'tasks',
        where: 'server_updated_at > ?',
        whereArgs: [lastSync.toIso8601String()],
      );

      final localChanges = localChangesMaps
          .map((m) => TaskModel.fromMap(m))
          .toList();

      int pushCount = 0;
      for (final task in localChanges) {
        await _pushToRemote(task, userId);
        pushCount++;
      }

      // 4. Sync Default Tasks
      await _syncDefaultTasks(db, userId, lastSync);

      // 5. Update last sync timestamp
      final now = DateTime.now().toUtc().toIso8601String();
      await db.insert('settings', {
        'key': lastSyncKey,
        'value': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      print(
        "SyncService: Delta sync completed. Pulled: $pullCount, Pushed: $pushCount",
      );
    } catch (e) {
      print("SyncService: Error during delta sync: $e");
      rethrow;
    }
  }

  Future<void> _syncDefaultTasks(
    Database db,
    String userId,
    DateTime lastSync,
  ) async {
    print("SyncService: Syncing default tasks...");
    // 1. Pull changes
    final response = await supabase
        .from('default_tasks')
        .select()
        .eq('user_id', userId)
        .gt('server_updated_at', lastSync.toIso8601String());

    final remoteData = response as List<dynamic>;
    for (final json in remoteData) {
      final remoteTask = DefaultTaskModel.fromSupabaseJson(json);

      final List<Map<String, dynamic>> localMaps = await db.query(
        'default_tasks',
        where: 'id = ?',
        whereArgs: [remoteTask.id],
      );

      if (localMaps.isEmpty) {
        await db.insert('default_tasks', remoteTask.toMap());
      } else {
        final localTask = DefaultTaskModel.fromMap(localMaps.first);
        if (remoteTask.serverUpdatedAt.isAfter(localTask.serverUpdatedAt)) {
          await db.update(
            'default_tasks',
            remoteTask.toMap(),
            where: 'id = ?',
            whereArgs: [remoteTask.id],
          );
        }
      }
    }

    // 2. Push changes
    final List<Map<String, dynamic>> localChangesMaps = await db.query(
      'default_tasks',
      where: 'server_updated_at > ?',
      whereArgs: [lastSync.toIso8601String()],
    );

    final localChanges = localChangesMaps
        .map((m) => DefaultTaskModel.fromMap(m))
        .toList();
    for (final task in localChanges) {
      final json = task.toSupabaseJson(userId);
      await supabase.from('default_tasks').upsert(json);
    }
  }

  Future<void> _pushToRemote(TaskModel task, String userId) async {
    final json = task.toSupabaseJson(userId);
    print("SyncService: Pushing task to remote: $json");
    await supabase.from('tasks').upsert(json);
  }

  Future<void> fetchTasksForDateRange(DateTime start, DateTime end) async {
    try {
      if (!await _hasInternet()) return;

      final user = supabase.auth.currentUser;
      if (user == null) return;

      final startStr = start.toIso8601String().split('T')[0];
      final endStr = end.toIso8601String().split('T')[0];

      print("SyncService: Fetching tasks from $startStr to $endStr");

      final response = await supabase
          .from('tasks')
          .select()
          .eq('user_id', user.id)
          .gte('task_date', startStr)
          .lte('task_date', endStr);

      final remoteData = response as List<dynamic>;
      final db = await databaseService.database;

      for (final json in remoteData) {
        final remoteTask = TaskModel.fromSupabaseJson(json);
        await db.insert(
          'tasks',
          remoteTask.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print("SyncService: Error fetching history: $e");
      rethrow;
    }
  }
}
