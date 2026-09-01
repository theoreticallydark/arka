import 'package:flutter/material.dart';
import '../../design_system/cards/symptom_input_card.dart';

class Symptom {
  final String id;
  final String nameKey;
  final String defaultName;
  final String? descriptionKey;
  final String? defaultDescription;
  final String iconName;
  final String? assetKey;
  final String measurementType; // 'scale', 'yesNo', 'numeric', 'duration', 'text'
  final String? unit;
  final bool isDefault;

  const Symptom({
    required this.id,
    required this.nameKey,
    required this.defaultName,
    this.descriptionKey,
    this.defaultDescription,
    required this.iconName,
    this.assetKey,
    required this.measurementType,
    this.unit,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_key': nameKey,
      'default_name': defaultName,
      'description_key': descriptionKey,
      'default_description': defaultDescription,
      'icon_name': iconName,
      'asset_key': assetKey,
      'measurement_type': measurementType,
      'unit': unit,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      id: map['id'] as String,
      nameKey: map['name_key'] as String,
      defaultName: map['default_name'] as String,
      descriptionKey: map['description_key'] as String?,
      defaultDescription: map['default_description'] as String?,
      iconName: map['icon_name'] as String,
      assetKey: map['asset_key'] as String?,
      measurementType: map['measurement_type'] as String,
      unit: map['unit'] as String?,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }

  MeasurementType get typeEnum {
    switch (measurementType) {
      case 'scale':
        return MeasurementType.scale;
      case 'yesNo':
        return MeasurementType.yesNo;
      case 'numeric':
        return MeasurementType.numeric;
      case 'duration':
        return MeasurementType.duration;
      case 'text':
      default:
        return MeasurementType.text;
    }
  }

  IconData get materialIcon {
    switch (iconName) {
      case 'thermostat':
        return Icons.thermostat;
      case 'sentiment_very_dissatisfied':
        return Icons.sentiment_very_dissatisfied;
      case 'water_drop':
        return Icons.water_drop;
      case 'favorite':
        return Icons.favorite;
      case 'air':
        return Icons.air;
      case 'sick':
        return Icons.sick;
      case 'speed':
        return Icons.speed;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'bedtime':
        return Icons.bedtime;
      case 'psychology':
        return Icons.psychology;
      case 'healing':
      default:
        return Icons.healing;
    }
  }
}

class UserSymptom {
  final String id;
  final String userId;
  final String symptomId;
  final int sortOrder;
  final bool isEnabled;

  UserSymptom({
    required this.id,
    required this.userId,
    required this.symptomId,
    this.sortOrder = 0,
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'symptom_id': symptomId,
      'sort_order': sortOrder,
      'is_enabled': isEnabled ? 1 : 0,
    };
  }

  factory UserSymptom.fromMap(Map<String, dynamic> map) {
    return UserSymptom(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      symptomId: map['symptom_id'] as String,
      sortOrder: map['sort_order'] as int? ?? 0,
      isEnabled: (map['is_enabled'] as int? ?? 1) == 1,
    );
  }
}
