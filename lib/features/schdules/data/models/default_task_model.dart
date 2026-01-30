import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DefaultTaskModel {
  final String id;
  final String name;
  final String? desc;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String category;
  final int colorValue;
  final List<int> weekdays; // 1 = Monday, 7 = Sunday
  final String? importanceType;

  final DateTime serverUpdatedAt;
  final bool isDeleted;

  DefaultTaskModel({
    String? id,
    required this.name,
    this.desc,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.colorValue,
    required this.weekdays,
    this.importanceType,
    DateTime? serverUpdatedAt,
    this.isDeleted = false,
  }) : id = id ?? const Uuid().v4(),
       serverUpdatedAt = serverUpdatedAt ?? DateTime.now().toUtc();

  DefaultTaskModel copyWith({
    String? name,
    String? desc,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? category,
    int? colorValue,
    List<int>? weekdays,
    String? importanceType,
    DateTime? serverUpdatedAt,
    bool? isDeleted,
  }) {
    return DefaultTaskModel(
      id: id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      weekdays: weekdays ?? this.weekdays,
      importanceType: importanceType ?? this.importanceType,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  // SQLite Mapping
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'start_time': '${startTime.hour}:${startTime.minute}',
      'end_time': '${endTime.hour}:${endTime.minute}',
      'category': category,
      'color_value': colorValue,
      'weekdays': weekdays.join(','), // Store as comma-separated string
      'importance_type': importanceType,
      'server_updated_at': serverUpdatedAt.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory DefaultTaskModel.fromMap(Map<String, dynamic> map) {
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return DefaultTaskModel(
      id: map['id'],
      name: map['name'],
      desc: map['desc'],
      startTime: parseTime(map['start_time']),
      endTime: parseTime(map['end_time']),
      category: map['category'],
      colorValue: map['color_value'],
      weekdays: (map['weekdays'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      importanceType: map['importance_type'],
      serverUpdatedAt: DateTime.parse(map['server_updated_at']),
      isDeleted: map['is_deleted'] == 1,
    );
  }

  // Supabase Mapping
  Map<String, dynamic> toSupabaseJson(String userId) {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'desc': desc,
      'start_time': '${startTime.hour}:${startTime.minute}',
      'end_time': '${endTime.hour}:${endTime.minute}',
      'category': category,
      'color_value': colorValue,
      'weekdays': weekdays.join(','),
      'importance_type': importanceType,
      'server_updated_at': serverUpdatedAt.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }

  factory DefaultTaskModel.fromSupabaseJson(Map<String, dynamic> json) {
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return DefaultTaskModel(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      startTime: parseTime(json['start_time']),
      endTime: parseTime(json['end_time']),
      category: json['category'],
      colorValue: json['color_value'],
      weekdays: (json['weekdays'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      importanceType: json['importance_type'],
      serverUpdatedAt: DateTime.parse(json['server_updated_at']),
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  Color get color => Color(colorValue);
}
