import 'package:avenue/core/services/local_notification_service.dart';
import 'package:avenue/features/schdules/data/models/task_model.dart';
import '../utils/observability.dart';

/// Manage task-specific notification logic, separating it from the UI and core service.
class TaskNotificationManager {
  final LocalNotificationService _notificationService;

  TaskNotificationManager(this._notificationService);

  /// Generate a unique integer ID for notifications from a Task UUID
  int _getNotificationId(
    String taskId, {
    bool isReminder = false,
    bool isEndTime = false,
  }) {
    // We use the hash of the taskId string and add offsets to avoid collisions.
    final hash = taskId.hashCode.abs();
    if (isReminder) return hash + 1;
    if (isEndTime) return hash + 2;
    return hash;
  }

  /// Schedules all enabled notifications for a task
  Future<void> scheduleTaskNotifications(TaskModel task) async {
    // 1. Cancel existing notifications for this task first to avoid duplicates
    await cancelTaskNotifications(task.id);

    if (!task.notificationsEnabled) {
      AvenueLogger.log(
        event: 'NOTIFICATION_SKIPPED_DISABLED',
        layer: LoggerLayer.SYNC,
        payload: 'Notifications disabled for task: ${task.id}',
      );
      return;
    }

    final now = DateTime.now();
    // Allow scheduling if time is up to 1 minute in the past (handling processing time)
    final schedulingWindow = now.subtract(const Duration(minutes: 1));

    AvenueLogger.log(
      event: 'TASK_NOTIFICATION_CHECK',
      layer: LoggerLayer.SYNC,
      payload: {
        'taskId': task.id,
        'now': now.toIso8601String(),
        'schedulingWindow': schedulingWindow.toIso8601String(),
        'startTime': task.startTime?.toIso8601String(),
        'endTime': task.endTime?.toIso8601String(),
        'enabled': task.notificationsEnabled,
        'completed': task.completed,
      },
    );

    // 2. Schedule the main notification (at startTime)
    // Only if task is NOT completed (why remind to start if done?)
    if (!task.completed &&
        task.startTime != null &&
        task.startTime!.isAfter(schedulingWindow)) {
      await _notificationService.scheduleNotification(
        id: _getNotificationId(task.id),
        title: 'Task Reminder: ${task.name} 🔔',
        body: task.desc ?? 'Time to start your task!',
        scheduledTime: task.startTime!,
        payload: 'task_${task.id}',
      );
      AvenueLogger.log(
        event: 'NOTIFICATION_SCHEDULED_START',
        layer: LoggerLayer.SYNC,
        payload: 'Task ID: ${task.id}, Start Time: ${task.startTime}',
      );
    } else {
      AvenueLogger.log(
        event: 'NOTIFICATION_SKIPPED_START',
        layer: LoggerLayer.SYNC,
        payload:
            'Skipped start notification. Task ID: ${task.id}, Start Time: ${task.startTime}',
      );
    }

    // 3. Schedule the reminder notification (X minutes before)
    if (!task.completed &&
        task.reminderBeforeMinutes != null &&
        task.startTime != null) {
      final reminderTime = task.startTime!.subtract(
        Duration(minutes: task.reminderBeforeMinutes!),
      );

      if (reminderTime.isAfter(schedulingWindow)) {
        await _notificationService.scheduleNotification(
          id: _getNotificationId(task.id, isReminder: true),
          title: 'Upcoming Task: ${task.name} ⏳',
          body: 'Starts in ${task.reminderBeforeMinutes} minutes',
          scheduledTime: reminderTime,
          payload: 'task_${task.id}',
        );
        AvenueLogger.log(
          event: 'NOTIFICATION_SCHEDULED_REMINDER',
          layer: LoggerLayer.SYNC,
          payload: 'Task ID: ${task.id}, Reminder Time: $reminderTime',
        );
      } else {
        AvenueLogger.log(
          event: 'NOTIFICATION_SKIPPED_REMINDER',
          layer: LoggerLayer.SYNC,
          payload:
              'Skipped reminder notification. Reminder Time: $reminderTime',
        );
      }
    }

    // 4. Schedule END TIME status notification
    if (task.endTime != null && task.endTime!.isAfter(schedulingWindow)) {
      final title = task.completed ? "Great Job! 🌟" : "time finished ⏳";
      final body = task.completed
          ? "Good Job, you finished the task: ${task.name}"
          : 'The task "${task.name}" finished';

      await _notificationService.scheduleNotification(
        id: _getNotificationId(task.id, isEndTime: true),
        title: title,
        body: body,
        scheduledTime: task.endTime!,
        payload: 'task_${task.id}',
      );
      AvenueLogger.log(
        event: 'NOTIFICATION_SCHEDULED_END',
        layer: LoggerLayer.SYNC,
        payload:
            'Task ID: ${task.id}, End Time: ${task.endTime}, Type: ${task.completed ? "Done" : "Missed"}',
      );
    } else {
      AvenueLogger.log(
        event: 'NOTIFICATION_SKIPPED_END',
        layer: LoggerLayer.SYNC,
        payload:
            'Skipped end notification. Task ID: ${task.id}, End Time: ${task.endTime}',
      );
    }
  }

  /// Cancels all notifications (main, reminder, end-time) for a specific task
  Future<void> cancelTaskNotifications(String taskId) async {
    await _notificationService.cancelNotification(_getNotificationId(taskId));
    await _notificationService.cancelNotification(
      _getNotificationId(taskId, isReminder: true),
    );
    await _notificationService.cancelNotification(
      _getNotificationId(taskId, isEndTime: true),
    );

    AvenueLogger.log(
      event: 'TASK_NOTIFICATIONS_CANCELLED',
      layer: LoggerLayer.SYNC,
      payload: taskId,
    );
  }
}
