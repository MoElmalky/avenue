/// Represents a single banner to display.
class AppBanner {
  /// Unique identifier for this banner
  final String id;

  /// Whether this banner persists until explicitly cleared
  final bool isPersistent;

  /// Duration to auto-hide this banner (null = persistent)
  final Duration? displayDuration;

  /// Creation timestamp for ordering
  final DateTime createdAt;

  AppBanner({
    required this.id,
    required this.isPersistent,
    this.displayDuration,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppBanner &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isPersistent == other.isPersistent &&
          displayDuration == other.displayDuration &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      isPersistent.hashCode ^
      displayDuration.hashCode ^
      createdAt.hashCode;
}
