import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/date_time_utils.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/symptom.dart';
import '../../data/models/symptom_log.dart';
import '../../data/repositories/condition_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/repositories/log_repository.dart';
import '../../design_system/cards/symptom_input_card.dart';
import '../../design_system/dialogs/voice_recorder_dialog.dart';
import '../../design_system/icons/medical_graphic_icon.dart';
import '../../design_system/theme/app_colors.dart';
import '../../design_system/theme/app_typography.dart';
import 'widgets/condition_recovery_bar.dart';
import 'widgets/dynamic_tip_banner.dart';

class LogScreen extends StatefulWidget {
  final UserProfile user;
  final VoidCallback onLogSaved;

  const LogScreen({
    super.key,
    required this.user,
    required this.onLogSaved,
  });

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final ConditionRepository _conditionRepo = ConditionRepository();
  final SymptomRepository _symptomRepo = SymptomRepository();
  final LogRepository _logRepo = LogRepository();

  List<ActiveHealthItem> _activeItems = [];
  List<Symptom> _userSymptoms = [];
  bool _isLoading = true;

  Symptom? _activeLoggingSymptom;
  String? _currentVoiceFilePath;

  @override
  void initState() {
    super.initState();
    _loadScreenData();
  }

  Future<void> _loadScreenData() async {
    setState(() => _isLoading = true);
    final active = await _conditionRepo.getActiveHealthItems(widget.user.id);
    final syms = await _symptomRepo.getUserTrackedSymptoms(widget.user.id);
    if (mounted) {
      setState(() {
        _activeItems = active;
        _userSymptoms = syms;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleMarkRecovered(ActiveHealthItem item) async {
    if (item.isSurgery) {
      await _conditionRepo.markSurgeryAsRecovered(item.junctionId);
    } else {
      await _conditionRepo.markConditionAsRecovered(item.junctionId);
    }
    _loadScreenData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} marked as recovered! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveSymptomLog(dynamic value, String? noteText, String? voiceFilePath) async {
    if (_activeLoggingSymptom == null) return;

    final now = DateTime.now().toIso8601String();
    final logId = const Uuid().v4();

    double? numVal;
    bool? boolVal;
    String? textVal;

    if (value is num) {
      numVal = value.toDouble();
    } else if (value is bool) {
      boolVal = value;
    } else if (value is String) {
      textVal = value;
    }

    final newLog = SymptomLog(
      id: logId,
      userId: widget.user.id,
      symptomId: _activeLoggingSymptom!.id,
      timestamp: now,
      numericValue: numVal,
      booleanValue: boolVal,
      textValue: textVal,
      noteText: noteText,
      voiceFilePath: voiceFilePath,
      createdAt: now,
      updatedAt: now,
    );

    await _logRepo.insertLog(newLog);

    setState(() {
      _activeLoggingSymptom = null;
      _currentVoiceFilePath = null;
    });

    if (mounted) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate('log.saved_snack')),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onLogSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final loc = AppLocalizations.of(context);
    final greetingKey = DateTimeUtils.getGreeting();
    final greeting = loc.translate(greetingKey);
    final todayStr = DateTimeUtils.formatHeaderDate(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Greeting (PRD Section 12)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, ${widget.user.name}',
                          style: AppTypography.displayMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${loc.translate('log.today')} · $todayStr',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Active Condition / Recovery Tracker
              ConditionRecoveryBar(
                activeItems: _activeItems,
                onMarkRecovered: _handleMarkRecovered,
              ),

              // Rotating Dynamic Tips
              const DynamicTipBanner(),

              // If actively recording a symptom, show the input card
              if (_activeLoggingSymptom != null) ...[
                Text(
                  'Record Symptom',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 12),
                SymptomInputCard(
                  symptomName: _activeLoggingSymptom!.defaultName,
                  symptomDescription: _activeLoggingSymptom!.defaultDescription,
                  icon: _activeLoggingSymptom!.materialIcon,
                  assetKey: _activeLoggingSymptom!.assetKey,
                  measurementType: _activeLoggingSymptom!.typeEnum,
                  unit: _activeLoggingSymptom!.unit,
                  currentVoiceFilePath: _currentVoiceFilePath,
                  onRecordVoice: () async {
                    final recordedPath = await VoiceRecorderDialog.show(context);
                    if (recordedPath != null) {
                      setState(() => _currentVoiceFilePath = recordedPath);
                    }
                  },
                  onClearVoice: () {
                    setState(() => _currentVoiceFilePath = null);
                  },
                  onCancel: () {
                    setState(() {
                      _activeLoggingSymptom = null;
                      _currentVoiceFilePath = null;
                    });
                  },
                  onSave: _saveSymptomLog,
                ),
                const SizedBox(height: 28),
              ] else ...[
                // Symptom Quick Selection
                Text(
                  loc.translate('log.tap_to_record'),
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  loc.translate('log.quick_log_prompt'),
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 16),

                if (_userSymptoms.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        loc.translate('log.no_active_symptoms'),
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  )
                else
                  ..._userSymptoms.map((sym) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _activeLoggingSymptom = sym;
                              _currentVoiceFilePath = null;
                            });
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.border, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                MedicalGraphicIcon(
                                  assetKey: sym.assetKey,
                                  fallbackIcon: sym.materialIcon,
                                  size: 28,
                                  iconColor: AppColors.primary,
                                  backgroundColor: AppColors.primaryLight,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sym.defaultName,
                                        style: AppTypography.titleMedium,
                                      ),
                                      if (sym.defaultDescription != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          sym.defaultDescription!,
                                          style: AppTypography.bodySmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
