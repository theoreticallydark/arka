import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Asset-first medical icon component.
/// Looks for a corresponding asset in `assets/medical/<assetKey>.png` or `.svg`.
/// If absent, cleanly renders a prominent Material Icon badge.
class MedicalGraphicIcon extends StatelessWidget {
  final String? assetKey;
  final IconData fallbackIcon;
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  final bool showBackground;

  const MedicalGraphicIcon({
    super.key,
    this.assetKey,
    required this.fallbackIcon,
    this.size = 32.0,
    this.iconColor = AppColors.primary,
    this.backgroundColor = AppColors.primaryLight,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconContent;
    if (assetKey != null && assetKey!.isNotEmpty) {
      iconContent = Image.asset(
        'assets/medical/$assetKey.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(fallbackIcon, size: size, color: iconColor);
        },
      );
    } else {
      iconContent = Icon(fallbackIcon, size: size, color: iconColor);
    }

    if (!showBackground) return iconContent;

    return Container(
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: iconContent,
    );
  }
}
