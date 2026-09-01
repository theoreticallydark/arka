import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/date_time_utils.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/symptom.dart';
import '../../data/models/symptom_log.dart';
import '../../data/repositories/condition_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/repositories/log_repository.dart';
import '../../design_system/icons/medical_graphic_icon.dart';
import '../../design_system/theme/app_colors.dart';
import '../../design_system/theme/app_typography.dart';
import 'journal_detail_screen.dart';
import 'widgets/whatsapp_share_bar.dart';

class JournalScreen extends StatefulWidget {
  final UserProfile user;

  const JournalScreen({super.key, required this.user});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final LogRepository _logRepo = LogRepository();
  final SymptomRepository _symptomRepo = SymptomRepository();
  final ConditionRepository _conditionRepo = ConditionRepository();

  List<SymptomLog> _logs = [];
  List<Symptom> _allSymptoms = [];
  List<ActiveHealthItem> _activeItems = [];
  String? _selectedFilterSymptomId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournalData();
  }

  Future<void> _loadJournalData() async {
    setState(() => _isLoading = true);
    final logs = await _logRepo.getLogsForUser(
      widget.user.id,
      filterSymptomId: _selectedFilterSymptomId,
    );
    final syms = await _symptomRepo.getAllSymptoms();
    final active = await _conditionRepo.getActiveHealthItems(widget.user.id);

    if (mounted) {
      setState(() {
        _logs = logs;
        _allSymptoms = syms;
        _activeItems = active;
        _isLoading = false;
      });
    }
  }

  Map<String, List<SymptomLog>> _groupLogsByDate() {
    final Map<String, List<SymptomLog>> groups = {};
    for (final log in _logs) {
      final dt = DateTime.tryParse(log.timestamp) ?? DateTime.now();
      final dateKey = DateTimeUtils.formatLogDateGroup(dt);
      groups.putIfAbsent(dateKey, () => []).add(log);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final groupedLogs = _groupLogsByDate();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('journal.title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WhatsApp Share Bar (PRD Section 20)
              WhatsAppShareBar(
                user: widget.user,
                activeItems: _activeItems,
                logs: _logs,
              ),

              // Filter Chips (PRD Section 19)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: loc.translate('journal.filter_all'),
                      isSelected: _selectedFilterSymptomId == null,
                      onTap: () {
                        setState(() => _selectedFilterSymptomId = null);
                        _loadJournalData();
                      },
                    ),
                    const SizedBox(width: 8),
                    ..._allSymptoms.map((sym) {
                      final isSelected = _selectedFilterSymptomId == sym.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildFilterChip(
                          label: sym.defaultName.split('/').first.trim(),
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => _selectedFilterSymptomId = sym.id);
                            _loadJournalData();
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Empty State
              if (_logs.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_stories_outlined,
                            size: 36,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.translate('journal.empty_title'),
                          style: AppTypography.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.translate('journal.empty_sub'),
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Chronological Grouped List
                ...groupedLogs.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Text(
                          entry.key,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ...entry.value.map((log) => _buildJournalItemCard(log)),
                    ],
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

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.textLight : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildJournalItemCard(SymptomLog log) {
    final dt = DateTime.tryParse(log.timestamp) ?? DateTime.now();
    final timeStr = DateTimeUtils.formatLogTime(dt);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => JournalDetailScreen(
                  log: log,
                  onLogDeleted: _loadJournalData,
                ),
              ),
            );
            _loadJournalData();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                MedicalGraphicIcon(
                  assetKey: log.symptomAssetKey,
                  fallbackIcon: Icons.healing,
                  size: 26,
                  iconColor: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            log.symptomName ?? 'Symptom',
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            timeStr,
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log.formattedDisplayValue,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (log.noteText != null && log.noteText!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          log.noteText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall,
                        ),
                      ],
                      if (log.voiceFilePath != null) ...[
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.mic, size: 16, color: AppColors.success),
                            SizedBox(width: 4),
                            Text(
                              'Voice note attached',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppColors.borderStrong),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
