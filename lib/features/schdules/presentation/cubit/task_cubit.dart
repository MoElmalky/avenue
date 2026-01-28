import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../domain/repo/schedule_repository.dart';
import 'task_state.dart';

import '../../../../core/services/sync_service.dart';

class TaskCubit extends Cubit<TaskState> {
  final ScheduleRepository repository;
  final SyncService syncService;
  DateTime _selectedDate = DateTime.now();
  StreamSubscription? _connectivitySubscription;

  TaskCubit({required this.repository, required this.syncService})
    : super(TaskInitial()) {
    loadTasks();
    syncTasks(); // Sync once on app start

    // Listen for connectivity changes to auto-sync when back online
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      // connectivity_plus 6.x returns a List<ConnectivityResult>
      if (results.any((result) => result != ConnectivityResult.none)) {
        print("TaskCubit: Internet restored. Triggering auto-sync.");
        syncTasks();
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> syncTasks() async {
    try {
      await syncService.sync();
      // Only reload if we are not in a loading state to avoid flicker
      if (state is! TaskLoading) {
        final result = await repository.getTasksByDate(_selectedDate);
        result.fold(
          (failure) => null, // Ignore failures during background sync
          (tasks) => emit(TaskLoaded(tasks, selectedDate: _selectedDate)),
        );
      }
    } catch (e) {
      print("TaskCubit: Background sync failed: $e");
      // Don't emit error state for background sync to avoid interrupting user
    }
  }

  Future<void> loadTasks({DateTime? date, bool shouldSync = false}) async {
    if (date != null) {
      _selectedDate = date;
    }
    emit(TaskLoading(selectedDate: _selectedDate));

    if (shouldSync) {
      try {
        await syncService.sync();
      } catch (e) {
        print("Sync failed during load: $e");
      }
    }

    final result = await repository.getTasksByDate(_selectedDate);

    result.fold(
      (failure) =>
          emit(TaskError(failure.message, selectedDate: _selectedDate)),
      (tasks) => emit(TaskLoaded(tasks, selectedDate: _selectedDate)),
    );
  }

  Future<void> addTask(TaskModel task) async {
    final result = await repository.addTask(task);

    result.fold(
      (failure) =>
          emit(TaskError(failure.message, selectedDate: _selectedDate)),
      (_) {
        loadTasks(); // Reload locally first
        syncTasks(); // Then sync in background
      },
    );
  }

  Future<void> updateTask(TaskModel task) async {
    final result = await repository.updateTask(task);

    result.fold(
      (failure) =>
          emit(TaskError(failure.message, selectedDate: _selectedDate)),
      (_) {
        loadTasks(); // Reload locally first
        syncTasks(); // Then sync in background
      },
    );
  }

  Future<void> deleteTask(String id) async {
    final result = await repository.deleteTask(id);

    result.fold(
      (failure) =>
          emit(TaskError(failure.message, selectedDate: _selectedDate)),
      (_) {
        loadTasks(); // Reload locally first
        syncTasks(); // Then sync in background
      },
    );
  }

  Future<void> toggleTaskDone(String id) async {
    final result = await repository.toggleTaskDone(id);

    result.fold(
      (failure) =>
          emit(TaskError(failure.message, selectedDate: _selectedDate)),
      (_) {
        loadTasks(); // Reload locally first
        syncTasks(); // Then sync in background
      },
    );
  }

  DateTime get selectedDate => _selectedDate;
}
