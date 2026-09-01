# Arka — Product Requirements Document

**Product:** Arka  
**Platform:** Cross-platform mobile application (Android & iOS)  
**Primary audience:** Indian adults aged 40+, particularly parents/elderly users with limited technology familiarity  
**Primary use case:** Simple, private, longitudinal symptom and health-event journaling  
**Data architecture:** 100% local / offline-first; no account or cloud backend required

## 1. Product Overview

Arka is a privacy-first mobile application that helps users record and review their health symptoms over time.  
The application is designed specifically for Indian parents and older adults who may:

- Prefer a regional Indian language over English
- Have limited familiarity with smartphones
- Need to monitor symptoms associated with a disease
- Be recovering from a surgery
- Want to maintain a general health journal
- Need to share their health history with a doctor or family member

The core interaction should be extremely simple:  
Open Arka → record how you feel → save → close.  
The application should avoid dashboards, complicated charts, excessive configuration, medical jargon, accounts, passwords, and unnecessary notifications.

## 2. Product Principles

**2.1 Simplicity over feature density**

- Every screen should answer one question or request one action.
- Avoid presenting users with large lists of options.

**2.2 Local-first privacy**

- Health data is sensitive.
- Arka should store all user data locally on the device.
- There should be: No account, No login, No cloud database, No mandatory internet connection, No analytics requiring transmission of health data, No automatic sharing.

**2.3 Designed for older adults**

- The UI should optimize for: Large touch targets, Large typography, High contrast, Simple navigation, Minimal scrolling, Clear icons, Plain language, Regional-language-first UX, Voice input where useful.

**2.4 Doctor-friendly data**

- The application should not attempt to diagnose the user.
- Its purpose is to create a reliable record that can be shared with a doctor.

**2.5 Progressive complexity**

- The first experience should be extremely simple.
- Advanced functionality such as editing profile information, managing symptoms, exporting data, and changing settings should exist but should not interfere with the primary logging flow.

## 3. Target Users

**Primary User**
Indian parent/elderly user, approximately 40+, who:

- Uses Android or iOS
- May not be comfortable with complex applications
- May prefer Hindi, Marathi, Tamil, Telugu, Bengali, Gujarati, Kannada, Malayalam, Punjabi, Odia, Assamese, Urdu, etc.
- May have diabetes, thyroid conditions, asthma, hypertension, or another chronic disease
- May be recovering from surgery
- May have a family member helping them initially configure the application

**Secondary User**
A family member or caregiver who helps configure Arka for the primary user.  
After setup, the primary user should be able to use the application independently.

## 4. Supported Languages & Fallbacks

The application should be architected for full localization.

**Initial language selection**
On first launch: "Choose your language". Display languages using their native names/scripts rather than only English names. (e.g., मराठी, हिन्दी, বাংলা, தமிழ், English). The exact supported-language list should be configurable.

**Localization requirements**
All UI text, buttons, labels, errors, and names must be localized using localization keys (e.g., `onboarding.choose_language`). Do not concatenate translated strings programmatically.

**Language Fallbacks & "Hinglish"**
Since some medical terms lack standardized regional translations, implement a fallback mechanism to English for specific edge-case names. Importantly, use colloquial terminology or "Hinglish" (e.g., using words like "Sugar", "BP", or "Operation" written in regional scripts) as most users are more familiar with these than pure clinical regional translations. **Antigravity must prioritize this natural language nuance well to ensure usability.**

## 5. First Launch / Onboarding

Onboarding should be completed once. After onboarding, opening the application should go directly to the symptom logging screen.

**Step 1 — Language**
Screen: Choose your language (Large language cards/buttons). Selecting a language immediately changes the UI. No "Apply" button should be required.

## 6. Step 2 — Basic Details

Title: "Tell us about yourself"

- Required: Name, Gender, Date of birth
- Optional: Height, Weight

## 7. Step 3 — Existing Health Conditions

Title: "Do you have any health conditions?"
Present common conditions as visual cards (Diabetes, Thyroid, High blood pressure, Asthma, etc., plus "None" and "Other").
Use progressive selection to avoid displaying an enormous medical-condition catalogue.

## 8. Step 4 — Why Are You Using Arka?

Title: "What would you like to track?"

- A. Recovering from surgery ("I recently had surgery" -> Select surgery)
- B. Tracking a disease ("I have a health condition" -> Select condition)
- C. General health observation ("I want to observe my health")

## 9. Symptom Recommendation Engine

Arka should determine an initial set of relevant symptoms based on the user's context (User profile + Existing conditions + Surgery + Tracking goal -> Recommended symptoms).

- Example (Knee surgery): Knee pain, Swelling, Difficulty walking, Stiffness, Fever.
  The exact clinical mapping should be stored in a versioned local configuration.

## 10. Symptom Configuration

After recommendations are generated, show: "These are the things you can track."
Display a manageable number of symptoms (Target: 5–8 initially). Each symptom should have an icon, name, short description, and measurement type.
Allow "Add another symptom" but keep it secondary.

## 11. Measurement Types

Symptoms should support configurable measurement types:

- Scale (1–10, with descriptive anchors)
- Yes / No
- Numeric (e.g., Blood glucose)
- Duration
- Text
- Voice note

## 12. Main Screen — Log

This is the most important screen in the application.

**Header & Current Condition Status**
Display: "Good morning, [Name] | Today · 1 September"
**Condition Tracker:** At the top of the Log Page, explicitly show the conditions or surgeries the user is currently facing. Provide a highly visible, simple option next to each to mark that they have **"Recovered"** from it. **This action must trigger a confirmation modal to prevent accidental taps.**

**Symptom Card**
Show one symptom at a time or a very small number of symptoms (e.g., Pain [1 to 10 scale]). Large controls. After saving, prompt "Anything else?" so the user can continue or finish.

## 13. Dynamic Placeholder / Tips

The logging screen should periodically change contextual helper text (e.g., "You can record pain, fever or dizziness."). The placeholder should be deterministic/randomized enough to avoid feeling repetitive.

## 14. Notes

Every log should optionally support notes via "Type" (text field) or "Speak" (Voice recording stored locally).

## 15. Date & Time

Every log must automatically contain Date, Time, Local timezone, Symptom, Value, Note, Optional voice recording. Provide an optional "Change time" for retrospective logging.

## 16. Saving a Log

Primary CTA: Save. Secondary: Add another. After saving, show a lightweight confirmation ("Saved") and return to the home logging screen.

## 17. Logs / Journal

Navigation: Log | Journal | More
Chronological journal of all recorded entries grouped by date.

## 18. Journal Detail

Selecting an entry opens its details, allowing actions to Edit or Delete. **Deleting a log (and its associated audio file) must require a clear confirmation prompt before the deletion is executed.**

## 19. Journal Filtering

Provide one simple optional filter: "Show symptom" (e.g., All, Pain, Fever).

## 20. WhatsApp Sharing

The Journal screen must contain a highly visible action: "Share on WhatsApp".

- Generate a ZIP archive locally (e.g., `Arka_Health_Journal_2026-09-01.zip`).
- Contents: `journal.txt` (Human-readable) and `voice/` directory with `.m4a` files.
- Use native OS share mechanisms (Android ShareSheet / iOS UIActivityViewController) to share the ZIP. Do not automate WhatsApp directly.

## 21. Local Data Architecture

Recommended architecture: Structured local database (SQLite/Isar/Room/CoreData depending on framework) and local file storage for audio.

## 22. Core Data Model

**User**

- id, name, gender, date_of_birth, height_cm, weight_kg, preferred_language, created_at, updated_at

**Condition**

- id, name_key, icon, category

**UserCondition**

- user_id, condition_id, **is_active (boolean)**, **resolved_date (timestamp)**, created_at

**Surgery**

- id, name_key, icon, category

**UserSurgery**

- user_id, surgery_id, surgery_date, **is_active (boolean)**, **resolved_date (timestamp)**

**Symptom**

- id, name_key, description_key, icon, measurement_type, unit, active

**UserSymptom**

- user_id, symptom_id, sort_order, enabled

**Log**

- id, symptom_id, timestamp, numeric_value, boolean_value, text_value, note_text, voice_file_path, created_at, updated_at

## 23. Offline Requirements

Arka must work without internet after installation for all core functions (logging, journal, sharing locally generated ZIP, etc.).

## 24. Privacy

No cloud synchronization in MVP. No analytics containing health information.

## 25. Backup / Restore

MVP should provide Export Backup (all local Arka data into a ZIP) and Import Backup to restore.

## 26. Accessibility

- Typography: Large default text, respect OS font scaling.
- Touch targets: 48dp+ minimum.
- Contrast: WCAG AA-level.
- Voice/Screen Reader: Android TalkBack / iOS VoiceOver support.

## 27. Medical Graphics & 28. Recommended Source

Use graphics to improve recognition (e.g., Lungs for Asthma). Use a consistent visual style.
Recommendation: Servier Medical Art (SMART) under CC BY 4.0. Provide attribution in Settings -> Credits. Ensure attribution text conforms to accessibility requirements.

## 29. Safety / Medical Disclaimer

Arka helps keep a record of symptoms; it does not diagnose diseases or replace medical advice.

## 30. Navigation

Minimal navigation (Log, Journal, More).

## 31. Onboarding Completion & 32. Returning User Experience

No tutorial carousel. Returning users bypass onboarding and go straight to today's Log.

## 33. Session-Based Logging & 34. Symptom Rotation

Prioritize recommended symptoms based on clinical relevance and time since last recorded.

## 35. Empty States & 36. Error Handling

Use plain language for errors and clear calls to action for empty states.

## 37. Delete Data

Settings should include a "Delete all Arka data" option requiring explicit confirmation.

## 38. Security

Use application-private storage. Do not expose sensitive data.

## 39. MVP Scope (Must Have)

- Complete onboarding, symptom logging, journal, ZIP export via native share sheets, local architecture, offline operation, cross-platform support.

## 40. Explicitly Out of Scope for MVP

No AI diagnosis, cloud sync, social features, complex dashboards, online accounts, etc.

## 41. Future Features

**DO NOT TOUCH FOR NOW (V2 Features):**

- **System Permissions Contextual Priming:** Localized screens explaining why Arka needs storage/mic permissions before triggering OS dialogues.
- **Audio Compression & Cleanup:** Implementation of high compression for local `.m4a` files and a manual "Clear old audio" option to manage device storage.
- **HTML Export Variant:** Auto-generating a `journal.html` file alongside the `.txt` log to allow doctors to view formatted, color-coded tables in a browser.
- **Extreme Font Scaling Tests:** Dedicated QA to ensure UI integrity at 150% to 200% OS font scaling.
- Trends, PDF Doctor Report, On-device transcription, App Lock.

## 42. Technical Architecture Recommendation

For cross-platform development (iOS & Android):

- **Framework:** Flutter or React Native.
- **Database:** SQLite / Isar / WatermelonDB for local persistence.
- **Storage:** Native file system APIs for voice records and ZIP generation.
- **Share:** Native ShareSheet (UIActivityViewController for iOS, Share intent for Android).

Avoid introducing a backend merely because it is conventional.

## 43. Agentic Development Requirements

The development agent (Antigravity) should implement Arka incrementally:
Phase 1 — App shell (Nav, theme, cross-platform setup)
Phase 2 — Onboarding
Phase 3 — Symptom engine
Phase 4 — Logging (Including "Mark as Recovered" UI at the top of the Log Screen)
Phase 5 — Journal
Phase 6 — Export (Cross-platform ShareSheet handling)
Phase 7 — Accessibility (TalkBack/VoiceOver, Hinglish fallbacks)
Phase 8 — QA (Test on both iOS & Android)

## 44. Acceptance Criteria

- Runs flawlessly on both Android and iOS devices.
- User can mark conditions as "Recovered" from the Log page.
- UI appropriately falls back to English/Hinglish for medical terminology to prioritize familiarity over strict clinical regional translation.
- Health data remains local; Export generates a ZIP and invokes native sharing properly.

## 48. Antigravity Implementation Instruction

Build Arka as a production-quality Cross-Platform application following this PRD. Prioritize the core logging experience. Do not introduce a backend. Ensure medical terms are natural (incorporating Hinglish). Test complete flows on both iOS and Android environments.

**iOS ZIP Sharing Handling:** Antigravity must strictly define the MIME type during the export process. Because iOS can occasionally be finicky when passing ZIP files directly to WhatsApp via the ShareSheet, explicitly set the correct MIME type (`application/zip`) so iOS does not treat the export as an unsupported file.
