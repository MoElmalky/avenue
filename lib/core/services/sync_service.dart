import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/schdules/data/models/task_model.dart';
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

      // 3. Update last sync timestamp
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

  Future<void> _pushToRemote(TaskModel task, String userId) async {
    final json = task.toSupabaseJson(userId);
    print("SyncService: Pushing task to remote: $json");
    await supabase.from('tasks').upsert(json);
  }
}
