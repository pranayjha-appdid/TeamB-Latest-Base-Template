import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../custom_widget.dart/common_button.dart';

class GenderDialog extends StatefulWidget {
  const GenderDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'GenderDialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => const GenderDialog(),
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<GenderDialog> createState() => _GenderDialogState();
}

class _GenderDialogState extends State<GenderDialog> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Your Gender",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    label: "Male",
                    icon: Icons.male_rounded,
                    color: Colors.blueAccent,
                  ),
                  _buildOption(
                    label: "Female",
                    icon: Icons.female_rounded,
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              AnimatedOpacity(
                opacity: _selectedGender == null ? 0.5 : 1,
                duration: const Duration(milliseconds: 250),
                child: CustomButton(
                  onTap: _selectedGender == null ? null : () => Navigator.pop(context, _selectedGender),
                  color: Colors.deepPurpleAccent,
                  radius: 14,
                  child: Text(
                    _selectedGender == null ? "Continue" : "Continue as $_selectedGender",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedGender == label;

    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        setState(() => _selectedGender = label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 110,
        height: 130,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
