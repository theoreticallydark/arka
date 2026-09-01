import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/symptom_log.dart';
import '../../data/repositories/condition_repository.dart';
import 'date_time_utils.dart';

class FileExporter {
  FileExporter._();

  /// Generates a complete human-readable journal.txt
  static String generateJournalText({
    required UserProfile user,
    required List<ActiveHealthItem> activeItems,
    required List<SymptomLog> logs,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('====================================================');
    buffer.writeln('          ARKA HEALTH SYMPTOM JOURNAL               ');
    buffer.writeln('====================================================');
    buffer.writeln('Generated on: ${DateTime.now().toLocal().toString()}');
    buffer.writeln('');
    buffer.writeln('PATIENT PROFILE:');
    buffer.writeln('  Name: ${user.name}');
    buffer.writeln('  Gender: ${user.gender}');
    buffer.writeln('  DOB / Age: ${user.dateOfBirth}');
    if (user.heightCm != null) buffer.writeln('  Height: ${user.heightCm} cm');
    if (user.weightKg != null) buffer.writeln('  Weight: ${user.weightKg} kg');
    buffer.writeln('');

    buffer.writeln('CURRENT CONDITIONS & RECOVERIES:');
    if (activeItems.isEmpty) {
      buffer.writeln('  None active / All recovered');
    } else {
      for (final item in activeItems) {
        buffer.writeln('  - ${item.name} (${item.isSurgery ? 'Surgery / Operation' : 'Health Condition'})');
      }
    }
    buffer.writeln('');

    buffer.writeln('----------------------------------------------------');
    buffer.writeln('               RECORDED SYMPTOM LOGS                ');
    buffer.writeln('----------------------------------------------------');

    if (logs.isEmpty) {
      buffer.writeln('No entries recorded yet.');
    } else {
      String? lastDate;
      for (final log in logs) {
        final dt = DateTime.tryParse(log.timestamp) ?? DateTime.now();
        final dateHeader = DateTimeUtils.formatLogDateGroup(dt);

        if (dateHeader != lastDate) {
          buffer.writeln('');
          buffer.writeln('[$dateHeader]');
          lastDate = dateHeader;
        }

        final timeStr = DateTimeUtils.formatLogTime(dt);
        buffer.writeln('  • $timeStr — ${log.symptomName ?? 'Symptom'}: ${log.formattedDisplayValue}');
        if (log.noteText != null && log.noteText!.isNotEmpty) {
          buffer.writeln('    Note: "${log.noteText}"');
        }
        if (log.voiceFilePath != null && log.voiceFilePath!.isNotEmpty) {
          final voiceFileName = p.basename(log.voiceFilePath!);
          buffer.writeln('    Voice Note attached: voice/$voiceFileName');
        }
      }
    }

    buffer.writeln('');
    buffer.writeln('====================================================');
    buffer.writeln('End of Arka Health Journal');
    buffer.writeln('====================================================');

    return buffer.toString();
  }

  /// Packages journal.txt and all voice recordings into a standard ZIP and invokes native share.
  static Future<void> exportAndShareJournal({
    required UserProfile user,
    required List<ActiveHealthItem> activeItems,
    required List<SymptomLog> logs,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateTimeUtils.formatExportDate(DateTime.now());
      final zipFileName = 'Arka_Health_Journal_$dateStr.zip';
      final zipFilePath = p.join(tempDir.path, zipFileName);

      final archive = Archive();

      // 1. Add journal.txt
      final journalText = generateJournalText(
        user: user,
        activeItems: activeItems,
        logs: logs,
      );
      final textBytes = utf8.encode(journalText);
      archive.addFile(ArchiveFile('journal.txt', textBytes.length, textBytes));

      // 2. Add voice note audio files if present
      for (final log in logs) {
        if (log.voiceFilePath != null && log.voiceFilePath!.isNotEmpty) {
          final file = File(log.voiceFilePath!);
          if (await file.exists()) {
            final fileName = p.basename(log.voiceFilePath!);
            final audioBytes = await file.readAsBytes();
            archive.addFile(ArchiveFile('voice/$fileName', audioBytes.length, audioBytes));
          }
        }
      }

      // 3. Encode & Write ZIP
      final zipData = ZipEncoder().encode(archive);
      if (zipData != null) {
        final zipFile = File(zipFilePath);
        await zipFile.writeAsBytes(zipData, flush: true);

        // 4. Share using cross-platform native ShareSheet with strictly defined MIME type (PRD Section 48)
        await Share.shareXFiles(
          [
            XFile(
              zipFilePath,
              mimeType: 'application/zip',
              name: zipFileName,
            ),
          ],
          text: 'Arka Health Journal for ${user.name} ($dateStr)',
          subject: 'Arka Health Journal ($dateStr)',
        );
      }
    } catch (e) {
      debugPrint('Error exporting journal ZIP: $e');
      rethrow;
    }
  }
}
