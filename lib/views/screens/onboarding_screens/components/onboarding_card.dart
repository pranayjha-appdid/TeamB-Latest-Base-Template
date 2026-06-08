import 'package:flutter/material.dart';

import '../../../../services/theme.dart';
import '../../../base/custom_widget.dart/custom_image.dart';

class OnboardingContentCard extends StatefulWidget {
  final String image;
  final double? imageWidth;
  final double? imageHeight;
  final String? secondaryImage;
  final String title;
  final String? description;

  const OnboardingContentCard({super.key, required this.image, this.imageWidth, this.imageHeight, this.secondaryImage, required this.title, this.description});

  @override
  State<OnboardingContentCard> createState() => _OnboardingContentCardState();
}

class _OnboardingContentCardState extends State<OnboardingContentCard> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImage(path: widget.image, width: widget.imageWidth ?? 320, height: widget.imageHeight ?? 320),

              if (widget.secondaryImage != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutBack,
                  top: _animate ? 80 : 370,
                  right: _animate ? 65 : -150,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    opacity: _animate ? 1.0 : 0.0,
                    child: CustomImage(path: widget.secondaryImage!, width: 180, height: 200),
                  ),
                ),
            ],
          ),
        ),

        // const SizedBox(height: 10),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: textPrimary, fontWeight: FontWeight.w600),
        ),

        if (widget.description != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.description ?? "",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400, fontSize: 13, color: textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
