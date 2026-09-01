import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/file_exporter.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/symptom_log.dart';
import '../../../data/repositories/condition_repository.dart';
import '../../../design_system/theme/app_colors.dart';
import '../../../design_system/theme/app_typography.dart';

class WhatsAppShareBar extends StatefulWidget {
  final UserProfile user;
  final List<ActiveHealthItem> activeItems;
  final List<SymptomLog> logs;

  const WhatsAppShareBar({
    super.key,
    required this.user,
    required this.activeItems,
    required this.logs,
  });

  @override
  State<WhatsAppShareBar> createState() => _WhatsAppShareBarState();
}

class _WhatsAppShareBarState extends State<WhatsAppShareBar> {
  bool _isSharing = false;

  Future<void> _shareOnWhatsApp() async {
    setState(() => _isSharing = true);
    try {
      await FileExporter.exportAndShareJournal(
        user: widget.user,
        activeItems: widget.activeItems,
        logs: widget.logs,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not share journal: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: const Color(0xFF25D366), // Official WhatsApp Green
        borderRadius: BorderRadius.circular(18),
        elevation: 0,
        child: InkWell(
          onTap: _isSharing ? null : _shareOnWhatsApp,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSharing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else ...[
                  const Icon(Icons.share, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    loc.translate('journal.share_whatsapp'),
                    style: AppTypography.buttonLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
