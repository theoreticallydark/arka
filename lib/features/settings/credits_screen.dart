import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../design_system/theme/app_colors.dart';
import '../../design_system/theme/app_typography.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings.credits')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medical Disclaimer Card (PRD Section 29)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.warning, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Medical Disclaimer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.translate('settings.disclaimer'),
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Servier Medical Art Attribution (PRD Section 27-28)
              Text(
                'Graphics & Icons Attribution',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Servier Medical Art (SMART)',
                      style: AppTypography.titleMedium,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Medical illustrations and anatomical graphics are provided by Servier Medical Art (SMART) by Les Laboratoires Servier, licensed under a Creative Commons Attribution 4.0 International License (CC BY 4.0).\n\nSource: smart.servier.com',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Material UI Icons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material UI Icons',
                      style: AppTypography.titleMedium,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Interface icons and symbols are based on Material UI and Flutter Icon fonts under the Apache 2.0 license.',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
