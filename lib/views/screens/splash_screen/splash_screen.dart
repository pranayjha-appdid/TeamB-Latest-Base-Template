import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:raigadkar/views/screens/splash_screen/version_sync_service.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/basic_controller.dart';
import '../../../services/constants.dart';
import '../../../services/route_helper.dart';
import '../../base/custom_widget.dart/custom_image.dart';
import '../../base/dialogs/maintenance_dialog.dart';
import '../../base/dialogs/update_dialog.dart';
import '../auth_screens/login_screen.dart';
import '../auth_screens/signup_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../onboarding_screens/onboaring_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  Color backgroundColor = const Color(0xff172C41);
  bool visible = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          visible = true;
          startAppInit();
        });
      }
    });
  }

  void navigateToOnboardingScreen() {
    Navigator.pushReplacement(context, getCustomRoute(child: const OnboardingScreen(), type: PageTransitionType.fade, animate: true, duration: const Duration(milliseconds: 800)));
  }

  void startAppInit() {
    Timer.run(() {
      splashInitMethod();
    });
  }

  void splashInitMethod() async {
    final basicCtrl = Get.find<BasicController>();
    basicCtrl.getBussinessSetting().then((value) async {
      if (value.isSuccess) {
        final bool isAndroid = Platform.isAndroid;

        VersionSyncService.runUpgradeCheckInBackground();

        String? appVersionValue = isAndroid ? basicCtrl.getBusinessSettingValue('app_version_android') : basicCtrl.getBusinessSettingValue('app_version_ios');
        String? maintenanceValue = isAndroid ? basicCtrl.getBusinessSettingValue('maintenance_mode_for_android') : basicCtrl.getBusinessSettingValue('maintenance_mode_for_ios');
        String? forceUpdateValue = isAndroid ? basicCtrl.getBusinessSettingValue('force_update_for_android') : basicCtrl.getBusinessSettingValue('force_update_for_ios');
        bool maintenanceMode = maintenanceValue == '1';
        bool isForceUpdate = forceUpdateValue == '1';

        if (maintenanceMode) {
          if (!mounted) return;
          showDialog(barrierDismissible: false, context: context, builder: (context) => const MaintenanceDialog());
        } else if (int.parse(AppConstants.buildNumber) < int.parse(appVersionValue ?? '0')) {
          if (!mounted) return;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => UpdateDialog(remark: 'Please update app to the latest version', skip: !isForceUpdate),
          ).then((value) {
            if (value) {
              initNavigation();
            }
          });
        } else {
          initNavigation();
        }
      }
    });
  }

  Future<void> initNavigation() async {
    final authCtrl = Get.find<AuthController>();
    if (authCtrl.isLoggedIn()) {
      await authCtrl.getUserProfileData().then((value) {
        if (!mounted) return;
        if (value.isSuccess) {
          if (authCtrl.userModel?.name == null) {
            Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const SignUpScreen()), (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const DashboardScreen()), (route) => false);
          }
        } else {
          if (authCtrl.isFirstTimeVisit()) {
            Navigator.of(context).pushAndRemoveUntil(getCustomRoute(child: const OnboardingScreen()), (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(getCustomRoute(child: const LoginScreen()), (route) => false);
          }
        }
      });
    } else {
      if (authCtrl.isFirstTimeVisit()) {
        Navigator.of(context).pushAndRemoveUntil(getCustomRoute(child: const OnboardingScreen()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(getCustomRoute(child: const LoginScreen()), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          // Fade duration
          duration: const Duration(milliseconds: 1500),
          opacity: visible ? 1.0 : 0.0,
          curve: Curves.easeIn,
          child: CustomImage(path: Assets.imagesLogo, width: 250, height: 250),
        ),
      ),
    );
  }
}
