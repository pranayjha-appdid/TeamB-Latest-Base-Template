import 'dart:io';

import 'package:flutter/material.dart';

class ExitDialog {
  static Future<bool?> show(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierLabel: "Exit",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, secAnim, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..rotateY((1 - anim.value) * 1.2),
          child: Opacity(
            opacity: anim.value,
            child: _dialogUI(context),
          ),
        );
      },
    );
  }

  // ----------------------------------
  // UI MAIN STRUCTURE
  // ----------------------------------
  static Widget _dialogUI(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _meatGlowIcon(),
              const SizedBox(height: 18),
              _titleText(),
              const SizedBox(height: 10),
              _subtitleText(),
              const SizedBox(height: 26),
              _buttons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------
  // MEAT ICON
  // ----------------------------------
  static Widget _meatGlowIcon() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xffFF4D4D), Color(0xffD7263D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF4D4D).withOpacity(.7),
            blurRadius: 24,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Icon(
        Icons.restaurant_menu_rounded,
        color: Colors.white,
        size: 44,
      ),
    );
  }

  // ----------------------------------
  // TITLE
  // ----------------------------------
  static Widget _titleText() {
    return const Text(
      "Exit Taza Meat Hub?",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.black87, // BLACK TEXT NOW
      ),
    );
  }

  // ----------------------------------
  // SUBTITLE
  // ----------------------------------
  static Widget _subtitleText() {
    return const Text(
      "Are you sure you want to leave?\nYour fresh selections will be kept safe.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        height: 1.4,
        color: Colors.black54,
      ),
    );
  }

  // ----------------------------------
  // BUTTONS
  // ----------------------------------
  static Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _outlineButton(
          text: "Stay",
          onTap: () => Navigator.pop(context, false),
        ),
        _filledButton(
          text: "Exit",
          onTap: () => exit(0),
        ),
      ],
    );
  }

  // ----------------------------------
  // OUTLINE BUTTON (NO GLASS NOW)
  // ----------------------------------
  static Widget _outlineButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xffFF4D4D),
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xffFF4D4D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ----------------------------------
  // FILLED BUTTON (RED)
  // ----------------------------------
  static Widget _filledButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffFF4D4D),
        ),
        child: const Text(
          "Exit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
