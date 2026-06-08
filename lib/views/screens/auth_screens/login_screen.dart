import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_hint_android/phone_hint_android.dart';
import 'package:raigadkar/services/extensions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/otp_autofill_controller.dart';
import '../../base/custom_widget.dart/common_button.dart';
import '../../base/custom_widget.dart/custom_image.dart';
import 'opt_verification_screen.dart';
import 'terms_and_condition_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final PhoneHintAndroid _phoneHintAndroid = PhoneHintAndroid();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      if (Platform.isAndroid) {
        _initPhoneHint();
      }
    });
  }

  Future<void> _initPhoneHint() async {
    try {
      final String? phoneNumber = await _phoneHintAndroid.getPhoneNumber();
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
        final number = cleaned.length > 10 ? cleaned.substring(cleaned.length - 10) : cleaned;
        setState(() {
          _phoneNumberController.text = number;
        });

        if (_formKey.currentState!.validate()) {
          _handleLogin();
        }
      }
    } catch (e) {
      log('Phone hint error: $e');
    }
  }

  void _handleLogin() async {
    setState(() {
      autoValidateMode = AutovalidateMode.onUserInteraction;
    });
    if (!_formKey.currentState!.validate()) return;
    Map<String, dynamic> data = {'phone': _phoneNumberController.text.trim(), 'app_signature': await Get.find<OTPAutofillController>().getAppSignature()};

    Get.find<AuthController>().login(data: data).then((value) {
      if (value.isSuccess) {
        if (!mounted) return;
        context.push(OTPVerification(phone: _phoneNumberController.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Mobile Authentication", style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomImage(
                  path: Assets.imagesLogo,
                  height: 80,
                  width: 80,
                ),
              ),
              Text(
                "What's your",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                "phone number?",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 35, color: Colors.black, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autofocus: true,
                controller: _phoneNumberController,
                inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                keyboardType: Platform.isIOS
                    ? const TextInputType.numberWithOptions(signed: true, decimal: true)
                    : TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Phone number",
                  hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black.withValues(alpha: 0.3)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.3), width: 1)),
                ),
                onChanged: (txt) {
                  if (txt.length == 10) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                validator: (value) {
                  if (value == null || value.length != 10) {
                    return "Please enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TermsAndConditionWidget()
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: 50,
            child: GetBuilder<AuthController>(
              builder: (controller) {
                return CustomButton(
                  radius: 6,
                  elevation: 0,
                  color: Colors.black,
                  isLoading: controller.isLoading,
                  onTap: () async {
                    _handleLogin();
                  },
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}