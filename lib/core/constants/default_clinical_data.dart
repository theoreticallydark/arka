import '../../data/models/condition.dart';
import '../../data/models/surgery.dart';
import '../../data/models/symptom.dart';

class DefaultClinicalData {
  DefaultClinicalData._();

  static const List<HealthCondition> conditions = [
    HealthCondition(
      id: 'cond_diabetes',
      nameKey: 'condition.diabetes',
      defaultName: 'Sugar (Diabetes)',
      iconName: 'water_drop',
      assetKey: 'diabetes',
      category: 'metabolic',
    ),
    HealthCondition(
      id: 'cond_bp',
      nameKey: 'condition.bp',
      defaultName: 'High BP (Hypertension)',
      iconName: 'favorite',
      assetKey: 'hypertension',
      category: 'cardiovascular',
    ),
    HealthCondition(
      id: 'cond_thyroid',
      nameKey: 'condition.thyroid',
      defaultName: 'Thyroid',
      iconName: 'healing',
      assetKey: 'thyroid',
      category: 'endocrine',
    ),
    HealthCondition(
      id: 'cond_asthma',
      nameKey: 'condition.asthma',
      defaultName: 'Asthma / Breathing',
      iconName: 'air',
      assetKey: 'asthma',
      category: 'respiratory',
    ),
    HealthCondition(
      id: 'cond_arthritis',
      nameKey: 'condition.arthritis',
      defaultName: 'Joint Pain (Arthritis)',
      iconName: 'accessibility_new',
      assetKey: 'arthritis',
      category: 'musculoskeletal',
    ),
    HealthCondition(
      id: 'cond_heart',
      nameKey: 'condition.heart',
      defaultName: 'Heart Condition',
      iconName: 'monitor_heart',
      assetKey: 'heart',
      category: 'cardiovascular',
    ),
  ];

  static const List<Surgery> surgeries = [
    Surgery(
      id: 'surg_knee',
      nameKey: 'surgery.knee',
      defaultName: 'Knee Replacement',
      iconName: 'accessibility_new',
      assetKey: 'knee_surgery',
      category: 'orthopedic',
    ),
    Surgery(
      id: 'surg_hip',
      nameKey: 'surgery.hip',
      defaultName: 'Hip Surgery',
      iconName: 'accessibility_new',
      assetKey: 'hip_surgery',
      category: 'orthopedic',
    ),
    Surgery(
      id: 'surg_cataract',
      nameKey: 'surgery.cataract',
      defaultName: 'Cataract / Eye Surgery',
      iconName: 'visibility',
      assetKey: 'cataract_surgery',
      category: 'ophthalmology',
    ),
    Surgery(
      id: 'surg_heart',
      nameKey: 'surgery.heart',
      defaultName: 'Bypass / Heart Operation',
      iconName: 'favorite',
      assetKey: 'heart_surgery',
      category: 'cardiac',
    ),
    Surgery(
      id: 'surg_general',
      nameKey: 'surgery.general',
      defaultName: 'General Surgery / Stitches',
      iconName: 'healing',
      assetKey: 'general_surgery',
      category: 'general',
    ),
  ];

  static const List<Symptom> allSymptoms = [
    Symptom(
      id: 'sym_pain',
      nameKey: 'symptom.pain',
      defaultName: 'Pain / दर्द / वेदना',
      descriptionKey: 'symptom.pain_desc',
      defaultDescription: 'Rate your pain intensity from 1 to 10',
      iconName: 'sentiment_very_dissatisfied',
      assetKey: 'pain',
      measurementType: 'scale',
      unit: '/10',
      isDefault: true,
    ),
    Symptom(
      id: 'sym_swelling',
      nameKey: 'symptom.swelling',
      defaultName: 'Swelling / सूजन / सूज',
      descriptionKey: 'symptom.swelling_desc',
      defaultDescription: 'Is there swelling or inflammation?',
      iconName: 'healing',
      assetKey: 'swelling',
      measurementType: 'yesNo',
      isDefault: true,
    ),
    Symptom(
      id: 'sym_sugar',
      nameKey: 'symptom.sugar',
      defaultName: 'Blood Sugar / साखर',
      descriptionKey: 'symptom.sugar_desc',
      defaultDescription: 'Fasting or Post-meal glucose reading',
      iconName: 'water_drop',
      assetKey: 'blood_sugar',
      measurementType: 'numeric',
      unit: 'mg/dL',
      isDefault: false,
    ),
    Symptom(
      id: 'sym_bp',
      nameKey: 'symptom.bp',
      defaultName: 'Blood Pressure (BP)',
      descriptionKey: 'symptom.bp_desc',
      defaultDescription: 'e.g. 120/80 or Systolic reading',
      iconName: 'favorite',
      assetKey: 'blood_pressure',
      measurementType: 'text',
      unit: 'mmHg',
      isDefault: false,
    ),
    Symptom(
      id: 'sym_fever',
      nameKey: 'symptom.fever',
      defaultName: 'Fever / बुखार / ताप',
      descriptionKey: 'symptom.fever_desc',
      defaultDescription: 'Body temperature',
      iconName: 'thermostat',
      assetKey: 'fever',
      measurementType: 'numeric',
      unit: '°F',
      isDefault: true,
    ),
    Symptom(
      id: 'sym_walking',
      nameKey: 'symptom.walking',
      defaultName: 'Walking Difficulty / चालणे',
      descriptionKey: 'symptom.walking_desc',
      defaultDescription: 'Trouble walking or moving around',
      iconName: 'directions_walk',
      assetKey: 'walking',
      measurementType: 'scale',
      unit: '/10',
      isDefault: false,
    ),
    Symptom(
      id: 'sym_dizziness',
      nameKey: 'symptom.dizziness',
      defaultName: 'Dizziness / चक्कर',
      descriptionKey: 'symptom.dizziness_desc',
      defaultDescription: 'Feeling lightheaded or spinning',
      iconName: 'psychology',
      assetKey: 'dizziness',
      measurementType: 'yesNo',
      isDefault: false,
    ),
    Symptom(
      id: 'sym_breath',
      nameKey: 'symptom.breath',
      defaultName: 'Shortness of Breath / धाप',
      descriptionKey: 'symptom.breath_desc',
      defaultDescription: 'Breathing difficulty or tightness',
      iconName: 'air',
      assetKey: 'breath',
      measurementType: 'scale',
      unit: '/10',
      isDefault: false,
    ),
    Symptom(
      id: 'sym_fatigue',
      nameKey: 'symptom.fatigue',
      defaultName: 'Fatigue / थकावट / थकवा',
      descriptionKey: 'symptom.fatigue_desc',
      defaultDescription: 'Low energy or weakness',
      iconName: 'bedtime',
      assetKey: 'fatigue',
      measurementType: 'scale',
      unit: '/10',
      isDefault: false,
    ),
    Symptom(
      id: 'sym_nausea',
      nameKey: 'symptom.nausea',
      defaultName: 'Nausea / जी मचलना / उलटी',
      descriptionKey: 'symptom.nausea_desc',
      defaultDescription: 'Upset stomach or feeling sick',
      iconName: 'sick',
      assetKey: 'nausea',
      measurementType: 'yesNo',
      isDefault: false,
    ),
  ];

  /// Clinical Symptom Recommendation Engine (PRD Section 9)
  /// Returns a curated 5–8 symptom list tailored to user's surgery, condition & tracking goal.
  static List<String> getRecommendedSymptomIds({
    required String trackingGoal,
    List<String>? selectedConditionIds,
    String? selectedSurgeryId,
  }) {
    final Set<String> recommended = {'sym_pain', 'sym_fever'};

    if (trackingGoal == 'surgery' || selectedSurgeryId != null) {
      recommended.add('sym_swelling');
      if (selectedSurgeryId == 'surg_knee' || selectedSurgeryId == 'surg_hip') {
        recommended.add('sym_walking');
        recommended.add('sym_fatigue');
      } else if (selectedSurgeryId == 'surg_heart') {
        recommended.add('sym_bp');
        recommended.add('sym_breath');
        recommended.add('sym_fatigue');
      } else {
        recommended.add('sym_nausea');
        recommended.add('sym_fatigue');
      }
    }

    if (selectedConditionIds != null) {
      for (final condId in selectedConditionIds) {
        switch (condId) {
          case 'cond_diabetes':
            recommended.add('sym_sugar');
            recommended.add('sym_dizziness');
            recommended.add('sym_fatigue');
            break;
          case 'cond_bp':
            recommended.add('sym_bp');
            recommended.add('sym_dizziness');
            break;
          case 'cond_asthma':
            recommended.add('sym_breath');
            recommended.add('sym_fatigue');
            break;
          case 'cond_arthritis':
            recommended.add('sym_pain');
            recommended.add('sym_swelling');
            recommended.add('sym_walking');
            break;
          case 'cond_thyroid':
          case 'cond_heart':
            recommended.add('sym_fatigue');
            recommended.add('sym_bp');
            break;
        }
      }
    }

    if (recommended.length < 4) {
      recommended.add('sym_swelling');
      recommended.add('sym_fatigue');
    }

    return recommended.take(8).toList();
  }
}
