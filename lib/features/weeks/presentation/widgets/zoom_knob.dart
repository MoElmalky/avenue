import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double _defaultZoom = 60.0;

class ZoomKnob extends StatefulWidget {
  final double currentZoom;
  final double minZoom;
  final double maxZoom;
  final double defaultZoom;
  final ValueChanged<double> onZoomChanged;

  const ZoomKnob({
    super.key,
    required this.currentZoom,
    required this.minZoom,
    required this.maxZoom,
    this.defaultZoom = _defaultZoom,
    required this.onZoomChanged,
  });

  @override
  State<ZoomKnob> createState() => _ZoomKnobState();
}

class _ZoomKnobState extends State<ZoomKnob>
    with SingleTickerProviderStateMixin {
  late double _rotationAngle;
  late double _lastFeedbackZoom;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _updateRotationFromZoom(widget.currentZoom);
    _lastFeedbackZoom = widget.currentZoom;

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ZoomKnob oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentZoom != widget.currentZoom) {
      setState(() => _updateRotationFromZoom(widget.currentZoom));
    }
  }

  void _updateRotationFromZoom(double zoom) {
    final normalized =
        (zoom - widget.minZoom) / (widget.maxZoom - widget.minZoom);
    _rotationAngle = normalized * (4 * 2 * math.pi);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    const double sensitivity = 0.9;
    final dy = -details.delta.dy;
    final dx = details.delta.dx;
    final delta = dy.abs() > dx.abs() ? dy : dx;

    double newZoom = widget.currentZoom + (delta * sensitivity);
    newZoom = newZoom.clamp(widget.minZoom, widget.maxZoom);

    if ((newZoom - _lastFeedbackZoom).abs() >= 1.5) {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
      _lastFeedbackZoom = newZoom;
    }

    if (newZoom != widget.currentZoom) {
      widget.onZoomChanged(newZoom);
      setState(() => _updateRotationFromZoom(newZoom));
    }
  }

  void _handleDoubleTap() {
    // Animate a press effect
    _scaleController.forward().then((_) => _scaleController.reverse());
    // Heavy haptic so the user knows the reset happened
    HapticFeedback.mediumImpact();
    // Reset to default
    widget.onZoomChanged(widget.defaultZoom);
    setState(() => _updateRotationFromZoom(widget.defaultZoom));
    _lastFeedbackZoom = widget.defaultZoom;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress =
        (widget.currentZoom - widget.minZoom) /
        (widget.maxZoom - widget.minZoom);

    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onDoubleTap: _handleDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer progress ring
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3.0,
                    backgroundColor: theme.colorScheme.onSurface.withOpacity(
                      0.08,
                    ),
                    color: theme.colorScheme.primary,
                    strokeCap: StrokeCap.round,
                  ),
                ),

                // Rotating inner dial
                Transform.rotate(
                  angle: _rotationAngle,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isDark
                            ? [const Color(0xFF444446), const Color(0xFF2C2C2E)]
                            : [Colors.white, const Color(0xFFEAEAEA)],
                        center: Alignment.topLeft,
                        radius: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.45 : 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.06),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glowing indicator dot
                        Positioned(
                          top: 5,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.65,
                                  ),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
