import 'package:flutter/material.dart';
import '../../../core/constants/default_clinical_data.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../design_system/buttons/primary_button.dart';
import '../../../design_system/cards/selection_card.dart';
import '../../../design_system/theme/app_typography.dart';
import '../onboarding_controller.dart';

class SymptomSetupStep extends StatefulWidget {
  final OnboardingController controller;
  final VoidCallback onComplete;

  const SymptomSetupStep({
    super.key,
    required this.controller,
    required this.onComplete,
  });

  @override
  State<SymptomSetupStep> createState() => _SymptomSetupStepState();
}

class _SymptomSetupStepState extends State<SymptomSetupStep> {
  bool _isLoading = false;
  bool _showAllSymptoms = false;

  Future<void> _finishSetup() async {
    setState(() => _isLoading = true);
    await widget.controller.completeOnboarding();
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final allList = DefaultClinicalData.allSymptoms;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('onboarding.symptom_setup_title'),
            style: AppTypography.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('onboarding.symptom_setup_sub'),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Render selected / recommended symptoms
          ...allList
              .where((s) => _showAllSymptoms || widget.controller.selectedSymptomIds.contains(s.id))
              .map((sym) {
            final isSelected = widget.controller.selectedSymptomIds.contains(sym.id);
            return SelectionCard(
              title: sym.defaultName,
              subtitle: sym.defaultDescription,
              icon: sym.materialIcon,
              assetKey: sym.assetKey,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  widget.controller.toggleSymptom(sym.id);
                });
              },
            );
          }),

          if (!_showAllSymptoms) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() => _showAllSymptoms = true);
                },
                icon: const Icon(Icons.add_circle_outline, size: 22),
                label: Text(
                  loc.translate('onboarding.add_another_symptom'),
                  style: AppTypography.titleMedium,
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          PrimaryButton(
            label: loc.translate('onboarding.get_started'),
            icon: Icons.check_circle,
            isLoading: _isLoading,
            onPressed: _finishSetup,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
