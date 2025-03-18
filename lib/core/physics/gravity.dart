import 'dart:async';

import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:flutter/material.dart';

extension WidgetGravityExtension on Widget {
  Widget withGravityForce(
    ValueNotifier<Offset?> positionNotifier, {
    required ValueNotifier<bool> isPaused,
  }) {
    return _GravityWidget(
      positionNotifier: positionNotifier,
      isPaused: isPaused,
      child: this,
    );
  }
}

class _GravityWidget extends StatefulWidget {
  final ValueNotifier<Offset?> positionNotifier;
  final ValueNotifier<bool> isPaused;
  final Widget child;

  const _GravityWidget({
    required this.isPaused,
    required this.positionNotifier,
    required this.child,
  });

  @override
  _GravityWidgetState createState() => _GravityWidgetState();
}

class _GravityWidgetState extends State<_GravityWidget> {
  Timer? _timer;
  final double gravity = 2.5;
  final double maxVelocity = 100.0;

  @override
  void initState() {
    super.initState();
    _startGravitySimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGravitySimulation() {
    _timer = Timer.periodic(Duration(milliseconds: 16), (_) {
      if (widget.isPaused.value) return;
      _updatePosition();
    });
  }

  void _updatePosition() {
    final currentPosition = widget.positionNotifier.value;
    final newPosition = _calculateNewPosition(currentPosition);
    widget.positionNotifier.value =
        _applyMaxVelocity(currentPosition, newPosition);
  }

  Offset _calculateNewPosition(Offset? currentPosition) {
    return Offset(
        currentPosition?.dx ?? 0, (currentPosition?.dy ?? 0) + gravity);
  }

  Offset _applyMaxVelocity(Offset? currentPosition, Offset newPosition) {
    if (newPosition.dy - (currentPosition?.dy ?? 0) > maxVelocity) {
      return Offset(
          currentPosition?.dx ?? 0, (currentPosition?.dy ?? 0) + maxVelocity);
    } else {
      return newPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset?>(
      valueListenable: widget.positionNotifier,
      builder: (context, position, child) {
        return Positioned(
          left: position?.dx ?? 100,
          top: position?.dy ?? context.deviceHeight * 0.5,
          child: widget.child,
        );
      },
    );
  }
}
