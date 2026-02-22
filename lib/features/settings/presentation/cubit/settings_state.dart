import 'package:equatable/equatable.dart';

enum FeedbackStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final int weekStartDay;
  final bool is24HourFormat;
  final bool notificationsEnabled;
  final FeedbackStatus feedbackStatus;
  final String? feedbackErrorMessage;

  const SettingsState({
    this.weekStartDay = 1, // Default Monday
    this.is24HourFormat = false, // Default 12h
    this.notificationsEnabled = true, // Default enabled
    this.feedbackStatus = FeedbackStatus.initial,
    this.feedbackErrorMessage,
  });

  SettingsState copyWith({
    int? weekStartDay,
    bool? is24HourFormat,
    bool? notificationsEnabled,
    FeedbackStatus? feedbackStatus,
    String? feedbackErrorMessage,
  }) {
    return SettingsState(
      weekStartDay: weekStartDay ?? this.weekStartDay,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      feedbackErrorMessage: feedbackErrorMessage ?? this.feedbackErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    weekStartDay,
    is24HourFormat,
    notificationsEnabled,
    feedbackStatus,
    feedbackErrorMessage,
  ];
}
