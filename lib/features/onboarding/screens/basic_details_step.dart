import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../design_system/buttons/primary_button.dart';
import '../../../design_system/theme/app_colors.dart';
import '../../../design_system/theme/app_typography.dart';
import '../onboarding_controller.dart';

class BasicDetailsStep extends StatefulWidget {
  final OnboardingController controller;

  const BasicDetailsStep({super.key, required this.controller});

  @override
  State<BasicDetailsStep> createState() => _BasicDetailsStepState();
}

class _BasicDetailsStepState extends State<BasicDetailsStep> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.controller.name);
    _dobController = TextEditingController(text: widget.controller.dateOfBirth);
    _heightController = TextEditingController(
      text: widget.controller.heightCm != null ? widget.controller.heightCm.toString() : '',
    );
    _weightController = TextEditingController(
      text: widget.controller.weightKg != null ? widget.controller.weightKg.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    widget.controller.name = _nameController.text.trim();
    widget.controller.dateOfBirth = _dobController.text.trim();
    widget.controller.heightCm = double.tryParse(_heightController.text);
    widget.controller.weightKg = double.tryParse(_weightController.text);
    widget.controller.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('onboarding.tell_about_yourself'),
            style: AppTypography.displayMedium,
          ),
          const SizedBox(height: 24),

          // Name field
          Text(loc.translate('onboarding.name_label'), style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: loc.translate('onboarding.name_hint'),
              prefixIcon: const Icon(Icons.person_outline, size: 24),
            ),
          ),
          const SizedBox(height: 20),

          // Gender selection
          Text(loc.translate('onboarding.gender_label'), style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildGenderChip('Male', loc.translate('onboarding.gender_male')),
              const SizedBox(width: 12),
              _buildGenderChip('Female', loc.translate('onboarding.gender_female')),
              const SizedBox(width: 12),
              _buildGenderChip('Other', loc.translate('onboarding.gender_other')),
            ],
          ),
          const SizedBox(height: 20),

          // Age / Date of Birth
          Text(loc.translate('onboarding.dob_label'), style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _dobController,
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'e.g. 58 years or 1968',
              prefixIcon: Icon(Icons.calendar_today_outlined, size: 24),
            ),
          ),
          const SizedBox(height: 20),

          // Height & Weight row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('onboarding.height_label'), style: AppTypography.bodySmall),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      style: AppTypography.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: '165',
                        suffixText: 'cm',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('onboarding.weight_label'), style: AppTypography.bodySmall),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: AppTypography.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: '68',
                        suffixText: 'kg',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          PrimaryButton(
            label: loc.translate('onboarding.continue'),
            icon: Icons.arrow_forward,
            onPressed: _saveAndContinue,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGenderChip(String value, String label) {
    final isSelected = widget.controller.gender == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            widget.controller.gender = value;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2.5 : 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
