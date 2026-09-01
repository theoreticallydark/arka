class SymptomLog {
  final String id;
  final String userId;
  final String symptomId;
  final String timestamp;
  final double? numericValue;
  final bool? booleanValue;
  final String? textValue;
  final String? noteText;
  final String? voiceFilePath;
  final String createdAt;
  final String updatedAt;

  // Joined presentation fields
  final String? symptomName;
  final String? symptomIcon;
  final String? symptomAssetKey;
  final String? symptomUnit;
  final String? measurementType;

  SymptomLog({
    required this.id,
    required this.userId,
    required this.symptomId,
    required this.timestamp,
    this.numericValue,
    this.booleanValue,
    this.textValue,
    this.noteText,
    this.voiceFilePath,
    required this.createdAt,
    required this.updatedAt,
    this.symptomName,
    this.symptomIcon,
    this.symptomAssetKey,
    this.symptomUnit,
    this.measurementType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'symptom_id': symptomId,
      'timestamp': timestamp,
      'numeric_value': numericValue,
      'boolean_value': booleanValue == null ? null : (booleanValue! ? 1 : 0),
      'text_value': textValue,
      'note_text': noteText,
      'voice_file_path': voiceFilePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory SymptomLog.fromMap(Map<String, dynamic> map) {
    return SymptomLog(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      symptomId: map['symptom_id'] as String,
      timestamp: map['timestamp'] as String,
      numericValue: map['numeric_value'] != null ? (map['numeric_value'] as num).toDouble() : null,
      booleanValue: map['boolean_value'] != null ? (map['boolean_value'] as int) == 1 : null,
      textValue: map['text_value'] as String?,
      noteText: map['note_text'] as String?,
      voiceFilePath: map['voice_file_path'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      symptomName: map['symptom_name'] as String?,
      symptomIcon: map['symptom_icon'] as String?,
      symptomAssetKey: map['symptom_asset_key'] as String?,
      symptomUnit: map['symptom_unit'] as String?,
      measurementType: map['measurement_type'] as String?,
    );
  }

  String get formattedDisplayValue {
    if (numericValue != null) {
      if (measurementType == 'scale') {
        final val = numericValue!.toInt();
        if (val <= 3) return '$val/10 (Mild)';
        if (val <= 7) return '$val/10 (Moderate)';
        return '$val/10 (Severe)';
      }
      final numStr = numericValue! % 1 == 0 ? numericValue!.toInt().toString() : numericValue!.toStringAsFixed(1);
      return symptomUnit != null && symptomUnit!.isNotEmpty ? '$numStr $symptomUnit' : numStr;
    }
    if (booleanValue != null) {
      return booleanValue! ? 'Yes' : 'No';
    }
    if (textValue != null && textValue!.isNotEmpty) {
      return textValue!;
    }
    return 'Recorded';
  }
}
