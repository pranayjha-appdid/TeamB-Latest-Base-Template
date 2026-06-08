import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:raigadkar/services/extensions.dart';

import '../../screens/auth_screens/login_screen.dart';
import '../custom_widget.dart/common_button.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({super.key, this.title, this.message, this.isLogin = false, this.lottieAsset, this.onPrimaryTap, this.primaryButtonText = 'Continue'});

  final String? title;
  final String? message;
  final bool isLogin;
  final String? lottieAsset;
  final VoidCallback? onPrimaryTap;
  final String primaryButtonText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 12))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff6A5AE0), Color(0xff8E7BFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Center(
                child: Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)],
                  ),
                  child: lottieAsset != null ? Lottie.asset(lottieAsset!, fit: BoxFit.contain) : const Icon(Icons.warning_amber_rounded, size: 40, color: Color(0xff6A5AE0)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title ?? (isLogin ? 'You are not login' : 'Action Needed'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            const SizedBox(height: 10),

            /// MESSAGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                message ?? "Log in to continue with Taza’s Meat Hub and enjoy a smoother, more personalized shopping experience.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700, height: 1.5),
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      type: ButtonType.secondary,
                      radius: 12,
                      onTap: () {
                        context.pop();
                      },
                      title: "Cancel",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomButton(
                      radius: 12,
                      onTap: () {
                        context.pop();
                        context.push(LoginScreen());
                      },
                      title: "Continue",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
