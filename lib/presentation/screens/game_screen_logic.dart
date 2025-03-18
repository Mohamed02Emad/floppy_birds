import 'dart:async';

import 'package:floppy_birds/core/extentions/key.dart';
import 'package:flutter/cupertino.dart';

import '../../core/physics/collapse_detector.dart';
import '../widgets/tower.dart';

mixin GameScreenLogic {
  Timer? timer;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<bool> isPaused = ValueNotifier(true);
  ValueNotifier<List<Tower>> towers = ValueNotifier([]);
  final GlobalKey groundKey = GlobalKey();
  final GlobalKey skyKey = GlobalKey();
  List<GlobalKey> pointKeys = [];
  final GlobalKey birdKey = GlobalKey();
  ValueNotifier<Offset?> birdPosition = ValueNotifier(null);
  late final ScrollController scrollController;
  late final CollapseDetector collapseDetector;
  late final CollapseDetector pointsDetector;

  void initScrollController() {
    scrollController = ScrollController();
  }

  void startGeneratingTowers() {
    if (timer != null && timer!.isActive) return;
    _updateTowersList();
    _startGameLifeCycle();
  }

  void _startGameLifeCycle() {
    timer = Timer.periodic(
      const Duration(milliseconds: 2500),
      (_) {
        _updateTowersList();
        _scrollPixels();
      },
    );
  }

  void _updateTowersList() {
    _checkTowersToRemove();
    _addNewTowerToTowers();
    collapseDetector.updateObstacleList(
      _getTowersKeys(),
    );
  }

  void _scrollPixels() {
    scrollController.animateTo(
      scrollController.offset + 300,
      duration: const Duration(milliseconds: 2500),
      curve: Curves.linear,
    );
  }

  void stopGame() {
    isPaused.value = true;
    _stopGenerationTimer();
    stopDetectors();
  }

  void _stopGenerationTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    scrollController.jumpTo(0);
  }

  void stopDetectors() {
    collapseDetector.stopDetecting();
    pointsDetector.stopDetecting();
  }

  void startDetectors() {
    collapseDetector.startDetecting();
    pointsDetector.startDetecting();
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
    pointsDetector.updateObstacleList(pointKeys);
    print(pointKeys.length);
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

  void reset() {
    score.value = 0;
    towers.value.clear();
    pointKeys.clear();
    startDetectors();
  }
}
