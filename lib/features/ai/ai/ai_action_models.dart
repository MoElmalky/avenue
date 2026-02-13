import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_action_models.freezed.dart';
part 'ai_action_models.g.dart';

@Freezed(unionKey: 'type')
sealed class AiAction with _$AiAction {
  // Matches manageSchedule(type: "task")
  @FreezedUnionValue('task')
  const factory AiAction.task({
    required String action, // "create" | "update"
    String? id,
    String? name,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? importance,
    String? note,
    String? category,
    bool? isDone,
    bool? isDeleted,
    String? defaultTaskId, // Optional: Link to a habit
  }) = TaskAction;

  // Matches manageSchedule(type: "default")
  @FreezedUnionValue('default')
  const factory AiAction.habit({
    required String action, // "create" | "update"
    String? id, // The habit UUID
    String? name,
    List<int>? weekdays,
    String? startTime,
    String? endTime,
    String? importance,
    String? note,
    String? category,
    bool? isDeleted,
  }) = HabitAction;

  @FreezedUnionValue('settings')
  const factory AiAction.updateSettings({
    String? theme,
    String? language,
    bool? notificationsEnabled,
  }) = UpdateSettingsAction;

  @FreezedUnionValue('skipHabitInstance')
  const factory AiAction.skipHabitInstance({
    required String id, // The habit UUID (default_task_id)
    required DateTime date,
  }) = SkipHabitInstanceAction;

  @FreezedUnionValue('unknown')
  const factory AiAction.unknown({required String rawResponse}) = UnknownAction;

  factory AiAction.fromJson(Map<String, dynamic> json) =>
      _$AiActionFromJson(json);
}
