import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/base/dialogs/request_permission_dialog.dart';

class PermissionController extends GetxController implements GetxService {
  Future<bool> getPermission(Permission permission, BuildContext context) async {
    PermissionStatus? status;
    await (Future.value(await permission.isGranted || await permission.isLimited)).then((value) async {
      if (!value) {
        bool result = await showDialog(
              context: context,
              builder: (context) => RequestPermissionDialog(
                permission: permission.toString().split('.').last.toString(),
              ),
            ) ?? false;
        if (result) {
          status = await permission.request();
        }
        log("-----$status-----", name: permission.toString());
      } else {
        log("-----Granted-----", name: permission.toString());
      }
    });

    bool isGranted = permission == Permission.photos
        ? (await permission.isLimited || await permission.isGranted)
        : await permission.isGranted;
    return Future.value(isGranted);
  }
}
