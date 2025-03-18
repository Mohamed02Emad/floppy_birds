import 'dart:async';

import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:floppy_birds/core/physics/gravity.dart';
import 'package:flutter/material.dart';

import '../../core/physics/collapse_detector.dart';
import '../../core/resources/gen/assets.gen.dart';
import '../widgets/game_background.dart';
import '../widgets/game_over_dialog.dart';
import 'game_screen_logic.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with GameScreenLogic {
  @override
  void initState() {
    initScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDetectors();
      isPaused.value = false;
      startGeneratingTowers();
      _initBirdPosition();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _applyVerticalForceOnBird(-100);
        },
        child: Stack(
          children: [
            GameBackground(),
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: towers,
                builder: (context, value, child) => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 250),
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 200.0),
                      child: value[index],
                    );
                  },
                ),
              ),
            ),
            Image.asset(
              key: birdKey,
              Assets.images.bird.path,
              height: context.deviceHeight * 0.04,
              fit: BoxFit.fitHeight,
            ).withGravityForce(birdPosition, isPaused: isPaused),
            Positioned(
                bottom: -80,
                left: 0,
                right: 0,
                child: Container(
                  key: groundKey,
                  height: 100,
                  child: Image.asset(
                    Assets.images.base.path,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  width: double.infinity,
                )),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  key: skyKey,
                  height: 100,
                  width: double.infinity,
                )),
            Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: score,
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _initDetectors() {
    _initCollapseDetector();
    _initPointsDetector();
  }

  void _initPointsDetector() {
    pointsDetector = CollapseDetector(
        targetKey: birdKey, obstacles: [], onCollapse: _onAddPoint)
      ..startDetecting();
  }

  void _initBirdPosition() {
    final dy = context.deviceHeight * 0.5;
    birdPosition.value = Offset(100, dy);
  }

  void _initCollapseDetector() {
    collapseDetector = CollapseDetector(
      targetKey: birdKey,
      obstacles: [],
      onCollapse: _onCollapsed,
    )..startDetecting();
  }

  void _onAddPoint() {
    print('kkk');
    if (pointKeys.isNotEmpty) pointKeys.removeAt(0);
    score.value = score.value + 1;
    pointsDetector.updateObstacleList(pointKeys);
  }

  void _onCollapsed() {
    GameOverDialog.show(context, onRestartClicked: restart);
    stopGame();
  }

  void _applyVerticalForceOnBird(double force) {
    final duration = Duration(milliseconds: 250);
    final steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final stepForce = force / steps;
    _addForceGradually(steps, stepDuration, stepForce);
  }

  void _addForceGradually(int steps, int stepDuration, double stepForce) {
    for (int i = 0; i < steps; i++) {
      Future.delayed(Duration(milliseconds: i * stepDuration), () {
        birdPosition.value = Offset(100,
            (birdPosition.value?.dy ?? context.deviceHeight / 2) + stepForce);
      });
    }
  }

  void restart() {
    reset();
    isPaused.value = false;
    _initBirdPosition();
    startGeneratingTowers();
  }
}
