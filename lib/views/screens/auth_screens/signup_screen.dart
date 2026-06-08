import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:raigadkar/services/extensions.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/dashboard_controller.dart';
import '../../../../services/input_decoration.dart';
import '../../../../services/theme.dart';
import '../../../services/constants.dart';
import '../../base/custom_widget.dart/common_button.dart';
import '../../base/custom_widget.dart/custom_image.dart';
import '../../base/custom_widget.dart/custom_toast.dart';
import '../dashboard/dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    Timer.run(() async {
      final authCtrl = Get.find<AuthController>();
      _phoneNumberController.text = authCtrl.userModel?.phone ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Sign Up") ,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: CustomImage(path: Assets.imagesLogo, width: 150, height: 132)),
                SizedBox(height: 20),
                Text(
                  "Set Up Your Profile",
                  style: context.texttheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text("Help us personalise your experience and make bookings smoother.", style: context.texttheme.labelLarge?.copyWith(color: textSecondary, fontSize: 14)),
                const SizedBox(height: 30),

                Text(
                  "Name",
                  style: context.texttheme.titleSmall?.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                TextFormField(
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: textSecondary),
                  controller: nameController,
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: CustomDecoration.inputDecoration(
                    borderRadius: 12,
                    icon: Icon(Icons.person_outline_sharp, size: 20),
                    hint: 'Enter your name',
                    hintStyle: context.texttheme.titleSmall?.copyWith(color: Colors.grey),
                    borderColor: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Mobile Number",
                  style: context.texttheme.titleSmall?.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: textSecondary),
                  controller: _phoneNumberController,
                  readOnly: true,
                  decoration: CustomDecoration.inputDecoration(
                    borderRadius: 12,
                    bgColor: Colors.grey.shade50,
                    icon: Icon(Icons.call_outlined, size: 18),
                    hint: 'Mobile Number',
                    hintStyle: context.texttheme.titleSmall?.copyWith(color: Colors.grey, fontSize: 14),
                    borderColor: Colors.grey.shade300,
                  ),
                  validator: (value) {
                    if (value == null || value.length != 10) return "Please enter a valid 10-digit phone number";
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                Text(
                  "Email Address (Optional)",
                  style: context.texttheme.titleSmall?.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),

                // Email Field
                TextFormField(
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: textSecondary),
                  controller: emailController,
                  decoration: CustomDecoration.inputDecoration(
                    borderRadius: 12,
                    icon: Icon(Icons.call_outlined, size: 18),
                    hint: 'Enter email address',
                    hintStyle: context.texttheme.titleSmall?.copyWith(color: Colors.grey, fontSize: 14),
                    borderColor: Colors.grey.shade300,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !GetUtils.isEmail(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: GetBuilder<AuthController>(
                builder: (authCtrl) {
                  return CustomButton(
                    isLoading: authCtrl.isLoading,
                    title: "Continue",
                    radius: 8,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          "name": nameController.text.trim(),
                          "email": emailController.text.trim(),
                          "phone": _phoneNumberController.text,
                        };
                        authCtrl.registerUser(data: data).then((value) async {
                          if (value.isSuccess) {
                            showCustomToast("Welcome to ${AppConstants.appName}!");
                            await authCtrl.getUserProfileData();
                            if (!context.mounted) return;
                            Get.find<DashBoardController>().setDashPage = 0;
                            context.pushAndRemoveUntil(DashboardScreen());
                          } else {
                            Fluttertoast.showToast(msg: value.message);
                          }
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
