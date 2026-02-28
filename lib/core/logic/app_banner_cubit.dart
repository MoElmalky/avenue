import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_banner_state.dart';

/// Global centralized banner manager for the entire app.
///
/// Single instance, registered in DI, injected everywhere.
/// Manages:
/// - One active banner at a time
/// - Temporary banners with auto-hide timer
/// - Persistent banners (stay until explicitly cleared)
/// - Timer lifecycle (cancel before assign, cancel on close)
/// - Race condition protection
/// - Memory leak prevention
///
/// Features must use context.read<AppBannerCubit>() to show/clear banners.
/// No widget-level engine instances.
/// No widget lifecycle awareness.
class AppBannerCubit extends Cubit<AppBanner?> {
  /// Timer for auto-hiding temporary banners
  Timer? _hideTimer;

  AppBannerCubit() : super(null);

  /// Show a persistent banner (stays until explicitly cleared).
  /// Immediately cancels any existing timer.
  void showPersistent(AppBanner banner) {
    assert(banner.isPersistent, 'Banner must be persistent');

    // Always cancel existing timer first (race condition protection)
    _hideTimer?.cancel();
    _hideTimer = null;

    // Emit new banner
    emit(banner);
  }

  /// Show a temporary banner that auto-hides after displayDuration.
  /// Immediately cancels any existing timer (no duplicate timers).
  void showTemporary(AppBanner banner) {
    assert(
      !banner.isPersistent && banner.displayDuration != null,
      'Banner must be temporary with displayDuration',
    );

    // Always cancel existing timer first
    _hideTimer?.cancel();
    _hideTimer = null;

    // Emit banner
    emit(banner);

    // Schedule auto-hide after duration
    _hideTimer = Timer(banner.displayDuration!, () {
      // Only emit null if state hasn't changed (still same banner)
      if (state?.id == banner.id) {
        emit(null);
      }
    });
  }

  /// Immediately hide the active banner and cancel any pending timer.
  void clear() {
    // Cancel timer
    _hideTimer?.cancel();
    _hideTimer = null;

    // Clear banner
    emit(null);
  }

  /// Override current banner with a new persistent one.
  /// Useful when priority banners (like offline) must override temporary ones.
  void overrideBanner(AppBanner banner) {
    assert(banner.isPersistent, 'Override must use persistent banner');

    // Cancel any pending timer
    _hideTimer?.cancel();
    _hideTimer = null;

    // Immediately show new banner
    emit(banner);
  }

  /// Check if a banner with given id is currently active
  bool isActive(String bannerId) {
    return state?.id == bannerId;
  }

  /// Cancel timer and clear state when cubit is disposed
  @override
  Future<void> close() async {
    _hideTimer?.cancel();
    _hideTimer = null;
    return super.close();
  }
}
