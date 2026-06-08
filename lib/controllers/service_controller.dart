import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/base/custom_widget.dart/camera_screen.dart';
import 'permission_controller.dart';

export 'package:image_picker/image_picker.dart';

class ServiceController {
  final picker = ImagePicker();

  Future<File?> pickImage(ImageSource source, BuildContext context) async {
    XFile? pickedFile;
    bool permission = false;
    if (source == ImageSource.camera) {
      permission = await Get.find<PermissionController>()
          .getPermission(Permission.camera, context);
    } else {
      permission = await (Platform.isAndroid
          ? Future.value(true)
          : Get.find<PermissionController>()
              .getPermission(Permission.photos, context));
    }
    if (permission) {
      if (source == ImageSource.camera) {
        File? data = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CameraScreen()));
        return data;
      } else {
        pickedFile = await picker.pickImage(source: source, imageQuality: 25);
        return pickedFile != null ? File(pickedFile.path) : null;
      }
    } else {
      Fluttertoast.showToast(msg: "User Denied Permission");
    }

    return null;
  }

  Future<List<XFile>> getMultiImage() async {
    final pickedFile = await picker.pickMultiImage(imageQuality: 25);
    return pickedFile;
  }

  Future<DateTime> selectDate(context,
      {DateTime? startData, DateTime? endDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: startData ?? DateTime.now().add(const Duration(minutes: 1)),
      lastDate: endDate ??
          DateTime.now().add(
            const Duration(days: 60),
          ),
    );
    return pickedDate!;
  }

  Future<String?> selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay == null) {
      return null;
    } else {
      return DateFormat('HH:mm')
          // ignore: use_build_context_synchronously
          .format(DateFormat("h:mm a").parse(timeOfDay.format(context)));
    }
  }
}
