import 'package:flutter/material.dart';

import '../../../../services/theme.dart';

class OnboardingProgressBar extends StatelessWidget {
  final double currentProgress;
  final VoidCallback onNext;

  const OnboardingProgressBar({super.key, required this.currentProgress, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: CircularProgressIndicator(
              value: currentProgress,
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              backgroundColor: Colors.transparent,
              strokeCap: StrokeCap.butt,
            ),
          ),

          GestureDetector(
            onTap: onNext,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
