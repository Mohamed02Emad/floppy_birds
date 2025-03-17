import 'dart:math';

import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../core/resources/gen/assets.gen.dart';

class Tower extends StatelessWidget {
  const Tower({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.deviceHeight;
    final safePathHeight = screenHeight * 0.24;
    final totalTowersHeight = screenHeight - safePathHeight;
    final upperTowerHeight =
        totalTowersHeight - (totalTowersHeight * (Random().nextInt(7) / 10));
    final lowerTowerHeight = totalTowersHeight - upperTowerHeight;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Transform.scale(
          scaleY: -1,
          child: Image.asset(
            Assets.images.pipeGreen.path,
            height: upperTowerHeight,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: safePathHeight,
        ),
        Image.asset(
          Assets.images.pipeGreen.path,
          height: lowerTowerHeight,
          width: 100,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}
