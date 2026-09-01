import 'dart:math';
import 'package:flutter/material.dart';
import '../../../design_system/theme/app_colors.dart';
import '../../../design_system/theme/app_typography.dart';

class DynamicTipBanner extends StatefulWidget {
  const DynamicTipBanner({super.key});

  @override
  State<DynamicTipBanner> createState() => _DynamicTipBannerState();
}

class _DynamicTipBannerState extends State<DynamicTipBanner> {
  late String _currentTip;

  static const List<String> _tips = [
    '💡 Tip: You can tap Speak to record a voice note in your own words.',
    '💡 Tip: Daily logging helps your doctor see your recovery progress.',
    '💡 Tip: You can record blood sugar before or after meals.',
    '💡 Tip: Share your health journal on WhatsApp directly from the Journal tab.',
    '💡 Tip: Rate your pain from 1 (mild) to 10 (severe) accurately.',
  ];

  @override
  void initState() {
    super.initState();
    _currentTip = _tips[Random().nextInt(_tips.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              _currentTip,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
