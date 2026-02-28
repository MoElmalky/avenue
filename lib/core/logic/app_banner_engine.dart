import 'dart:async';

/// Represents a single banner state.
/// Can be persistent (offline) or temporary (restored connection).
class BannerState {
  /// Unique identifier for this banner
  final String id;

  /// Whether this banner should persist until explicitly cleared
  final bool isPersistent;

  /// Duration to show this banner (null = persistent)
  final Duration? displayDuration;

  /// Creation timestamp for ordering
  final DateTime createdAt;

  BannerState({
    required this.id,
    required this.isPersistent,
    this.displayDuration,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// Centralized banner lifecycle engine.
///
/// Manages:
/// - Single active banner state
/// - Temporary banner auto-hide with timer
/// - Timer cancellation and cleanup
/// - Priority (new banners override old)
/// - Race condition protection
/// - Memory leak prevention
///
/// Guarantees:
/// - No duplicate timers
/// - No setState after dispose
/// - Safe timer lifecycle
/// - Mounted-aware state management
class AppBannerEngine {
  /// Currently active banner
  BannerState? _activeBanner;

  /// Timer for auto-hiding temporary banners
  Timer? _hideTimer;

  /// Callback when banner state changes
  /// Return false to reject the state change (optional)
  final void Function(BannerState?)? onStateChanged;

  /// Mounted state of the widget using this engine
  bool _isWidgetMounted = true;

  AppBannerEngine({this.onStateChanged});

  /// Get current active banner
  BannerState? get activeBanner => _activeBanner;

  /// Show a persistent banner (stays until explicitly cleared)
  /// Immediately cancels any existing timer.
  void showPersistent(BannerState banner) {
    assert(banner.isPersistent, 'Banner must be persistent');

    // Always cancel existing timer first
    _hideTimer?.cancel();
    _hideTimer = null;

    // Guard: only proceed if widget is still mounted
    if (!_isWidgetMounted) return;

    // Update active banner
    _activeBanner = banner;
    onStateChanged?.call(banner);
  }

  /// Show a temporary banner that auto-hides after displayDuration.
  /// Immediately cancels any existing timer.
  /// Prevents duplicate timers by assigning null after cancel.
  void showTemporary(BannerState banner) {
    assert(!banner.isPersistent && banner.displayDuration != null,
        'Banner must be temporary with displayDuration');

    // Always cancel existing timer first
    _hideTimer?.cancel();
    _hideTimer = null;

    // Guard: only proceed if widget is still mounted
    if (!_isWidgetMounted) return;

    // Show the banner
    _activeBanner = banner;
    onStateChanged?.call(banner);

    // Schedule auto-hide after duration
    _hideTimer = Timer(banner.displayDuration!, () {
      // Double-check: mounted guard in timer callback
      if (!_isWidgetMounted) return;

      // Clear banner and notify
      _activeBanner = null;
      onStateChanged?.call(null);
    });
  }

  /// Immediately hide the active banner and cancel any pending timer.
  /// Useful for explicit dismissal or override scenarios.
  void clear() {
    // Cancel timer
    _hideTimer?.cancel();
    _hideTimer = null;

    // Clear banner
    _activeBanner = null;

    // Guard: only notify if widget is still mounted
    if (_isWidgetMounted) {
      onStateChanged?.call(null);
    }
  }

  /// Check if a banner with given id is currently active
  bool isActive(String bannerId) {
    return _activeBanner?.id == bannerId;
  }

  /// Notify the engine that the widget is still mounted.
  /// Call this from widget's build method or when widget state changes.
  void markMounted() {
    _isWidgetMounted = true;
  }

  /// Notify the engine that the widget is being disposed.
  /// Automatically cancels all timers and clears state.
  void dispose() {
    _isWidgetMounted = false;
    _hideTimer?.cancel();
    _hideTimer = null;
    _activeBanner = null;
  }
}
