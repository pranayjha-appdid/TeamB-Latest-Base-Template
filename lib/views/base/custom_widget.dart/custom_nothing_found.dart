import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../custom_widget.dart/custom_image.dart';

class CustomNothingFound extends StatelessWidget {
  const CustomNothingFound({super.key, this.assets = Assets.imagesNothingFound, this.text = 'Uh Oh! Nothing found', this.isLottie = false, this.subtext = "We couldn’t find what you were looking for "});
  final String assets;
  final String text;
  final bool isLottie;
  final String? subtext;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLottie == false) CustomImage(path: assets, height: 170, width: 300) else LottieBuilder.asset(assets, height: 200, width: 350, fit: BoxFit.fill),
          Text(text, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Color(0xff565656) ,fontWeight: FontWeight.w800 ), textAlign: TextAlign.center),
          if (subtext != null) ...[Text(subtext!, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Color(0xffB7B7B7)), textAlign: TextAlign.center)],
        ],
      ),
    );
  }
}
