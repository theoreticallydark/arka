import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/file_exporter.dart';
import '../../data/database/app_database.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/condition_repository.dart';
import '../../data/repositories/log_repository.dart';
import '../../design_system/dialogs/confirmation_dialog.dart';
import '../../design_system/theme/app_colors.dart';
import '../../design_system/theme/app_typography.dart';
import 'credits_screen.dart';
import 'manage_symptoms_screen.dart';

class SettingsScreen extends StatefulWidget {
  final UserProfile user;
  final Function(String languageCode) onLanguageChanged;
  final VoidCallback onDataReset;

  const SettingsScreen({
    super.key,
    required this.user,
    required this.onLanguageChanged,
    required this.onDataReset,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserRepository _userRepo = UserRepository();
  final ConditionRepository _conditionRepo = ConditionRepository();
  final LogRepository _logRepo = LogRepository();

  bool _isExporting = false;

  void _showLanguageSelector() {
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate('settings.language'),
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 16),
                ...AppLocalizations.supportedLanguages.map((lang) {
                  final isSelected = widget.user.preferredLanguage == lang.code;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(lang.nativeName, style: AppTypography.titleMedium),
                    subtitle: Text(lang.englishName, style: AppTypography.bodySmall),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () async {
                      final nav = Navigator.of(context);
                      await _userRepo.updateLanguage(widget.user.id, lang.code);
                      widget.onLanguageChanged(lang.code);
                      if (mounted) nav.pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportBackup() async {
    setState(() => _isExporting = true);
    try {
      final active = await _conditionRepo.getActiveHealthItems(widget.user.id);
      final logs = await _logRepo.getLogsForUser(widget.user.id);
      await FileExporter.exportAndShareJournal(
        user: widget.user,
        activeItems: active,
        logs: logs,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleDeleteAllData() async {
    final loc = AppLocalizations.of(context);
    final confirmed = await ConfirmationDialog.show(
      context,
      title: loc.translate('settings.delete_all_confirm_title'),
      message: loc.translate('settings.delete_all_confirm_msg'),
      confirmLabel: 'Delete Everything',
      isDestructive: true,
    );

    if (confirmed == true) {
      await AppDatabase.instance.deleteAllData();
      widget.onDataReset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings.title')),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : 'U',
                      style: AppTypography.displayMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.name, style: AppTypography.titleMedium),
                        Text(
                          '${widget.user.gender} · DOB/Age: ${widget.user.dateOfBirth}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Options
            _buildSettingTile(
              icon: Icons.language,
              title: loc.translate('settings.language'),
              subtitle: AppLocalizations.supportedLanguages
                  .firstWhere((l) => l.code == widget.user.preferredLanguage,
                      orElse: () => AppLocalizations.supportedLanguages.first)
                  .nativeName,
              onTap: _showLanguageSelector,
            ),
            _buildSettingTile(
              icon: Icons.tune,
              title: loc.translate('settings.manage_symptoms'),
              subtitle: 'Add or remove symptoms to track',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ManageSymptomsScreen(userId: widget.user.id),
                  ),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.archive_outlined,
              title: loc.translate('settings.backup_export'),
              subtitle: 'Save complete data and voice notes as ZIP',
              isLoading: _isExporting,
              onTap: _isExporting ? null : _exportBackup,
            ),
            _buildSettingTile(
              icon: Icons.info_outline,
              title: loc.translate('settings.credits'),
              subtitle: 'Medical graphics, licenses, and disclaimer',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreditsScreen()),
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Delete All Data (PRD Section 37)
            _buildSettingTile(
              icon: Icons.delete_forever,
              title: loc.translate('settings.delete_all_data'),
              subtitle: 'Permanently remove all logs on this device',
              isDestructive: true,
              onTap: _handleDeleteAllData,
            ),

            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Arka v0.1.0 (Offline & Private)',
                style: AppTypography.bodySmall,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDestructive ? AppColors.danger.withValues(alpha: 0.3) : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: isDestructive ? AppColors.danger : AppColors.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          color: isDestructive ? AppColors.danger : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(Icons.chevron_right, color: AppColors.borderStrong),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
