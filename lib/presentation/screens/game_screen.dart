import 'dart:async';

import 'package:floppy_birds/presentation/widgets/tower.dart';
import 'package:flutter/material.dart';

import '../widgets/game_background.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Tower> towers = [];
  Timer? timer;

  @override
  void initState() {
    _startGeneratingTowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameBackground(),
        Positioned.fill(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: towers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 250.0),
                child: towers[index],
              );
            },
          ),
        ),
      ],
    );
  }

  void _startGeneratingTowers() {
    timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) {
        print("new tower added");
        towers.add(Tower());
      },
    );
  }
}
