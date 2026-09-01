import 'package:flutter/material.dart';
import '../../../core/constants/default_clinical_data.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../design_system/buttons/primary_button.dart';
import '../../../design_system/cards/selection_card.dart';
import '../../../design_system/theme/app_typography.dart';
import '../onboarding_controller.dart';

class TrackingGoalStep extends StatefulWidget {
  final OnboardingController controller;

  const TrackingGoalStep({super.key, required this.controller});

  @override
  State<TrackingGoalStep> createState() => _TrackingGoalStepState();
}

class _TrackingGoalStepState extends State<TrackingGoalStep> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('onboarding.goal_title'),
            style: AppTypography.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('onboarding.goal_sub'),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Option A: Surgery
          SelectionCard(
            title: loc.translate('onboarding.goal_surgery'),
            subtitle: loc.translate('onboarding.goal_surgery_sub'),
            icon: Icons.healing,
            isSelected: widget.controller.trackingGoal == 'surgery',
            onTap: () {
              setState(() {
                widget.controller.setGoal('surgery');
                if (widget.controller.selectedSurgeryId == null) {
                  widget.controller.setSurgery(DefaultClinicalData.surgeries.first.id);
                }
              });
            },
          ),

          // If surgery is selected, show surgery picker
          if (widget.controller.trackingGoal == 'surgery') ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4, bottom: 12),
              child: Text(
                loc.translate('onboarding.select_surgery'),
                style: AppTypography.titleMedium,
              ),
            ),
            ...DefaultClinicalData.surgeries.map((surg) {
              final isSurgSelected = widget.controller.selectedSurgeryId == surg.id;
              return SelectionCard(
                title: surg.defaultName,
                icon: surg.materialIcon,
                assetKey: surg.assetKey,
                isSelected: isSurgSelected,
                onTap: () {
                  setState(() {
                    widget.controller.setSurgery(surg.id);
                  });
                },
              );
            }),
            const SizedBox(height: 12),
          ],

          // Option B: Disease / Chronic Condition
          SelectionCard(
            title: loc.translate('onboarding.goal_disease'),
            subtitle: loc.translate('onboarding.goal_disease_sub'),
            icon: Icons.monitor_heart,
            isSelected: widget.controller.trackingGoal == 'disease',
            onTap: () {
              setState(() {
                widget.controller.setGoal('disease');
                widget.controller.selectedSurgeryId = null;
              });
            },
          ),

          // Option C: General Observation
          SelectionCard(
            title: loc.translate('onboarding.goal_general'),
            subtitle: loc.translate('onboarding.goal_general_sub'),
            icon: Icons.auto_stories,
            isSelected: widget.controller.trackingGoal == 'general',
            onTap: () {
              setState(() {
                widget.controller.setGoal('general');
                widget.controller.selectedSurgeryId = null;
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
