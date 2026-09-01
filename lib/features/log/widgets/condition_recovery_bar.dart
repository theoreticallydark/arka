import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/repositories/condition_repository.dart';
import '../../../design_system/dialogs/confirmation_dialog.dart';
import '../../../design_system/icons/medical_graphic_icon.dart';
import '../../../design_system/theme/app_colors.dart';
import '../../../design_system/theme/app_typography.dart';

class ConditionRecoveryBar extends StatelessWidget {
  final List<ActiveHealthItem> activeItems;
  final Function(ActiveHealthItem item) onMarkRecovered;

  const ConditionRecoveryBar({
    super.key,
    required this.activeItems,
    required this.onMarkRecovered,
  });

  @override
  Widget build(BuildContext context) {
    if (activeItems.isEmpty) return const SizedBox.shrink();

    final loc = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Active Health Focus',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...activeItems.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryLight, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  MedicalGraphicIcon(
                    assetKey: item.assetKey,
                    fallbackIcon: item.isSurgery ? Icons.healing : Icons.water_drop,
                    size: 24,
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          item.isSurgery ? 'Surgery / Operation' : 'Chronic Condition',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.successLight,
                      foregroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(
                      loc.translate('log.recovered_btn'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context,
                        title: loc.translate('log.recovered_modal_title'),
                        message: loc.translate('log.recovered_modal_msg'),
                        confirmLabel: loc.translate('log.recovered_btn'),
                        confirmColor: AppColors.success,
                        icon: Icons.celebration_outlined,
                      );
                      if (confirmed == true) {
                        onMarkRecovered(item);
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
