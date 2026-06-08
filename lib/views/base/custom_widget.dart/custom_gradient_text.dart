import 'package:flutter/material.dart';

import '../../../services/theme.dart';

class CustomGradientText extends StatelessWidget {
  const CustomGradientText({
    super.key,
    required this.child,
    this.gradiantColor1,
    this.gradiantColor2,
  });
  final Widget child;
  final Color? gradiantColor1;
  final Color? gradiantColor2;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
              colors: <Color>[
                gradiantColor1 ?? primaryColor,
                gradiantColor2 ?? secondaryColor
              ],
            ).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
        child: child);
  }
}
