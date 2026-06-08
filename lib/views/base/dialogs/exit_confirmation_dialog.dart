import 'dart:io';

import 'package:flutter/material.dart';

import '../custom_widget.dart/custom_image.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(path: Assets.imagesExitImage, height: 120, width: 120),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                "Are you sure you want to Exit the app?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16, color: const Color(0xff1A1A1A)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Yes button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(66)),
                    child: Center(child: Text("No", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                // Yes button
                GestureDetector(
                  onTap: () {
                    exit(0);
                  },

                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(66)),
                    child: Center(child: Text("Yes", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))),
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
