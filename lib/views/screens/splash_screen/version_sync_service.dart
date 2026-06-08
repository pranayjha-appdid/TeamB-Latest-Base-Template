import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import '../../../controllers/basic_controller.dart';

class VersionSyncService {
  static Future<void> runUpgradeCheckInBackground() async {
    try {
      final basicCtrl = Get.find<BasicController>();
      final bool isAndroid = Platform.isAndroid;
      final upgrader = Upgrader();
      await upgrader.initialize();

      final storeVersion = upgrader.currentAppStoreVersion;
      final businessSettingVersion = isAndroid ? basicCtrl.getBusinessSettingValue('full_app_version_android') : basicCtrl.getBusinessSettingValue('full_app_version_ios');

      log("========== VERSION CHECK ==========");
      log("Current App Version: $storeVersion");
      log("Business Settings Version: $businessSettingVersion");

      if (storeVersion != null && businessSettingVersion != null) {
        final shouldSync = _isStoreVersionGreater(storeVersion, businessSettingVersion);
        if (shouldSync) {
          dynamic data = {
            "app_type": "user",
            if (Platform.isAndroid) ...{
              "full_app_version_android": storeVersion,
              "app_version_android": basicCtrl.getBusinessSettingValue('upcoming_build_number_android'),
            } else ...{
              "full_app_version_ios": storeVersion,
              "app_version_ios": basicCtrl.getBusinessSettingValue('upcoming_build_number_ios'),
            },
          };

          await basicCtrl.updateBusinessseetingValue(data);

          log("UPDATE AVAILABLE");
        } else {
          log("APP IS UP TO DATE");
        }
      }
    } catch (e, s) {
      log("Upgrade check failed", error: e, stackTrace: s);
    }
  }

  static bool _isStoreVersionGreater(String storeVersion, String businessVersion) {
    final storeParts = storeVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final businessParts = businessVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = storeParts.length > businessParts.length ? storeParts.length : businessParts.length;

    while (storeParts.length < maxLength) {
      storeParts.add(0);
    }

    while (businessParts.length < maxLength) {
      businessParts.add(0);
    }

    for (int i = 0; i < maxLength; i++) {
      if (storeParts[i] > businessParts[i]) {
        return true;
      }

      if (storeParts[i] < businessParts[i]) {
        return false;
      }
    }

    return false;
  }
}
