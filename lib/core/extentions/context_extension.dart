import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void closeKeyboard() {
    FocusScope.of(this).unfocus();
  }

  bool get isArabic {
    return EasyLocalization.of(this)?.currentLocale?.languageCode == 'ar';
  }

  List<BoxShadow> get boxShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 4,
          spreadRadius: 4,
          offset: const Offset(0, 2),
        )
      ];

  double get deviceWidth {
    return MediaQuery.of(this).size.width;
  }

  double get deviceHeight {
    return MediaQuery.of(this).size.height;
  }

  Orientation get deviceOrientation {
    return MediaQuery.of(this).orientation;
  }

  double get statusBarHeight {
    return MediaQuery.of(this).padding.top;
  }

  double get viewPaddingBottom {
    return MediaQuery.of(this).padding.bottom;
  }

  Brightness get platformBrightness {
    return MediaQuery.of(this).platformBrightness;
  }
}
