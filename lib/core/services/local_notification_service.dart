import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../utils/observability.dart';

/// Local Notification Service for Android 7+ (supports Android 13+ runtime permissions)
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final fln.FlutterLocalNotificationsPlugin _notifications =
      fln.FlutterLocalNotificationsPlugin();

  static const String _channelId = 'avenue_default_channel';
  static const String _channelName = 'Avenue Notifications';
  static const String _channelDescription =
      'Default notification channel for Avenue app';

  /// Initializes the service, including timezones and notification channels
  Future<void> init() async {
    try {
      tz.initializeTimeZones();

      try {
        final dynamic location = await FlutterTimezone.getLocalTimezone();
        var timeZoneName = (location is String)
            ? location
            : location.toString();

        // Handle specific TimezoneInfo format
        if (timeZoneName.startsWith('TimezoneInfo(')) {
          final parts = timeZoneName.split('(');
          if (parts.length > 1) {
            final inner = parts[1].split(',');
            if (inner.isNotEmpty) {
              timeZoneName = inner[0].trim();
            }
          }
        }

        tz.setLocalLocation(
          tz.getLocation(
            timeZoneName.isNotEmpty ? timeZoneName : 'Africa/Cairo',
          ),
        );

        AvenueLogger.log(
          event: 'TIMEZONE_INIT_SUCCESS',
          layer: LoggerLayer.SYNC,
          payload: 'Local timezone set to: $timeZoneName',
        );
      } catch (e) {
        AvenueLogger.log(
          event: 'TIMEZONE_INIT_FAILED',
          layer: LoggerLayer.SYNC,
          level: LoggerLevel.WARN,
          payload: 'Failed to get local timezone ($e), falling back to Cairo',
        );
        tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      }

      const androidSettings = fln.AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const linuxSettings = fln.LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      );
      const initSettings = fln.InitializationSettings(
        android: androidSettings,
        linux: linuxSettings,
      );

      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      const androidChannel = fln.AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: fln.Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
            fln.AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);

      AvenueLogger.log(
        event: 'NOTIFICATION_INIT_SUCCESS',
        layer: LoggerLayer.SYNC,
        payload: 'LocalNotificationService initialized successfully',
      );
    } catch (e) {
      AvenueLogger.log(
        event: 'NOTIFICATION_INIT_ERROR',
        layer: LoggerLayer.SYNC,
        level: LoggerLevel.ERROR,
        payload: 'Initialization failed: $e',
      );
      rethrow;
    }
  }

  /// Requests notification permissions for Android 13+
  Future<bool> requestPermissionIfNeeded() async {
    try {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            fln.AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation == null) {
        AvenueLogger.log(
          event: 'NOTIFICATION_PERMISSION_WARN',
          layer: LoggerLayer.SYNC,
          level: LoggerLevel.WARN,
          payload: 'Android plugin not available',
        );
        return false;
      }

      final granted = await androidImplementation
          .requestNotificationsPermission();

      if (granted == true) {
        AvenueLogger.log(
          event: 'NOTIFICATION_PERMISSION_GRANTED',
          layer: LoggerLayer.SYNC,
          payload: 'Notification permission granted',
        );
        return true;
      } else {
        AvenueLogger.log(
          event: 'NOTIFICATION_PERMISSION_DENIED',
          layer: LoggerLayer.SYNC,
          level: LoggerLevel.WARN,
          payload: 'Notification permission denied',
        );
        return false;
      }
    } catch (e) {
      AvenueLogger.log(
        event: 'NOTIFICATION_PERMISSION_ERROR',
        layer: LoggerLayer.SYNC,
        level: LoggerLevel.ERROR,
        payload: 'Permission request failed: $e',
      );
      return false;
    }
  }

  /// Shows an instant notification
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = fln.AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: fln.Importance.high,
        priority: fln.Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      const notificationDetails = fln.NotificationDetails(
        android: androidDetails,
        linux: fln.LinuxNotificationDetails(),
      );

      await _notifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );

      AvenueLogger.log(
        event: 'NOTIFICATION_SHOWN',
        layer: LoggerLayer.SYNC,
        payload: 'Instant notification shown: $title',
      );
    } catch (e) {
      AvenueLogger.log(
        event: 'NOTIFICATION_SHOW_ERROR',
        layer: LoggerLayer.SYNC,
        level: LoggerLevel.ERROR,
        payload: 'Failed to show notification: $e',
      );
      rethrow;
    }
  }

  /// Schedules a notification at a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      if (scheduledTime.isBefore(DateTime.now())) {
        throw ArgumentError('Scheduled time must be in the future');
      }

      final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

      const androidDetails = fln.AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: fln.Importance.high,
        priority: fln.Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      const notificationDetails = fln.NotificationDetails(
        android: androidDetails,
        linux: fln.LinuxNotificationDetails(),
      );

      try {
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzScheduledTime,
          notificationDetails: notificationDetails,
          androidScheduleMode: fln.AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      } on UnimplementedError {
        AvenueLogger.log(
          event: 'NOTIFICATION_SCHEDULE_SKIPPED',
          layer: LoggerLayer.SYNC,
          level: LoggerLevel.WARN,
          payload: 'Scheduled notifications not supported on this platform',
        );
        return;
      }

      AvenueLogger.log(
        event: 'NOTIFICATION_SCHEDULED',
        layer: LoggerLayer.SYNC,
        payload: {
          'id': id,
          'title': title,
          'targetTime': scheduledTime.toIso8601String(),
          'tzScheduledTime': tzScheduledTime.toString(),
          'localTimeZone': tz.local.name,
        },
      );
    } catch (e) {
      AvenueLogger.log(
        event: 'NOTIFICATION_SCHEDULE_ERROR',
        layer: LoggerLayer.SYNC,
        level: LoggerLevel.ERROR,
        payload: 'Failed to schedule notification: $e',
      );
      rethrow;
    }
  }

  /// Cancels a specific notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id: id);
      AvenueLogger.log(
        event: 'NOTIFICATION_CANCELLED',
        layer: LoggerLayer.SYNC,
        payload: 'Notification $id cancelled',
      );
    } catch (e) {
      AvenueLogger.log(
        event: 'NOTIFICATION_CANCEL_ERROR',
        layer: LoggerLayer.SYNC,
        level: LoggerLevel.ERROR,
        payload: 'Failed to cancel notification: $e',
      );
      rethrow;
    }
  }

  /// Cancels all scheduled notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      AvenueLogger.log(
        event: 'NOTIFICATION_CANCEL_ALL_SUCCESS',
        layer: LoggerLayer.SYNC,
        payload: 'All notifications cancelled',
      );
    } catch (e) {
      AvenueLogger.log(
        event: 'NOTIFICATION_CANCEL_ALL_ERROR',
        layer: LoggerLayer.SYNC,
        level: LoggerLevel.ERROR,
        payload: 'Failed to cancel all notifications: $e',
      );
      rethrow;
    }
  }

  /// Handles notification tap events
  void _onNotificationTapped(fln.NotificationResponse response) {
    AvenueLogger.log(
      event: 'NOTIFICATION_TAPPED',
      layer: LoggerLayer.SYNC,
      payload: {'payload': response.payload},
    );
  }
}
