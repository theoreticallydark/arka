import 'package:flutter/material.dart';

class LanguageInfo {
  final String code;
  final String englishName;
  final String nativeName;
  final String scriptSubtitle;

  const LanguageInfo({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.scriptSubtitle,
  });
}

/// Central Localization Service with regional languages and natural Hinglish medical terms.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const List<LanguageInfo> supportedLanguages = [
    LanguageInfo(
      code: 'en',
      englishName: 'English',
      nativeName: 'English',
      scriptSubtitle: 'English',
    ),
    LanguageInfo(
      code: 'hi',
      englishName: 'Hindi',
      nativeName: 'हिन्दी',
      scriptSubtitle: 'Hindi',
    ),
    LanguageInfo(
      code: 'mr',
      englishName: 'Marathi',
      nativeName: 'मराठी',
      scriptSubtitle: 'Marathi',
    ),
    LanguageInfo(
      code: 'ta',
      englishName: 'Tamil',
      nativeName: 'தமிழ்',
      scriptSubtitle: 'Tamil',
    ),
    LanguageInfo(
      code: 'te',
      englishName: 'Telugu',
      nativeName: 'తెలుగు',
      scriptSubtitle: 'Telugu',
    ),
    LanguageInfo(
      code: 'bn',
      englishName: 'Bengali',
      nativeName: 'বাংলা',
      scriptSubtitle: 'Bengali',
    ),
    LanguageInfo(
      code: 'gu',
      englishName: 'Gujarati',
      nativeName: 'ગુજરાતી',
      scriptSubtitle: 'Gujarati',
    ),
    LanguageInfo(
      code: 'kn',
      englishName: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      scriptSubtitle: 'Kannada',
    ),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    // English
    'en': {
      'app_name': 'Arka',
      'onboarding.choose_language': 'Choose your language',
      'onboarding.choose_language_sub': 'Select the language you feel most comfortable with',
      'onboarding.tell_about_yourself': 'Tell us about yourself',
      'onboarding.name_label': 'Your Name',
      'onboarding.name_hint': 'e.g. Ramesh Sharma',
      'onboarding.gender_label': 'Gender',
      'onboarding.gender_male': 'Male',
      'onboarding.gender_female': 'Female',
      'onboarding.gender_other': 'Other',
      'onboarding.dob_label': 'Date of Birth (or Age)',
      'onboarding.height_label': 'Height (cm) - Optional',
      'onboarding.weight_label': 'Weight (kg) - Optional',
      'onboarding.conditions_title': 'Do you have any health conditions?',
      'onboarding.conditions_sub': 'Select all that apply to you',
      'onboarding.condition_none': 'No major conditions',
      'onboarding.condition_other': 'Other condition',
      'onboarding.goal_title': 'What would you like to track?',
      'onboarding.goal_sub': 'Help us customize your symptoms',
      'onboarding.goal_surgery': 'Recovering from Surgery / Operation',
      'onboarding.goal_surgery_sub': 'Recently had an operation and monitoring healing',
      'onboarding.goal_disease': 'Managing a Chronic Condition',
      'onboarding.goal_disease_sub': 'Tracking Sugar (Diabetes), BP, Thyroid, etc.',
      'onboarding.goal_general': 'General Health Observation',
      'onboarding.goal_general_sub': 'Maintaining a daily wellbeing journal',
      'onboarding.symptom_setup_title': 'These are things you can track',
      'onboarding.symptom_setup_sub': 'You can change these anytime in settings',
      'onboarding.add_another_symptom': 'Add another symptom',
      'onboarding.get_started': 'Get Started',
      'onboarding.continue': 'Continue',
      'onboarding.save': 'Save',
      'onboarding.select_surgery': 'Select your surgery / operation',

      // Main Navigation & Log
      'nav.log': 'Log',
      'nav.journal': 'Journal',
      'nav.more': 'More',
      'log.greeting_morning': 'Good morning',
      'log.greeting_afternoon': 'Good afternoon',
      'log.greeting_evening': 'Good evening',
      'log.greeting_night': 'Good night',
      'log.today': 'Today',
      'log.recovered_btn': 'Mark as Recovered',
      'log.recovered_modal_title': 'Mark as Recovered?',
      'log.recovered_modal_msg': 'Are you sure you want to mark this condition or surgery as recovered? You can still view past logs in your journal.',
      'log.tap_to_record': 'How are you feeling right now?',
      'log.quick_log_prompt': 'Tap a symptom below to record:',
      'log.anything_else': 'Anything else to record today?',
      'log.saved_snack': 'Health log recorded safely',
      'log.no_active_symptoms': 'No symptoms configured yet. Tap + to add symptoms to track.',

      // Journal
      'journal.title': 'Health Journal',
      'journal.share_whatsapp': 'Share on WhatsApp',
      'journal.empty_title': 'No health logs yet',
      'journal.empty_sub': 'Entries you record will show up here chronologically for you and your doctor.',
      'journal.filter_all': 'All Symptoms',
      'journal.delete_confirm_title': 'Delete this entry?',
      'journal.delete_confirm_msg': 'Are you sure you want to delete this symptom record and its attached voice note?',
      'journal.voice_note': 'Voice Note',

      // Settings
      'settings.title': 'Settings & Care',
      'settings.profile': 'Personal Profile',
      'settings.language': 'Change Language',
      'settings.manage_symptoms': 'Manage Tracked Symptoms',
      'settings.backup_export': 'Export Complete Backup (ZIP)',
      'settings.backup_import': 'Import / Restore Backup',
      'settings.delete_all_data': 'Delete All Arka Data',
      'settings.delete_all_confirm_title': 'Delete All Data Permanently?',
      'settings.delete_all_confirm_msg': 'This will delete all your local health logs, conditions, and voice notes. This action cannot be undone.',
      'settings.credits': 'Medical Graphics & Credits',
      'settings.disclaimer': 'Arka is a personal health symptom journal. It does not diagnose conditions or replace professional medical advice.',
    },

    // Hindi (with natural Hinglish terms like Sugar, BP, Operation)
    'hi': {
      'app_name': 'अर्क (Arka)',
      'onboarding.choose_language': 'अपनी भाषा चुनें',
      'onboarding.choose_language_sub': 'वह भाषा चुनें जिसमें आप सबसे सहज महसूस करते हैं',
      'onboarding.tell_about_yourself': 'अपने बारे में बताएं',
      'onboarding.name_label': 'आपका नाम',
      'onboarding.name_hint': 'जैसे: रमेश शर्मा',
      'onboarding.gender_label': 'लिंग',
      'onboarding.gender_male': 'पुरुष',
      'onboarding.gender_female': 'महिला',
      'onboarding.gender_other': 'अन्य',
      'onboarding.dob_label': 'जन्म तारीख (या उम्र)',
      'onboarding.height_label': 'ऊंचाई (सेमी) - वैकल्पिक',
      'onboarding.weight_label': 'वज़न (किग्रा) - वैकल्पिक',
      'onboarding.conditions_title': 'क्या आपको कोई स्वास्थ्य समस्या है?',
      'onboarding.conditions_sub': 'जो भी लागू हो, उसे चुनें',
      'onboarding.condition_none': 'कोई बड़ी समस्या नहीं',
      'onboarding.condition_other': 'अन्य समस्या',
      'onboarding.goal_title': 'आप क्या ट्रैक करना चाहते हैं?',
      'onboarding.goal_sub': 'इससे हम आपके लक्षण तय करने में मदद करेंगे',
      'onboarding.goal_surgery': 'ऑपरेशन / सर्जरी के बाद रिकवरी',
      'onboarding.goal_surgery_sub': 'हाल ही में ऑपरेशन हुआ है और सुधार देखना है',
      'onboarding.goal_disease': 'बीमारी या स्थिति का ध्यान रखना',
      'onboarding.goal_disease_sub': 'शुगर (Diabetes), बीपी (BP), थायरॉइड आदि की निगरानी',
      'onboarding.goal_general': 'सामान्य स्वास्थ्य डायरी',
      'onboarding.goal_general_sub': 'रोज़मर्रा की सेहत का ध्यान रखना',
      'onboarding.symptom_setup_title': 'ये लक्षण आप रोज़ रिकॉर्ड कर सकते हैं',
      'onboarding.symptom_setup_sub': 'इन्हें आप बाद में सेटिंग्स से भी बदल सकते हैं',
      'onboarding.add_another_symptom': 'नया लक्षण जोड़ें',
      'onboarding.get_started': 'शुरू करें',
      'onboarding.continue': 'आगे बढ़ें',
      'onboarding.save': 'सुरक्षित करें',
      'onboarding.select_surgery': 'अपना ऑपरेशन / सर्जरी चुनें',

      // Main Navigation & Log
      'nav.log': 'दर्ज करें',
      'nav.journal': 'डायरी',
      'nav.more': 'अन्य',
      'log.greeting_morning': 'सुप्रभात',
      'log.greeting_afternoon': 'शुभ दोपहर',
      'log.greeting_evening': 'शुभ संध्या',
      'log.greeting_night': 'शुभ रात्रि',
      'log.today': 'आज',
      'log.recovered_btn': 'ठीक हो गया (Recovered)',
      'log.recovered_modal_title': 'क्या आप पूरी तरह ठीक हो गए हैं?',
      'log.recovered_modal_msg': 'क्या आप इस स्थिति या ऑपरेशन को ठीक (Recovered) मार्क करना चाहते हैं? पुराने रिकॉर्ड डायरी में सुरक्षित रहेंगे।',
      'log.tap_to_record': 'आज आपकी तबीयत कैसी है?',
      'log.quick_log_prompt': 'दर्ज करने के लिए नीचे लक्षण पर टैप करें:',
      'log.anything_else': 'क्या आज कुछ और भी दर्ज करना है?',
      'log.saved_snack': 'स्वास्थ्य रिकॉर्ड सुरक्षित कर लिया गया है',
      'log.no_active_symptoms': 'अभी कोई लक्षण नहीं है। नया जोड़ने के लिए + दबाएं।',

      // Journal
      'journal.title': 'स्वास्थ्य डायरी',
      'journal.share_whatsapp': 'WhatsApp पर शेयर करें',
      'journal.empty_title': 'अभी कोई रिकॉर्ड नहीं है',
      'journal.empty_sub': 'आपके द्वारा दर्ज की गई जानकारी यहाँ तारीख के अनुसार दिखेगी।',
      'journal.filter_all': 'सभी लक्षण',
      'journal.delete_confirm_title': 'क्या यह रिकॉर्ड मिटाना चाहते हैं?',
      'journal.delete_confirm_msg': 'क्या आप इस लक्षण और इससे जुड़ी आवाज़ (Voice Note) को हटाना चाहते हैं?',
      'journal.voice_note': 'आवाज़ रिकॉर्डिंग',

      // Settings
      'settings.title': 'सेटिंग्स और देखभाल',
      'settings.profile': 'व्यक्तिगत प्रोफ़ाइल',
      'settings.language': 'भाषा बदलें',
      'settings.manage_symptoms': 'ट्रैक किए जाने वाले लक्षण',
      'settings.backup_export': 'पूरा बैकअप डाउनलोड करें (ZIP)',
      'settings.backup_import': 'बैकअप वापस लाएं (Restore)',
      'settings.delete_all_data': 'अर्क का सारा डेटा मिटाएं',
      'settings.delete_all_confirm_title': 'क्या सारा डेटा हमेशा के लिए मिटाना है?',
      'settings.delete_all_confirm_msg': 'इससे आपके सभी स्वास्थ्य रिकॉर्ड और वॉइस नोट्स मिट जाएंगे। यह वापस नहीं लाया जा सकता।',
      'settings.credits': 'मेडिकल ग्राफ़िक्स और आभार',
      'settings.disclaimer': 'अर्क एक व्यक्तिगत स्वास्थ्य डायरी है। यह डॉक्टर की सलाह या इलाज का विकल्प नहीं है।',
    },

    // Marathi (with colloquial terms like Sugar, BP, Operation)
    'mr': {
      'app_name': 'अर्क (Arka)',
      'onboarding.choose_language': 'तुमची भाषा निवडा',
      'onboarding.choose_language_sub': 'तुम्हाला सर्वात सोपी वाटणारी भाषा निवडा',
      'onboarding.tell_about_yourself': 'तुमच्याबद्दल माहिती द्या',
      'onboarding.name_label': 'तुमचे नाव',
      'onboarding.name_hint': 'उदा. रमेश जोशी',
      'onboarding.gender_label': 'लिंग',
      'onboarding.gender_male': 'पुरुष',
      'onboarding.gender_female': 'स्त्री',
      'onboarding.gender_other': 'इतर',
      'onboarding.dob_label': 'जन्मतारीख (किंवा वय)',
      'onboarding.height_label': 'उंची (सेमी) - पर्यायी',
      'onboarding.weight_label': 'वजन (किलो) - पर्यायी',
      'onboarding.conditions_title': 'तुम्हाला आरोग्याची काही समस्या आहे का?',
      'onboarding.conditions_sub': 'लागू असलेले पर्याय निवडा',
      'onboarding.condition_none': 'कोणताही मोठा आजार नाही',
      'onboarding.condition_other': 'इतर समस्या',
      'onboarding.goal_title': 'तुम्हाला काय ट्रॅक करायचे आहे?',
      'onboarding.goal_sub': 'यानुसार आम्ही तुमच्यासाठी योग्य लक्षणे निवडू',
      'onboarding.goal_surgery': 'ऑपरेशन / शस्त्रक्रियेनंतरची रिकव्हरी',
      'onboarding.goal_surgery_sub': 'नुकतेच ऑपरेशन झाले आहे आणि सुधारणा तपासायची आहे',
      'onboarding.goal_disease': 'आजाराची नियमित काळजी',
      'onboarding.goal_disease_sub': 'शुगर (Diabetes), बीपी (BP), थायरॉईड इत्यादींची नोंद',
      'onboarding.goal_general': 'नियमित आरोग्य रोजनिशी',
      'onboarding.goal_general_sub': 'दैनंदिन तब्येतीची साधी नोंद',
      'onboarding.symptom_setup_title': 'ही लक्षणे तुम्ही दररोज नोंदवू शकता',
      'onboarding.symptom_setup_sub': 'हे तुम्ही नंतर सेटिंग्समधून कधीही बदलू शकता',
      'onboarding.add_another_symptom': 'नवीन लक्षण जोडा',
      'onboarding.get_started': 'सुरू करा',
      'onboarding.continue': 'पुढे जा',
      'onboarding.save': 'जतन करा',
      'onboarding.select_surgery': 'तुमचे ऑपरेशन / शस्त्रक्रिया निवडा',

      // Main Navigation & Log
      'nav.log': 'नोंद करा',
      'nav.journal': 'रोजनिशी',
      'nav.more': 'अधिक',
      'log.greeting_morning': 'शुभ प्रभात',
      'log.greeting_afternoon': 'शुभ दुपार',
      'log.greeting_evening': 'शुभ संध्याकाळ',
      'log.greeting_night': 'शुभ रात्री',
      'log.today': 'आज',
      'log.recovered_btn': 'बरे झाले (Recovered)',
      'log.recovered_modal_title': 'तुम्ही पूर्णपणे बरे झाला आहात का?',
      'log.recovered_modal_msg': 'तुम्ही ही समस्या किंवा ऑपरेशन बरे झाले (Recovered) म्हणून नोंदवू इच्छिता? जुने रेकॉर्ड सुरक्षित राहतील.',
      'log.tap_to_record': 'आज तुम्हाला कसे वाटत आहे?',
      'log.quick_log_prompt': 'नोंद करण्यासाठी खालील लक्षणावर टॅप करा:',
      'log.anything_else': 'आज आणखी काही नोंदवायचे आहे का?',
      'log.saved_snack': 'आरोग्य नोंद सुरक्षित केली आहे',
      'log.no_active_symptoms': 'अद्याप लक्षणे जोडलेली नाहीत. नवीन जोडण्यासाठी + दाबा.',

      // Journal
      'journal.title': 'आरोग्य रोजनिशी',
      'journal.share_whatsapp': 'WhatsApp वर शेअर करा',
      'journal.empty_title': 'अद्याप कोणतीही नोंद नाही',
      'journal.empty_sub': 'तुम्ही नोंदवलेली माहिती येथे तारखेनुसार दिसेल.',
      'journal.filter_all': 'सर्व लक्षणे',
      'journal.delete_confirm_title': 'ही नोंद हटवायची आहे का?',
      'journal.delete_confirm_msg': 'तुम्हाला ही नोंद आणि त्यासोबतची व्हॉईस नोट कायमची हटवायची आहे का?',
      'journal.voice_note': 'व्हॉईस नोट',

      // Settings
      'settings.title': 'सेटिंग्स आणि काळजी',
      'settings.profile': 'वैयक्तिक प्रोफाइल',
      'settings.language': 'भाषा बदला',
      'settings.manage_symptoms': 'ट्रॅक केली जाणारी लक्षणे',
      'settings.backup_export': 'संपूर्ण बॅकअप डाऊनलोड करा (ZIP)',
      'settings.backup_import': 'बॅकअप परत आणा (Restore)',
      'settings.delete_all_data': 'अर्कचा सर्व डेटा हटवा',
      'settings.delete_all_confirm_title': 'सर्व डेटा कायमचा हटवायचा आहे का?',
      'settings.delete_all_confirm_msg': 'यामुळे तुमचे सर्व रेकॉर्ड आणि व्हॉईस नोट्स कायमचे हटवले जातील. ही कृती पूर्ववत करता येणार नाही.',
      'settings.credits': 'वैद्यकीय ग्राफिक्स आणि आभार',
      'settings.disclaimer': 'अर्क ही वैयक्तिक आरोग्य नोंदवही आहे. हे डॉक्टरांच्या सल्ल्याचा किंवा उपचारांचा पर्याय नाही.',
    },
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  String translate(String key) {
    final languageCode = locale.languageCode;
    if (_localizedValues.containsKey(languageCode) &&
        _localizedValues[languageCode]!.containsKey(key)) {
      return _localizedValues[languageCode]![key]!;
    }
    // Fallback to English
    return _localizedValues['en']?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
        'hi',
        'mr',
        'ta',
        'te',
        'bn',
        'gu',
        'kn',
      ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
