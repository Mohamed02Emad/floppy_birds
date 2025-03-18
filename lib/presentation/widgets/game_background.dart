import 'package:floppy_birds/core/extentions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../core/resources/gen/assets.gen.dart';

class GameBackground extends StatelessWidget {
  const GameBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final dayImage = Assets.images.backgroundDay;
    final int numberOfImages =
        (context.deviceWidth / (dayImage.size?.width ?? 288)).ceil();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: numberOfImages,
      itemBuilder: (context, index) {
        return Image.asset(
          dayImage.path,
          height: context.deviceHeight,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
