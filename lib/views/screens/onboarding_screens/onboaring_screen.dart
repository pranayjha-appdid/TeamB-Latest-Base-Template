import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/basic_controller.dart';
import '../../../services/theme.dart';
import '../../base/custom_widget.dart/custom_image.dart';
import 'components/onboadring_progress_widget.dart';
import 'components/onboarding_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      Get.find<AuthController>().setFirstTimeVisit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(child: CustomImage(path: Assets.imagesLogo, width: 140, height: 100)),

                      // Skip Button
                      GestureDetector(
                        onTap: () {
                          Get.find<AuthController>().setFirstTimeVisit();
                          controller.skipToLogin(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: blue, width: 1.0)),
                          ),
                          child: Text(
                            "SKIP",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: blue, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // PageView
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) => controller.onPageChanged(index),
                      children: [OnboardingContentCard(imageHeight: 218, imageWidth: 320, image: Assets.imagesLogo, title: "Your Title", description: "Your Description")],
                    ),
                  ),
                  OnboardingProgressBar(
                    currentProgress: controller.currentProgress,
                    onNext: () {
                      Get.find<AuthController>().setFirstTimeVisit();
                      controller.nextPage(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
