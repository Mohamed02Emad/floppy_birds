import 'package:flutter/material.dart';

import '../../core/resources/gen/assets.gen.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog._({super.key, required this.onRestartClicked});

  final Function() onRestartClicked;

  static show(
    BuildContext context, {
    required Function() onRestartClicked,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => GameOverDialog._(
              onRestartClicked: onRestartClicked,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.images.gameover.path),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onRestartClicked();
              },
              child: Text('restart'))
        ],
      ),
    );
  }
}
