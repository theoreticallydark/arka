import 'package:flutter/material.dart';
import '../../../design_system/theme/app_colors.dart';
import '../onboarding_controller.dart';
import 'language_selection_step.dart';
import 'basic_details_step.dart';
import 'health_conditions_step.dart';
import 'tracking_goal_step.dart';
import 'symptom_setup_step.dart';

class OnboardingWrapper extends StatefulWidget {
  final VoidCallback onOnboardingComplete;

  const OnboardingWrapper({super.key, required this.onOnboardingComplete});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  final OnboardingController _controller = OnboardingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChange);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: Locale(_controller.selectedLanguage),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: _controller.currentStep > 0
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      onPressed: _controller.previousStep,
                    )
                  : null,
              title: const Text('Arka'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: (_controller.currentStep + 1) / 5,
                  backgroundColor: AppColors.chipBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
              ),
            ),
            body: SafeArea(
              child: _buildCurrentStep(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_controller.currentStep) {
      case 0:
        return LanguageSelectionStep(controller: _controller);
      case 1:
        return BasicDetailsStep(controller: _controller);
      case 2:
        return HealthConditionsStep(controller: _controller);
      case 3:
        return TrackingGoalStep(controller: _controller);
      case 4:
      default:
        return SymptomSetupStep(
          controller: _controller,
          onComplete: widget.onOnboardingComplete,
        );
    }
  }
}
