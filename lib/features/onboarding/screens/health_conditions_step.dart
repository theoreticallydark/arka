import 'package:flutter/material.dart';
import '../../../core/constants/default_clinical_data.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../design_system/buttons/primary_button.dart';
import '../../../design_system/cards/selection_card.dart';
import '../../../design_system/theme/app_typography.dart';
import '../onboarding_controller.dart';

class HealthConditionsStep extends StatefulWidget {
  final OnboardingController controller;

  const HealthConditionsStep({super.key, required this.controller});

  @override
  State<HealthConditionsStep> createState() => _HealthConditionsStepState();
}

class _HealthConditionsStepState extends State<HealthConditionsStep> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('onboarding.conditions_title'),
            style: AppTypography.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('onboarding.conditions_sub'),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Condition cards
          ...DefaultClinicalData.conditions.map((cond) {
            final isSelected = widget.controller.selectedConditionIds.contains(cond.id);
            return SelectionCard(
              title: cond.defaultName,
              icon: cond.materialIcon,
              assetKey: cond.assetKey,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  widget.controller.toggleCondition(cond.id);
                });
              },
            );
          }),

          // "None" option
          SelectionCard(
            title: loc.translate('onboarding.condition_none'),
            icon: Icons.check_circle_outline,
            isSelected: widget.controller.selectedConditionIds.isEmpty,
            onTap: () {
              setState(() {
                widget.controller.toggleCondition('none');
              });
            },
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            label: loc.translate('onboarding.continue'),
            icon: Icons.arrow_forward,
            onPressed: widget.controller.nextStep,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
