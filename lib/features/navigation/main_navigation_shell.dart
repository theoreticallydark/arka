import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/user_profile.dart';
import '../../design_system/theme/app_colors.dart';
import '../log/log_screen.dart';
import '../journal/journal_screen.dart';
import '../settings/settings_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final UserProfile user;
  final Function(String languageCode) onLanguageChanged;
  final VoidCallback onDataReset;

  const MainNavigationShell({
    super.key,
    required this.user,
    required this.onLanguageChanged,
    required this.onDataReset,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final pages = [
      LogScreen(
        user: widget.user,
        onLogSaved: () {
          // Switch to journal or stay on log
        },
      ),
      JournalScreen(user: widget.user),
      SettingsScreen(
        user: widget.user,
        onLanguageChanged: widget.onLanguageChanged,
        onDataReset: widget.onDataReset,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryLight,
          height: 72, // Large 72dp touch friendly bottom bar
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.edit_note_outlined, size: 28),
              selectedIcon: const Icon(Icons.edit_note, color: AppColors.primary, size: 30),
              label: loc.translate('nav.log'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_stories_outlined, size: 26),
              selectedIcon: const Icon(Icons.auto_stories, color: AppColors.primary, size: 28),
              label: loc.translate('nav.journal'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, size: 26),
              selectedIcon: const Icon(Icons.settings, color: AppColors.primary, size: 28),
              label: loc.translate('nav.more'),
            ),
          ],
        ),
      ),
    );
  }
}
