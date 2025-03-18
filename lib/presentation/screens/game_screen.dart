import 'dart:async';

import 'package:floppy_birds/core/extentions/key.dart';
import 'package:floppy_birds/core/physics/collapse_detector.dart';
import 'package:floppy_birds/presentation/widgets/tower.dart';
import 'package:flutter/material.dart';

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
  final GlobalKey birdKey = GlobalKey();
  Timer? timer;

  late final CollapseDetector collapseDetector;

  late final ScrollController scrollController;

  @override
  void initState() {
    _initCollapseDetector();
    _startGeneratingTowers();
    _initScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _applyVerticalForceOnBird();
      },
      child: Stack(
        children: [
          GameBackground(),
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: towers,
              builder: (context, value, child) => ListView.builder(
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
        ],
      ),
    );
  }

  void _initCollapseDetector() {
    collapseDetector = CollapseDetector(
      targetKey: birdKey,
      obstacles: [],
      onCollapse: _onCollapsed,
    )..startDetecting();
  }

  void _initScrollController() {
    scrollController = ScrollController();
  }

  void _startGeneratingTowers() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(
      const Duration(milliseconds: 2200),
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

  void _applyVerticalForceOnBird() {}

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
    print(
        'at position ${towersToRemove.first.key?.getScreenPosition(context)}');
    towersToRemove.forEach(
      (element) => towers.value.remove(element),
    );
    towers.value = [...towers.value];
  }

  void _onCollapsed() {
    print("Game Over");
  }

  List<GlobalKey<State<StatefulWidget>>> _getTowersKeys() {
    return towers.value
        .map((tower) => tower.key as GlobalKey<State<StatefulWidget>>)
        .toList();
  }

  void _scrollPixels() {
    scrollController.animateTo(
      scrollController.offset + 300,
      duration: const Duration(milliseconds: 2200),
      curve: Curves.linear,
    );
  }
}
