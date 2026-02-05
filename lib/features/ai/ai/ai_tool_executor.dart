import 'package:avenue/features/schdules/data/models/task_model.dart';
import 'package:avenue/features/schdules/data/models/default_task_model.dart';
import 'package:avenue/features/schdules/domain/repo/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AiToolExecutor {
  final ScheduleRepository _repository;

  AiToolExecutor(this._repository);

  Future<Map<String, dynamic>> execute(
    String name,
    Map<String, dynamic> args,
  ) async {
    print('[AI][ToolCall] $name $args');

    try {
      switch (name) {
        case 'getTasks':
          return await _handleGetTasks(args);
        case 'searchTasks':
          return await _handleSearchTasks(args);
        case 'searchDefaultTasks':
          return await _handleSearchDefaultTasks(args);
        case 'addTask':
          return await _handleAddTask(args);
        case 'addDefaultTask':
          return await _handleAddDefaultTask(args);
        case 'updateTask':
          return await _handleUpdateTask(args);
        case 'updateDefaultTask':
          return await _handleUpdateDefaultTask(args);
        case 'deleteTask':
          return await _handleDeleteTask(args);
        case 'deleteDefaultTask':
          return await _handleDeleteDefaultTask(args);
        default:
          return {'error': 'Tool not found: $name'};
      }
    } catch (e) {
      print('[AI][ToolError] $name: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _handleGetTasks(
    Map<String, dynamic> args,
  ) async {
    final start = DateTime.parse(args['startDate'] as String);
    final end = args['endDate'] != null
        ? DateTime.parse(args['endDate'] as String)
        : null;

    final result = end != null
        ? await _repository.getTasksByDateRange(start, end)
        : await _repository.getTasksByDate(start);

    return result.fold((f) => {'error': f.message}, (tasks) {
      print('[AI][ToolResult] getTasks count: ${tasks.length}');
      return {'tasks': tasks.map((t) => t.toMap()).toList()};
    });
  }

  Future<Map<String, dynamic>> _handleSearchTasks(
    Map<String, dynamic> args,
  ) async {
    final query = args['query'] as String;
    final result = await _repository.searchTasks(query);
    return result.fold((f) => {'error': f.message}, (tasks) {
      print('[AI][ToolResult] searchTasks count: ${tasks.length}');
      return {'tasks': tasks.map((t) => t.toMap()).toList()};
    });
  }

  Future<Map<String, dynamic>> _handleSearchDefaultTasks(
    Map<String, dynamic> args,
  ) async {
    final query = args['query'] as String;
    final result = await _repository.searchDefaultTasks(query);
    return result.fold((f) => {'error': f.message}, (tasks) {
      print('[AI][ToolResult] searchDefaultTasks count: ${tasks.length}');
      return {'tasks': tasks.map((t) => t.toMap()).toList()};
    });
  }

  Future<Map<String, dynamic>> _handleAddTask(Map<String, dynamic> args) async {
    final date = DateTime.parse(args['date'] as String);

    final task = TaskModel(
      id: const Uuid().v4(),
      name: args['name'] as String,
      taskDate: date,
      startTime: _parseRelativeTime(date, args['startTime'] as String),
      endTime: _parseRelativeTime(date, args['endTime'] as String),
      importanceType: args['importance'] ?? 'Medium',
      desc: args['note'] ?? '',
      completed: false,
      category: 'General', // Default or extract from AI
      isDeleted: false,
      serverUpdatedAt: DateTime.now(),
    );

    final result = await _repository.addTask(task);
    return result.fold(
      (f) => {'error': f.message},
      (_) => {'success': true, 'taskId': task.id},
    );
  }

  Future<Map<String, dynamic>> _handleAddDefaultTask(
    Map<String, dynamic> args,
  ) async {
    final startTime = _parseTimeOfDay(args['startTime'] as String);
    final endTime = _parseTimeOfDay(args['endTime'] as String);

    final task = DefaultTaskModel(
      id: const Uuid().v4(),
      name: args['name'] as String,
      startTime: startTime,
      endTime: endTime,
      category: args['category'] ?? 'General',
      weekdays: List<int>.from(args['weekdays'] as List),
      importanceType: args['importance'] ?? 'Medium',
      desc: args['note'] ?? '',
      serverUpdatedAt: DateTime.now(),
    );

    final result = await _repository.addDefaultTask(task);
    return result.fold(
      (f) => {'error': f.message},
      (_) => {'success': true, 'defaultTaskId': task.id},
    );
  }

  Future<Map<String, dynamic>> _handleUpdateTask(
    Map<String, dynamic> args,
  ) async {
    final id = args['id'] as String;
    final existingResult = await _repository.getTaskById(id);

    return await existingResult.fold((f) => {'error': f.message}, (
      existing,
    ) async {
      if (existing == null) return {'error': 'Task not found'};

      DateTime? updatedDate;
      if (args['date'] != null) {
        updatedDate = DateTime.parse(args['date'] as String);
      }

      final dateContext = updatedDate ?? existing.taskDate;

      final updated = existing.copyWith(
        name: args['name'] as String?,
        completed: args['isDone'] as bool?,
        taskDate: updatedDate,
        startTime: args['startTime'] != null
            ? _parseRelativeTime(dateContext, args['startTime'] as String)
            : null,
        endTime: args['endTime'] != null
            ? _parseRelativeTime(dateContext, args['endTime'] as String)
            : null,
        importanceType: args['importance'] as String?,
        desc: args['note'] as String?,
        serverUpdatedAt: DateTime.now(),
      );

      final result = await _repository.updateTask(updated);
      return result.fold((f) => {'error': f.message}, (_) => {'success': true});
    });
  }

  Future<Map<String, dynamic>> _handleUpdateDefaultTask(
    Map<String, dynamic> args,
  ) async {
    final id = args['id'] as String;
    final existingResult = await _repository.getDefaultTaskById(id);

    return await existingResult.fold((f) => {'error': f.message}, (
      existing,
    ) async {
      if (existing == null) return {'error': 'Default task not found'};

      final updated = existing.copyWith(
        name: args['name'] as String?,
        desc: args['note'] as String?,
        startTime: args['startTime'] != null
            ? _parseTimeOfDay(args['startTime'] as String)
            : null,
        endTime: args['endTime'] != null
            ? _parseTimeOfDay(args['endTime'] as String)
            : null,
        category: args['category'] as String?,
        weekdays: args['weekdays'] != null
            ? List<int>.from(args['weekdays'] as List)
            : null,
        importanceType: args['importance'] as String?,
        serverUpdatedAt: DateTime.now(),
      );

      final result = await _repository.updateDefaultTask(updated);
      return result.fold((f) => {'error': f.message}, (_) => {'success': true});
    });
  }

  Future<Map<String, dynamic>> _handleDeleteTask(
    Map<String, dynamic> args,
  ) async {
    final id = args['id'] as String;
    final result = await _repository.deleteTask(id);
    return result.fold((f) => {'error': f.message}, (_) => {'success': true});
  }

  Future<Map<String, dynamic>> _handleDeleteDefaultTask(
    Map<String, dynamic> args,
  ) async {
    final id = args['id'] as String;
    final result = await _repository.deleteDefaultTask(id);
    return result.fold((f) => {'error': f.message}, (_) => {'success': true});
  }

  DateTime? _parseRelativeTime(DateTime date, String? timeStr) {
    if (timeStr == null) return null;
    final parts = timeStr.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  TimeOfDay _parseTimeOfDay(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
