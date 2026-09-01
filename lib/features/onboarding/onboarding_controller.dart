import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/default_clinical_data.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/condition_repository.dart';
import '../../data/repositories/symptom_repository.dart';

class OnboardingController extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();
  final ConditionRepository _conditionRepo = ConditionRepository();
  final SymptomRepository _symptomRepo = SymptomRepository();

  int currentStep = 0;

  // Form State
  String selectedLanguage = 'en';
  String name = '';
  String gender = 'Male';
  String dateOfBirth = '';
  double? heightCm;
  double? weightKg;

  final Set<String> selectedConditionIds = {};
  String trackingGoal = 'general'; // 'surgery', 'disease', 'general'
  String? selectedSurgeryId;
  final Set<String> selectedSymptomIds = {};

  void setLanguage(String langCode) {
    selectedLanguage = langCode;
    notifyListeners();
  }

  void nextStep() {
    if (currentStep == 3) {
      // Transitioning from Goal to Symptom Setup: calculate recommendations
      _generateRecommendations();
    }
    currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void toggleCondition(String conditionId) {
    if (conditionId == 'none') {
      selectedConditionIds.clear();
    } else {
      if (selectedConditionIds.contains(conditionId)) {
        selectedConditionIds.remove(conditionId);
      } else {
        selectedConditionIds.add(conditionId);
      }
    }
    notifyListeners();
  }

  void setGoal(String goal) {
    trackingGoal = goal;
    notifyListeners();
  }

  void setSurgery(String surgeryId) {
    selectedSurgeryId = surgeryId;
    notifyListeners();
  }

  void toggleSymptom(String symptomId) {
    if (selectedSymptomIds.contains(symptomId)) {
      selectedSymptomIds.remove(symptomId);
    } else {
      selectedSymptomIds.add(symptomId);
    }
    notifyListeners();
  }

  void _generateRecommendations() {
    final recs = DefaultClinicalData.getRecommendedSymptomIds(
      trackingGoal: trackingGoal,
      selectedConditionIds: selectedConditionIds.toList(),
      selectedSurgeryId: selectedSurgeryId,
    );
    selectedSymptomIds.clear();
    selectedSymptomIds.addAll(recs);
  }

  Future<void> completeOnboarding() async {
    final userId = const Uuid().v4();
    final now = DateTime.now().toIso8601String();

    final user = UserProfile(
      id: userId,
      name: name.trim().isEmpty ? 'User' : name.trim(),
      gender: gender,
      dateOfBirth: dateOfBirth.isEmpty ? '1980-01-01' : dateOfBirth,
      heightCm: heightCm,
      weightKg: weightKg,
      preferredLanguage: selectedLanguage,
      isOnboarded: true,
      createdAt: now,
      updatedAt: now,
    );

    // Save user
    await _userRepo.saveUser(user);

    // Save conditions
    if (selectedConditionIds.isNotEmpty) {
      await _conditionRepo.saveUserConditions(userId, selectedConditionIds.toList());
    }

    // Save surgery if selected
    if (selectedSurgeryId != null && trackingGoal == 'surgery') {
      await _conditionRepo.saveUserSurgery(userId, selectedSurgeryId!);
    }

    // Save symptoms
    final symsToSave = selectedSymptomIds.isNotEmpty
        ? selectedSymptomIds.toList()
        : ['sym_pain', 'sym_fever', 'sym_swelling'];
    await _symptomRepo.saveUserSymptoms(userId, symsToSave);
  }
}
