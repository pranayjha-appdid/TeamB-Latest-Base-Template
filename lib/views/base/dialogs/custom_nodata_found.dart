import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../custom_widget.dart/custom_image.dart';

class CustomNoDataFoundWidget extends StatelessWidget {
  const CustomNoDataFoundWidget({super.key, this.assets = Assets.lottiesNoDataFound, this.text = 'No Data Found!', this.isLottie = true, this.subtext});
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
          if (isLottie == false) CustomImage(path: assets, height: 250, width: 250) else LottieBuilder.asset(assets, height: 250, width: 250, fit: BoxFit.fill),
          Text(text, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black), textAlign: TextAlign.center),
          if (subtext != null) ...[Text(subtext!, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey), textAlign: TextAlign.center)],
        ],
      ),
    );
  }
}
