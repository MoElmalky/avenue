// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_action_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskAction _$TaskActionFromJson(Map<String, dynamic> json) => TaskAction(
  action: json['action'] as String,
  id: json['id'] as String?,
  name: json['name'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  importance: json['importance'] as String?,
  note: json['note'] as String?,
  category: json['category'] as String?,
  isDone: json['isDone'] as bool?,
  isDeleted: json['isDeleted'] as bool?,
  defaultTaskId: json['defaultTaskId'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$TaskActionToJson(TaskAction instance) =>
    <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'name': instance.name,
      'date': instance.date?.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'importance': instance.importance,
      'note': instance.note,
      'category': instance.category,
      'isDone': instance.isDone,
      'isDeleted': instance.isDeleted,
      'defaultTaskId': instance.defaultTaskId,
      'type': instance.$type,
    };

HabitAction _$HabitActionFromJson(Map<String, dynamic> json) => HabitAction(
  action: json['action'] as String,
  id: json['id'] as String?,
  name: json['name'] as String?,
  weekdays: (json['weekdays'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  importance: json['importance'] as String?,
  note: json['note'] as String?,
  category: json['category'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$HabitActionToJson(HabitAction instance) =>
    <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'name': instance.name,
      'weekdays': instance.weekdays,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'importance': instance.importance,
      'note': instance.note,
      'category': instance.category,
      'isDeleted': instance.isDeleted,
      'type': instance.$type,
    };

UpdateSettingsAction _$UpdateSettingsActionFromJson(
  Map<String, dynamic> json,
) => UpdateSettingsAction(
  theme: json['theme'] as String?,
  language: json['language'] as String?,
  notificationsEnabled: json['notificationsEnabled'] as bool?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$UpdateSettingsActionToJson(
  UpdateSettingsAction instance,
) => <String, dynamic>{
  'theme': instance.theme,
  'language': instance.language,
  'notificationsEnabled': instance.notificationsEnabled,
  'type': instance.$type,
};

SkipHabitInstanceAction _$SkipHabitInstanceActionFromJson(
  Map<String, dynamic> json,
) => SkipHabitInstanceAction(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$SkipHabitInstanceActionToJson(
  SkipHabitInstanceAction instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'type': instance.$type,
};

UnknownAction _$UnknownActionFromJson(Map<String, dynamic> json) =>
    UnknownAction(
      rawResponse: json['rawResponse'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$UnknownActionToJson(UnknownAction instance) =>
    <String, dynamic>{
      'rawResponse': instance.rawResponse,
      'type': instance.$type,
    };
