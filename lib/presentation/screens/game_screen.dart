import 'dart:async';

import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:floppy_birds/core/extentions/key.dart';
import 'package:floppy_birds/core/physics/collapse_detector.dart';
import 'package:floppy_birds/presentation/widgets/game_over_dialog.dart';
import 'package:floppy_birds/presentation/widgets/tower.dart';
import 'package:flutter/material.dart';

import '../../core/resources/gen/assets.gen.dart';
import '../widgets/game_background.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  ValueNotifier<List<Tower>> towers = ValueNotifier([
    Tower(
        key: GlobalKey(),
        id: DateTime.now().microsecondsSinceEpoch,
        upperKey: GlobalKey(),
        lowerKey: GlobalKey()),
    Tower(
        key: GlobalKey(),
        id: DateTime.now().microsecondsSinceEpoch,
        upperKey: GlobalKey(),
        lowerKey: GlobalKey()),
    Tower(
        key: GlobalKey(),
        id: DateTime.now().microsecondsSinceEpoch,
        upperKey: GlobalKey(),
        lowerKey: GlobalKey()),
  ]);
  ValueNotifier<Offset?> birdPosition = ValueNotifier(null);

  final GlobalKey birdKey = GlobalKey();
  final GlobalKey groundKey = GlobalKey();
  final GlobalKey skyKey = GlobalKey();
  Timer? timer;

  late final CollapseDetector collapseDetector;
  late final ScrollController scrollController;

  @override
  void initState() {
    _initCollapseDetector();
    _startGeneratingTowers();
    _initScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBirdPosition();
    });
    super.initState();
  }

  @override
  void dispose() {
    towers.dispose();
    birdPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _applyVerticalForceOnBird(-100);
      },
      onLongPress: () {
        _applyVerticalForceOnBird(100);
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
          ValueListenableBuilder(
            valueListenable: birdPosition,
            builder: (context, value, child) => Positioned(
              left: value?.dx ?? 100,
              top: value?.dy ?? context.deviceHeight * 0.5,
              child: Image.asset(
                key: birdKey,
                Assets.images.bird.path,
                height: context.deviceHeight * 0.04,
                fit: BoxFit.fitHeight,
              ),
            ),
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
        ],
      ),
    );
  }

  void _initCollapseDetector() {
    collapseDetector = CollapseDetector(
      targetKey: birdKey,
      obstacles: _getTowersKeys(),
      onCollapse: _onCollapsed,
    )..startDetecting();
  }

  void _initScrollController() {
    scrollController = ScrollController();
  }

  void _initBirdPosition() {
    final dy = context.deviceHeight * 0.5;
    birdPosition.value = Offset(100, dy);
  }

  void _startGeneratingTowers() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(
      const Duration(milliseconds: 3100),
      _updateTowersList,
    );
  }

  void _updateTowersList(Timer timer) {
    _checkTowersToRemove();
    _generateTower();
    _scrollPixels();
    collapseDetector.updateObstacleList(_getTowersKeys());
  }

  void _generateTower() {
    towers.value = [
      ...towers.value,
      Tower(
          key: GlobalKey(),
          id: DateTime.now().microsecondsSinceEpoch,
          upperKey: GlobalKey(),
          lowerKey: GlobalKey())
    ];
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
    return tower.key?.isOutToTheLeft(context) ?? true;
  }

  void _removeTowers(List<Tower> towersToRemove) {
    if (towersToRemove.isEmpty) return;
    towersToRemove.forEach(
      (element) => towers.value.remove(element),
    );
    towers.value = [...towers.value];
  }

  void _onCollapsed() {
    GameOverDialog.show(context, onRestartClicked: restart);
    stopGame();
  }

  List<GlobalKey<State<StatefulWidget>>> _getTowersKeys() {
    return [
      ...towers.value.map((tower) => tower.lowerKey),
      ...towers.value.map((tower) => tower.upperKey),
      groundKey,
      skyKey
    ];
  }

  void _scrollPixels() {
    scrollController.animateTo(
      scrollController.offset + 300,
      duration: const Duration(milliseconds: 3100),
      curve: Curves.linear,
    );
  }

  void _applyVerticalForceOnBird(double force) {
    birdPosition.value = Offset(
        100, (birdPosition.value?.dy ?? context.deviceHeight / 2) + force);
  }

  void stopGame() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    scrollController.jumpTo(0);
    collapseDetector.stopDetecting();
  }

  void restart() {
    _startGeneratingTowers();
    _initBirdPosition();
    collapseDetector.startDetecting();
  }
}
