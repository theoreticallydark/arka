import 'package:flutter/material.dart';

class HealthCondition {
  final String id;
  final String nameKey;
  final String defaultName;
  final String iconName;
  final String? assetKey;
  final String category;

  const HealthCondition({
    required this.id,
    required this.nameKey,
    required this.defaultName,
    required this.iconName,
    this.assetKey,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_key': nameKey,
      'default_name': defaultName,
      'icon_name': iconName,
      'asset_key': assetKey,
      'category': category,
    };
  }

  factory HealthCondition.fromMap(Map<String, dynamic> map) {
    return HealthCondition(
      id: map['id'] as String,
      nameKey: map['name_key'] as String,
      defaultName: map['default_name'] as String,
      iconName: map['icon_name'] as String,
      assetKey: map['asset_key'] as String?,
      category: map['category'] as String,
    );
  }

  IconData get materialIcon {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop;
      case 'favorite':
        return Icons.favorite;
      case 'air':
        return Icons.air;
      case 'medical_services':
        return Icons.medical_services;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'monitor_heart':
        return Icons.monitor_heart;
      case 'psychology':
        return Icons.psychology;
      case 'healing':
      default:
        return Icons.healing;
    }
  }
}

class UserCondition {
  final String id;
  final String userId;
  final String conditionId;
  final bool isActive;
  final String? resolvedDate;
  final String createdAt;

  UserCondition({
    required this.id,
    required this.userId,
    required this.conditionId,
    this.isActive = true,
    this.resolvedDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'condition_id': conditionId,
      'is_active': isActive ? 1 : 0,
      'resolved_date': resolvedDate,
      'created_at': createdAt,
    };
  }

  factory UserCondition.fromMap(Map<String, dynamic> map) {
    return UserCondition(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      conditionId: map['condition_id'] as String,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      resolvedDate: map['resolved_date'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
