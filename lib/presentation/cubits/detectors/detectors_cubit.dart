import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/physics/collapse_detector.dart';

part 'detectors_state.dart';

class DetectorsCubit extends Cubit<DetectorsState> {
  DetectorsCubit() : super(DetectorsInitial());

  late final CollapseDetector collapseDetector;
  late final CollapseDetector pointsDetector;

  void initDetectors({
    required GlobalKey birdKey,
    required Function() onAddPoint,
    required Function() onCollapse,
  }) {
    _initCollapseDetector(birdKey: birdKey, onCollapse: onCollapse);
    _initPointsDetector(birdKey: birdKey, onAddPoint: onAddPoint);
  }

  void _initCollapseDetector({
    required GlobalKey birdKey,
    required Function() onCollapse,
  }) {
    collapseDetector = CollapseDetector(
      targetKey: birdKey,
      obstacles: [],
      onCollapse: onCollapse,
    )..startDetecting();
  }

  void _initPointsDetector({
    required GlobalKey birdKey,
    required Function() onAddPoint,
  }) {
    pointsDetector = CollapseDetector(
      targetKey: birdKey,
      obstacles: [],
      onCollapse: () {
        onAddPoint();
      },
    )..startDetecting();
  }
}
