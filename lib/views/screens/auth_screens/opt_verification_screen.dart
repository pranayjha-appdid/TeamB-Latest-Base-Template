import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:raigadkar/services/extensions.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/otp_autofill_controller.dart';
import '../../../services/route_helper.dart';
import '../../../services/theme.dart';
import '../../base/custom_widget.dart/common_button.dart';
import '../../base/custom_widget.dart/custom_image.dart';
import '../../base/custom_widget.dart/custom_toast.dart';
import '../dashboard/dashboard_screen.dart';
import 'signup_screen.dart';

class OTPVerification extends StatefulWidget {
  final String phone;

  const OTPVerification({super.key, required this.phone});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<OTPAutofillController>().startResendOtpTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Timer.run(() {
      Get.find<OTPAutofillController>().currentCode = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<OTPAutofillController>(
          builder: (otpController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: CustomImage(path: Assets.imagesLogo, width: 150, height: 150)),
                ),
                Text(
                  "Verify Your Code",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text("We have sent the verification to +91 ${widget.phone}", style: Theme.of(context).textTheme.titleSmall!.copyWith()),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Text("Change Phone Number?", style: Theme.of(context).textTheme.titleSmall!.copyWith(color: primaryColor)),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PinFieldAutoFill(
                      keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true, decimal: true) : TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      cursor: Cursor(width: 2, height: 20, color: primaryColor, radius: const Radius.circular(1), enabled: true),
                      currentCode: otpController.currentCode,
                      autoFocus: true,
                      decoration: BoxLooseDecoration(
                        strokeColorBuilder: FixedColorBuilder(Color(0xffE6E8EE)),
                        obscureStyle: ObscureStyle(isTextObscure: false),
                        radius: const Radius.circular(8),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        strokeWidth: 1.5,
                      ),
                      onCodeChanged: (code) async {
                        if (code == null) return;
                        otpController.updateCurrentCode(code);
                        if (otpController.currentCode.length == 4) {
                          FocusScope.of(context).unfocus();
                          verifyOtp(context);
                        }
                      },
                      codeLength: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                GetBuilder<OTPAutofillController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Didn't receive OTP?"),
                          SizedBox(width: 2),
                          if (otpController.resendOtpTimer == 0)
                            GestureDetector(
                              onTap: () async {
                                if (otpController.isResendOtpEnabled) {
                                  Map<String, dynamic> data = {'phone': widget.phone, 'app_signature': await Get.find<OTPAutofillController>().getAppSignature()};
                                  Get.find<AuthController>().login(data: data);
                                  otpController.startResendOtpTimer();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text("Resend", style: context.texttheme.titleMedium?.copyWith(color: Colors.red)),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "Resend in ${otpController.resendOtpTimer}".toString().padLeft(2, '0'),
                                style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: GetBuilder<AuthController>(
                builder: (authCtrl) {
                  return CustomButton(
                    color: Colors.black,
                    isLoading: authCtrl.isLoading,
                    onTap: () {
                      verifyOtp(context);
                    },
                    title: "Submit",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context) async {
    final navigatorKey = Navigator.of(context);
    final authCtrl = Get.find<AuthController>();
    final otpController = Get.find<OTPAutofillController>();

    if (otpController.currentCode.length != 4) {
      showCustomToast("Please Enter Valid Otp");
      return;
    }
    final Map<String, dynamic> data = {"phone": widget.phone, "otp": otpController.currentCode, "device_id": await authCtrl.getDeviceId() ?? ""};
    if (otpController.currentCode.isNotEmpty) {
      authCtrl.verifyOTP(data).then((value) async {
        if (value.isSuccess) {
          await authCtrl.getUserProfileData();
          log(value.message.toString(), name: "message");
          if (value.message == 'new') {
            navigatorKey.pushAndRemoveUntil(getCustomRoute(child: const SignUpScreen()), (route) => false);
          } else if (value.message == 'old') {
            Get.find<DashBoardController>().setDashPage = 0;
            navigatorKey.pushAndRemoveUntil(getCustomRoute(child: const DashboardScreen()), (route) => false);
          }
        }
      });
    } else {
      showCustomToast('Please Enter OTP!');
    }
  }
}