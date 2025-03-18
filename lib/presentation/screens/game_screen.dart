import 'dart:async';

import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:floppy_birds/core/extentions/key.dart';
import 'package:floppy_birds/core/physics/gravity.dart';
import 'package:floppy_birds/presentation/cubits/detectors/detectors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/resources/gen/assets.gen.dart';
import '../widgets/game_background.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/tower.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? timer;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<List<Tower>> towers = ValueNotifier([]);
  final GlobalKey groundKey = GlobalKey();
  final GlobalKey skyKey = GlobalKey();
  List<GlobalKey> pointKeys = [];
  final GlobalKey birdKey = GlobalKey();
  ValueNotifier<Offset?> birdPosition = ValueNotifier(null);
  late final ScrollController scrollController;

  @override
  void initState() {
    _initDetectors();
    _startGeneratingTowers();
    _initScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBirdPosition();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _applyVerticalForceOnBird(-50);
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
            ).withGravityForce(
              birdPosition,
            ),
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
                child: ValueListenableBuilder(
                  valueListenable: score,
                  builder: (context, value, child) {
                    return Text(
                      value.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _initDetectors() {
    context.read<DetectorsCubit>().initDetectors(
        birdKey: birdKey, onAddPoint: _onAddPoint, onCollapse: _onCollapsed);
  }

  void _onAddPoint() {
    if (pointKeys.isNotEmpty) pointKeys.removeAt(0);
    score.value++;
    context.read<DetectorsCubit>().pointsDetector.updateObstacleList(pointKeys);
  }

  void _onCollapsed() {
    GameOverDialog.show(context, onRestartClicked: restart);
    stopGame();
  }

  void _startGeneratingTowers() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(
      const Duration(milliseconds: 3100),
      (_) {
        _updateTowersList();
        _scrollPixels();
      },
    );
  }

  void _updateTowersList() {
    final detectorsCubit = context.read<DetectorsCubit>();
    _checkTowersToRemove();
    _addNewTowerToTowers();
    detectorsCubit.collapseDetector.updateObstacleList(_getTowersKeys());
  }

  void _scrollPixels() {
    scrollController.animateTo(
      scrollController.offset + 300,
      duration: const Duration(milliseconds: 3100),
      curve: Curves.linear,
    );
  }

  void _initScrollController() {
    scrollController = ScrollController();
  }

  void _initBirdPosition() {
    final dy = context.deviceHeight * 0.5;
    birdPosition.value = Offset(100, dy);
  }

  void stopGame() {
    _stopGenerationTimer();
    _stopDetectors();
  }

  void _stopGenerationTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    scrollController.jumpTo(0);
  }

  void _stopDetectors() {
    final detectorsCubit = context.read<DetectorsCubit>();
    detectorsCubit.collapseDetector.stopDetecting();
    detectorsCubit.pointsDetector.stopDetecting();
  }

  void _startDetectors() {
    final detectorsCubit = context.read<DetectorsCubit>();
    detectorsCubit.collapseDetector.startDetecting();
    detectorsCubit.pointsDetector.startDetecting();
  }

  void restart() {
    _reset();
    _startGeneratingTowers();
  }

  void _reset() {
    score.value = 0;
    towers.value.clear();
    pointKeys.clear();
    _initBirdPosition();
    _startDetectors();
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

  void _addNewTowerToTowers() {
    towers.value = [
      ...towers.value,
      _generateTower(),
    ];
  }

  Tower _generateTower() {
    final pointKey = GlobalKey();
    pointKeys.add(pointKey);
    context.read<DetectorsCubit>().pointsDetector.updateObstacleList(pointKeys);
    return Tower(
        key: GlobalKey(),
        upperKey: GlobalKey(),
        pointKey: pointKey,
        lowerKey: GlobalKey());
  }

  void _checkTowersToRemove() {
    final List<Tower> towersToRemove = [];
    for (var tower in towers.value) {
      if (!_isTowerInScreenBounds(tower)) break;
      towersToRemove.add(tower);
    }
    _removeTowers(towersToRemove);
  }

  bool _isTowerInScreenBounds(Tower tower) {
    return tower.key?.isOutToTheLeft() ?? true;
  }

  void _removeTowers(List<Tower> towersToRemove) {
    if (towersToRemove.isEmpty) return;
    towersToRemove.forEach(
      (element) => towers.value.remove(element),
    );
    towers.value = [...towers.value];
  }

  List<GlobalKey> _getTowersKeys() {
    return [
      ...towers.value.map((tower) => tower.lowerKey),
      ...towers.value.map((tower) => tower.upperKey),
      groundKey,
      skyKey
    ];
  }
}
