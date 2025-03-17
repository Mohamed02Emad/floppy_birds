import 'package:flutter/cupertino.dart';

extension DoubleExtention on double {
  BorderRadius get borderRadius => BorderRadius.circular(this);
  Radius get radius => Radius.circular(this);
  Widget get gap => SizedBox(
        height: this,
        width: this,
      );

  EdgeInsets get edgeInsetsHorizontal => EdgeInsets.symmetric(horizontal: this);
  EdgeInsets get edgeInsetsVertical => EdgeInsets.symmetric(vertical: this);
  EdgeInsets get edgeInsetsAll => EdgeInsets.all(this);
  EdgeInsets get edgeInsetsBottom => EdgeInsets.only(bottom: this);
  EdgeInsets get edgeInsetsTop => EdgeInsets.only(top: this);
  EdgeInsets get edgeInsetsLeft => EdgeInsets.only(left: this);
  EdgeInsets get edgeInsetsRight => EdgeInsets.only(right: this);
  EdgeInsetsDirectional get edgeInsetsStart =>
      EdgeInsetsDirectional.only(start: this);
  EdgeInsetsDirectional get edgeInsetsEnd =>
      EdgeInsetsDirectional.only(end: this);
  Duration get duration => Duration(milliseconds: toInt());
  Size get size => Size(this, this);
}
