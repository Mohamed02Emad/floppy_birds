import 'package:flutter/cupertino.dart';

extension IntExtention on int {
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());
  Radius get radius => Radius.circular(toDouble());
  Widget get gap => SizedBox(
        height: toDouble(),
        width: toDouble(),
      );

  EdgeInsets get edgeInsetsHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get edgeInsetsVertical =>
      EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get edgeInsetsAll => EdgeInsets.all(toDouble());
  EdgeInsets get edgeInsetsBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get edgeInsetsTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get edgeInsetsLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get edgeInsetsRight => EdgeInsets.only(right: toDouble());
  EdgeInsetsDirectional get edgeInsetsStart =>
      EdgeInsetsDirectional.only(start: toDouble());
  EdgeInsetsDirectional get edgeInsetsEnd =>
      EdgeInsetsDirectional.only(end: toDouble());
  Duration get duration => Duration(milliseconds: this);
  Size get size => Size(toDouble(), toDouble());
}
