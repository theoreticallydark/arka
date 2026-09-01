import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// Clean voice recorder dialog for recording symptom voice notes locally.
class VoiceRecorderDialog extends StatefulWidget {
  const VoiceRecorderDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const VoiceRecorderDialog(),
    );
  }

  @override
  State<VoiceRecorderDialog> createState() => _VoiceRecorderDialogState();
}

class _VoiceRecorderDialogState extends State<VoiceRecorderDialog> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _hasRecorded = false;
  bool _isPlaying = false;
  String? _recordedFilePath;

  int _recordingSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final voiceDir = Directory(p.join(dir.path, 'voice'));
        if (!await voiceDir.exists()) {
          await voiceDir.create(recursive: true);
        }

        final fileName = 'voice_${const Uuid().v4().substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final filePath = p.join(voiceDir.path, fileName);

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 64000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _hasRecorded = false;
          _recordedFilePath = filePath;
          _recordingSeconds = 0;
        });

        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingSeconds++;
          });
        });
      }
    } catch (e) {
      debugPrint('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _hasRecorded = true;
        _recordedFilePath = path ?? _recordedFilePath;
      });
    } catch (e) {
      debugPrint('Error stopping record: $e');
    }
  }

  Future<void> _togglePlayback() async {
    if (_recordedFilePath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _isPlaying = false);
      });
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
    }
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _isRecording
                  ? 'Recording Voice Note...'
                  : _hasRecorded
                      ? 'Voice Note Ready'
                      : 'Speak to Record',
              style: AppTypography.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _isRecording
                  ? 'Speak clearly into the microphone'
                  : _hasRecorded
                      ? 'Listen to your recording or save it'
                      : 'Tap the microphone button to start',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Timer display
            Text(
              _formatDuration(_recordingSeconds),
              style: AppTypography.displayLarge.copyWith(
                color: _isRecording ? AppColors.danger : AppColors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 24),

            // Big record / playback button
            GestureDetector(
              onTap: () {
                if (_isRecording) {
                  _stopRecording();
                } else if (_hasRecorded) {
                  _togglePlayback();
                } else {
                  _startRecording();
                }
              },
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? AppColors.danger
                      : _hasRecorded
                          ? AppColors.primary
                          : AppColors.primaryLight,
                  boxShadow: [
                    BoxShadow(
                      color: (_isRecording ? AppColors.danger : AppColors.primary).withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isRecording
                      ? Icons.stop
                      : _hasRecorded
                          ? (_isPlaying ? Icons.pause : Icons.play_arrow)
                          : Icons.mic,
                  size: 44,
                  color: _isRecording || _hasRecorded ? AppColors.textLight : AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),
            if (_hasRecorded)
              TextButton.icon(
                onPressed: _startRecording,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Record Again'),
              ),

            const SizedBox(height: 24),

            // Dialog Actions
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Cancel',
                    onPressed: () {
                      _timer?.cancel();
                      _audioRecorder.stop();
                      _audioPlayer.stop();
                      Navigator.of(context).pop(null);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Use Audio',
                    onPressed: _hasRecorded && _recordedFilePath != null
                        ? () {
                            _audioPlayer.stop();
                            Navigator.of(context).pop(_recordedFilePath);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
