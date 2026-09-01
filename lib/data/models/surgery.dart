import 'package:flutter/material.dart';

class Surgery {
  final String id;
  final String nameKey;
  final String defaultName;
  final String iconName;
  final String? assetKey;
  final String category;

  const Surgery({
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

  factory Surgery.fromMap(Map<String, dynamic> map) {
    return Surgery(
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
      case 'healing':
        return Icons.healing;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'visibility':
        return Icons.visibility;
      case 'favorite':
        return Icons.favorite;
      case 'medical_services':
      default:
        return Icons.medical_services;
    }
  }
}

class UserSurgery {
  final String id;
  final String userId;
  final String surgeryId;
  final String? surgeryDate;
  final bool isActive;
  final String? resolvedDate;
  final String createdAt;

  UserSurgery({
    required this.id,
    required this.userId,
    required this.surgeryId,
    this.surgeryDate,
    this.isActive = true,
    this.resolvedDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'surgery_id': surgeryId,
      'surgery_date': surgeryDate,
      'is_active': isActive ? 1 : 0,
      'resolved_date': resolvedDate,
      'created_at': createdAt,
    };
  }

  factory UserSurgery.fromMap(Map<String, dynamic> map) {
    return UserSurgery(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      surgeryId: map['surgery_id'] as String,
      surgeryDate: map['surgery_date'] as String?,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      resolvedDate: map['resolved_date'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
