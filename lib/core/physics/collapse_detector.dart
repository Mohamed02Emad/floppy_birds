import 'dart:async';

import 'package:flutter/material.dart';

class CollapseDetector {
  final GlobalKey targetKey;
  final List<GlobalKey> obstacles;
  final VoidCallback onCollapse;
  Timer? _collisionTimer;

  CollapseDetector({
    required this.targetKey,
    required this.obstacles,
    required this.onCollapse,
  });

  void updateObstacleList(List<GlobalKey> newObstacles) {
    obstacles
      ..clear()
      ..addAll(newObstacles);
  }

  void startDetecting() {
    if (_collisionTimer == null || !_collisionTimer!.isActive) {
      _collisionTimer = Timer.periodic(Duration(milliseconds: 80), (_) {
        _checkCollision();
      });
    }
  }

  void stopDetecting() {
    _collisionTimer?.cancel();
  }

  void _checkCollision() {
    final targetRenderBox = _getRenderBox(targetKey);
    if (targetRenderBox != null) {
      final targetRect = _getRect(
        targetRenderBox,
      );
      _checkObstaclesCollision(targetRect);
    }
  }

  void _checkObstaclesCollision(Rect targetRect) {
    for (final key in obstacles) {
      if (_checkSingleObstacleCollision(targetRect, key)) {
        onCollapse();
        stopDetecting();
        break;
      }
    }
  }

  bool _checkSingleObstacleCollision(Rect targetRect, GlobalKey key) {
    final otherRenderBox = _getRenderBox(key);
    if (otherRenderBox == null) return false;
    final otherRect = _getRect(otherRenderBox, printLog: true);
    final collapsed = _isCollision(targetRect, otherRect);
    if (collapsed)
      print(
          'bird ${targetRect.top} ${targetRect.bottom} : towers ${otherRect.top} ${otherRect.bottom}');
    return _isCollision(targetRect, otherRect);
  }

  bool _isCollision(Rect targetRect, Rect otherRect) {
    return targetRect.overlaps(otherRect);
  }

  RenderBox? _getRenderBox(GlobalKey key) {
    return key.currentContext?.findRenderObject() as RenderBox?;
  }

  Rect _getRect(RenderBox renderBox, {bool printLog = false}) {
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    if (printLog) {
      print("object size ${size.width}  ${size.height}");
      print("object offset ${offset.dx}  ${offset.dy}");
    }
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }
}
