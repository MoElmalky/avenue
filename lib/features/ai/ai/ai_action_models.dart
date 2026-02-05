import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_action_models.freezed.dart';
part 'ai_action_models.g.dart';

@Freezed(unionKey: 'type')
sealed class AiAction with _$AiAction {
  const factory AiAction.createTask({
    required String name,
    required DateTime date,
    String? startTime,
    String? endTime,
    @Default('Medium') String importance,
    String? note,
  }) = CreateTaskAction;

  const factory AiAction.updateTask({
    required String id,
    String? name,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? importance,
    String? note,
    bool? isDone,
  }) = UpdateTaskAction;

  const factory AiAction.deleteTask({required String id}) = DeleteTaskAction;

  const factory AiAction.updateSettings({
    String? theme,
    String? language,
    bool? notificationsEnabled,
  }) = UpdateSettingsAction;

  const factory AiAction.createDefaultTask({
    required String name,
    required List<int> weekdays, // 1 = Monday, 7 = Sunday
    required String startTime,
    required String endTime,
    @Default('Medium') String importance,
    String? note,
  }) = CreateDefaultTaskAction;

  const factory AiAction.updateDefaultTask({
    required String id,
    String? name,
    List<int>? weekdays,
    String? startTime,
    String? endTime,
    String? importance,
    String? note,
  }) = UpdateDefaultTaskAction;

  const factory AiAction.deleteDefaultTask({required String id}) =
      DeleteDefaultTaskAction;

  const factory AiAction.unknown({required String rawResponse}) = UnknownAction;

  factory AiAction.fromJson(Map<String, dynamic> json) =>
      _$AiActionFromJson(json);
}
