import 'dart:math';

import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:floppy_birds/core/widgets/animations/fade.dart';
import 'package:floppy_birds/core/widgets/animations/slide.dart';
import 'package:flutter/material.dart';

import '../../core/resources/gen/assets.gen.dart';

class Tower extends StatefulWidget {
  final GlobalKey upperKey, lowerKey;
  final int id;
  const Tower(
      {super.key,
      required this.upperKey,
      required this.lowerKey,
      required this.id});

  @override
  State<Tower> createState() => _TowerState();
}

class _TowerState extends State<Tower> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = context.deviceHeight;
    final safePathHeight = screenHeight * 0.24;
    final totalTowersHeight = screenHeight - safePathHeight;
    final upperTowerHeight = totalTowersHeight -
        totalTowersHeight * (((Random().nextInt(6) + 1) / 10));
    final lowerTowerHeight = totalTowersHeight - upperTowerHeight;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        FadeAppearWrapper(
          beginOpacity: 0.8,
          endOpacity: 1,
          child: SlideWrapper(
            slideDirection: SlideDirection.down,
            initialOffset: upperTowerHeight,
            startAnimationDelay: Duration(milliseconds: 1000),
            child: Transform.scale(
              scaleY: -1,
              child: Image.asset(
                Assets.images.pipeGreen.path,
                height: upperTowerHeight,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(
          height: safePathHeight,
        ),
        FadeAppearWrapper(
          beginOpacity: 0.8,
          endOpacity: 1,
          child: SlideWrapper(
            slideDirection: SlideDirection.up,
            initialOffset: lowerTowerHeight,
            startAnimationDelay: Duration(milliseconds: 1000),
            child: Image.asset(
              Assets.images.pipeGreen.path,
              height: lowerTowerHeight,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
