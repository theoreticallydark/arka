import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../design_system/buttons/primary_button.dart';
import '../../../design_system/cards/selection_card.dart';
import '../../../design_system/theme/app_typography.dart';
import '../onboarding_controller.dart';

class LanguageSelectionStep extends StatelessWidget {
  final OnboardingController controller;

  const LanguageSelectionStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('onboarding.choose_language'),
            style: AppTypography.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('onboarding.choose_language_sub'),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 24),
          ...AppLocalizations.supportedLanguages.map((lang) {
            final isSelected = controller.selectedLanguage == lang.code;
            return SelectionCard(
              title: lang.nativeName,
              subtitle: lang.englishName != lang.nativeName ? lang.englishName : null,
              icon: Icons.language,
              isSelected: isSelected,
              onTap: () {
                controller.setLanguage(lang.code);
              },
            );
          }),
          const SizedBox(height: 24),
          PrimaryButton(
            label: loc.translate('onboarding.continue'),
            icon: Icons.arrow_forward,
            onPressed: controller.nextStep,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
