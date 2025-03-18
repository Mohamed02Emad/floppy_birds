import 'package:flutter/material.dart';

extension keyExtention on Key {
  Offset? getScreenPosition(BuildContext context) {
    final renderObject = getRenderObject();
    if (renderObject == null) return null;
    return renderObject.localToGlobal(Offset.zero);
  }

  bool isOutToTheLeft(BuildContext context) {
    final renderObject = getRenderObject();
    if (renderObject == null) return false;
    final rect = _getRect(renderObject);
    return rect.right < 0;
  }

  bool isInScreenBounds(BuildContext context) {
    final renderObject = getRenderObject();
    if (renderObject == null) return false;
    final rect = _getRect(renderObject);
    final screenRect = _getScreenRect(context);
    return screenRect.overlaps(rect);
  }

  RenderBox? getRenderObject() {
    return (this as GlobalKey).currentContext?.findRenderObject() as RenderBox?;
  }

  Rect _getRect(RenderBox renderObject) {
    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    return offset & size;
  }

  Rect _getScreenRect(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Offset.zero & screenSize;
  }
}
