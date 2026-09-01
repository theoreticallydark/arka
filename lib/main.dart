import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localizations.dart';
import 'data/models/user_profile.dart';
import 'data/repositories/user_repository.dart';
import 'design_system/theme/app_theme.dart';
import 'features/navigation/main_navigation_shell.dart';
import 'features/onboarding/screens/onboarding_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArkaApp());
}

class ArkaApp extends StatefulWidget {
  const ArkaApp({super.key});

  @override
  State<ArkaApp> createState() => _ArkaAppState();
}

class _ArkaAppState extends State<ArkaApp> {
  final UserRepository _userRepo = UserRepository();
  UserProfile? _currentUser;
  bool _isLoading = true;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadAppState();
  }

  Future<void> _loadAppState() async {
    final user = await _userRepo.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _currentLanguage = user?.preferredLanguage ?? 'en';
        _isLoading = false;
      });
    }
  }

  void _onLanguageChanged(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(preferredLanguage: languageCode);
      }
    });
  }

  void _onOnboardingComplete() {
    _loadAppState();
  }

  void _onDataReset() {
    setState(() {
      _currentUser = null;
      _currentLanguage = 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Arka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: Locale(_currentLanguage),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLanguages
          .map((lang) => Locale(lang.code))
          .toList(),
      home: _currentUser != null && _currentUser!.isOnboarded
          ? MainNavigationShell(
              user: _currentUser!,
              onLanguageChanged: _onLanguageChanged,
              onDataReset: _onDataReset,
            )
          : OnboardingWrapper(
              onOnboardingComplete: _onOnboardingComplete,
            ),
    );
  }
}
