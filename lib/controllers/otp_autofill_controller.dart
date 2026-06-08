import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPAutofillController extends GetxController with CodeAutoFill implements GetxService {
  String currentCode = '';
  final TextEditingController otpController = TextEditingController();
  bool isResendOtpEnabled = false;
  int resendOtpTimer = 30;
  Timer? timer;
  bool isTextVisible = true;

  //----------------otp auto fill--------------

  @override
  void codeUpdated() {
    if (code != null) {
      currentCode = code!;
      update();
    }
  }

  updateCurrentCode(String smsCode) {
    currentCode = smsCode;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    listenSmsOTP();
  }

  //----listen otp
  listenSmsOTP() async {
    log('Call');
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() async {
    super.dispose();
    cancel();
    await SmsAutoFill().unregisterListener();
    timer?.cancel();
  }

  void initCurrentCode() {
    currentCode = '';
    timer?.cancel();
    update();
  }

  //-------------------timer--------------
  void startResendOtpTimer() {
    isResendOtpEnabled = false;
    isTextVisible = true;
    resendOtpTimer = 30;
    update();
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTimer == 0) {
        isResendOtpEnabled = true;
        isTextVisible = false;
        update();
        timer.cancel();
      } else {
        resendOtpTimer--;
        update();
      }
    });
  }

  Future<String> getAppSignature() async {
    return await SmsAutoFill().getAppSignature;
  }
}
