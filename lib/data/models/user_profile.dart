class UserProfile {
  final String id;
  final String name;
  final String gender;
  final String dateOfBirth;
  final double? heightCm;
  final double? weightKg;
  final String preferredLanguage;
  final bool isOnboarded;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    required this.preferredLanguage,
    this.isOnboarded = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'preferred_language': preferredLanguage,
      'is_onboarded': isOnboarded ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      gender: map['gender'] as String,
      dateOfBirth: map['date_of_birth'] as String,
      heightCm: map['height_cm'] != null ? (map['height_cm'] as num).toDouble() : null,
      weightKg: map['weight_kg'] != null ? (map['weight_kg'] as num).toDouble() : null,
      preferredLanguage: map['preferred_language'] as String? ?? 'en',
      isOnboarded: (map['is_onboarded'] as int? ?? 0) == 1,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  UserProfile copyWith({
    String? name,
    String? gender,
    String? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? preferredLanguage,
    bool? isOnboarded,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}
