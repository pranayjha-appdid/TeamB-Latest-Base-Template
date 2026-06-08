import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raigadkar/services/extensions.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/constants.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../custom_widget.dart/common_button.dart';
import '../custom_widget.dart/custom_image.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: const Color(0xFFFFF4E9),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, spreadRadius: 1)],
              ),
              child: Center(child: CustomImage(path: Assets.imagesLogo, height: 40)),
            ),
            const SizedBox(height: 18),
            Text(
              "Leaving the ${AppConstants.appName}?",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown.shade900),
            ),
            const SizedBox(height: 8),
            Text(
              "Your account stays fresh and safe. Come back anytime!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.brown.shade700),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: CustomButton(color: Colors.white, type: ButtonType.secondary, title: "Stay", onTap: () => Navigator.pop(context)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GetBuilder<AuthController>(
                    builder: (controller) {
                      return CustomButton(
                        isLoading: controller.isLoading,
                        title: "Log Out",
                        onTap: () async {
                          await controller.logOut();
                          if (!context.mounted) return;
                          context.pushAndRemoveUntil(const SplashScreen());
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
