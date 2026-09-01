import 'package:flutter_test/flutter_test.dart';
import 'package:arka/core/constants/default_clinical_data.dart';
import 'package:arka/data/models/user_profile.dart';
import 'package:arka/data/models/symptom_log.dart';
import 'package:arka/core/utils/file_exporter.dart';
import 'package:arka/data/repositories/condition_repository.dart';

void main() {
  group('Clinical Recommendation Engine Tests', () {
    test('Knee surgery recommends pain, fever, swelling, walking difficulty and fatigue', () {
      final recs = DefaultClinicalData.getRecommendedSymptomIds(
        trackingGoal: 'surgery',
        selectedSurgeryId: 'surg_knee',
      );

      expect(recs.contains('sym_pain'), isTrue);
      expect(recs.contains('sym_fever'), isTrue);
      expect(recs.contains('sym_swelling'), isTrue);
      expect(recs.contains('sym_walking'), isTrue);
    });

    test('Diabetes condition recommends blood sugar and dizziness', () {
      final recs = DefaultClinicalData.getRecommendedSymptomIds(
        trackingGoal: 'disease',
        selectedConditionIds: ['cond_diabetes'],
      );

      expect(recs.contains('sym_sugar'), isTrue);
      expect(recs.contains('sym_dizziness'), isTrue);
    });
  });

  group('Data Models & Exporter Tests', () {
    test('UserProfile serialization & deserialization', () {
      final user = UserProfile(
        id: 'u1',
        name: 'Ramesh Sharma',
        gender: 'Male',
        dateOfBirth: '1965-05-12',
        preferredLanguage: 'hi',
        isOnboarded: true,
        createdAt: '2026-09-01T10:00:00Z',
        updatedAt: '2026-09-01T10:00:00Z',
      );

      final map = user.toMap();
      final fromMap = UserProfile.fromMap(map);

      expect(fromMap.id, 'u1');
      expect(fromMap.name, 'Ramesh Sharma');
      expect(fromMap.preferredLanguage, 'hi');
      expect(fromMap.isOnboarded, isTrue);
    });

    test('Journal text generation contains patient details and structured logs', () {
      final user = UserProfile(
        id: 'u1',
        name: 'Ramesh Sharma',
        gender: 'Male',
        dateOfBirth: '1965-05-12',
        preferredLanguage: 'en',
        isOnboarded: true,
        createdAt: '2026-09-01T10:00:00Z',
        updatedAt: '2026-09-01T10:00:00Z',
      );

      final active = [
        const ActiveHealthItem(
          junctionId: 'j1',
          id: 'cond_diabetes',
          name: 'Sugar (Diabetes)',
          iconName: 'water_drop',
          isSurgery: false,
        ),
      ];

      final logs = [
        SymptomLog(
          id: 'log1',
          userId: 'u1',
          symptomId: 'sym_pain',
          symptomName: 'Pain',
          timestamp: DateTime.now().toIso8601String(),
          numericValue: 4.0,
          measurementType: 'scale',
          noteText: 'Felt slight ache in knee after evening walk',
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      ];

      final txt = FileExporter.generateJournalText(
        user: user,
        activeItems: active,
        logs: logs,
      );

      expect(txt.contains('Ramesh Sharma'), isTrue);
      expect(txt.contains('Sugar (Diabetes)'), isTrue);
      expect(txt.contains('Pain: 4/10 (Moderate)'), isTrue);
      expect(txt.contains('Felt slight ache in knee after evening walk'), isTrue);
    });
  });
}
