import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/date_time_utils.dart';
import '../../data/models/symptom_log.dart';
import '../../data/repositories/log_repository.dart';
import '../../design_system/dialogs/confirmation_dialog.dart';
import '../../design_system/icons/medical_graphic_icon.dart';
import '../../design_system/theme/app_colors.dart';
import '../../design_system/theme/app_typography.dart';
import '../../design_system/buttons/secondary_button.dart';

class JournalDetailScreen extends StatefulWidget {
  final SymptomLog log;
  final VoidCallback onLogDeleted;

  const JournalDetailScreen({
    super.key,
    required this.log,
    required this.onLogDeleted,
  });

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  final LogRepository _logRepo = LogRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _audioExists = false;

  @override
  void initState() {
    super.initState();
    _checkAudio();
  }

  Future<void> _checkAudio() async {
    if (widget.log.voiceFilePath != null) {
      final file = File(widget.log.voiceFilePath!);
      if (await file.exists()) {
        setState(() => _audioExists = true);
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (!_audioExists || widget.log.voiceFilePath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
      await _audioPlayer.play(DeviceFileSource(widget.log.voiceFilePath!));
    }
  }

  Future<void> _handleDelete() async {
    final loc = AppLocalizations.of(context);
    final confirmed = await ConfirmationDialog.show(
      context,
      title: loc.translate('journal.delete_confirm_title'),
      message: loc.translate('journal.delete_confirm_msg'),
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true) {
      if (widget.log.voiceFilePath != null) {
        final f = File(widget.log.voiceFilePath!);
        if (await f.exists()) {
          try {
            await f.delete();
          } catch (_) {}
        }
      }

      await _logRepo.deleteLog(widget.log.id);
      widget.onLogDeleted();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final dt = DateTime.tryParse(widget.log.timestamp) ?? DateTime.now();
    final dateStr = DateTimeUtils.formatLogDateGroup(dt);
    final timeStr = DateTimeUtils.formatLogTime(dt);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.log.symptomName ?? 'Symptom Detail'),
        actions: [
          IconButton(
            tooltip: 'Delete Log',
            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 26),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    MedicalGraphicIcon(
                      assetKey: widget.log.symptomAssetKey,
                      fallbackIcon: Icons.healing,
                      size: 36,
                      iconColor: AppColors.primary,
                      backgroundColor: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.log.symptomName ?? 'Symptom',
                            style: AppTypography.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$dateStr at $timeStr',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Recorded Value Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recorded Value',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.log.formattedDisplayValue,
                      style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Voice Note Player if present
              if (_audioExists) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton.filled(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 28),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(52, 52),
                        ),
                        onPressed: _toggleAudio,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate('journal.voice_note'),
                              style: AppTypography.titleMedium,
                            ),
                            Text(
                              _isPlaying ? 'Playing...' : 'Tap to listen',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Notes Card if present
              if (widget.log.noteText != null && widget.log.noteText!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notes',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.log.noteText!,
                        style: AppTypography.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // Delete button at bottom
              SecondaryButton(
                label: 'Delete This Log',
                icon: Icons.delete_outline,
                borderColor: AppColors.danger,
                textColor: AppColors.danger,
                onPressed: _handleDelete,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
