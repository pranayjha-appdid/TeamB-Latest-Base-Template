import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:raigadkar/controllers/basic_controller.dart';
import 'package:raigadkar/controllers/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/otp_autofill_controller.dart';
import '../controllers/permission_controller.dart';
import '../data/api/api_calls.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/basic_repo.dart';
import 'constants.dart';

class Init {
  getBaseUrl() async {
    ApiCalls calls = ApiCalls();
    await calls.apiCallWithResponseGet('https://fishcary.com/fishcary/api/link2.php?for=true').then((value) {
      log(value.toString());
      AppConstants().setBaseUrl = jsonDecode(value)['link'];
      log(AppConstants().getBaseUrl, name: 'BASE');
    });
  }

  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);
    try {
      //-------Repos--------------
      Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
      Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
      Get.lazyPut(() => BasicRepo(apiClient: Get.find()));

      //--------Controllers-----------
      Get.lazyPut(() => PermissionController());
      Get.lazyPut(() => AuthController(authRepo: Get.find()));
      Get.lazyPut(() => BasicController(basicRepo: Get.find()));
      Get.lazyPut(() => NotificationController());
      Get.lazyPut(() => OTPAutofillController());

    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }

  stopAppRotation() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  intializeAppBuildInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppConstants.version = packageInfo.version;
    AppConstants.buildNumber = packageInfo.buildNumber;
  }
}
