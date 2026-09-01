import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/symptom.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../design_system/cards/selection_card.dart';

class ManageSymptomsScreen extends StatefulWidget {
  final String userId;

  const ManageSymptomsScreen({super.key, required this.userId});

  @override
  State<ManageSymptomsScreen> createState() => _ManageSymptomsScreenState();
}

class _ManageSymptomsScreenState extends State<ManageSymptomsScreen> {
  final SymptomRepository _symptomRepo = SymptomRepository();

  List<Symptom> _allSymptoms = [];
  final Set<String> _trackedSymptomIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    final all = await _symptomRepo.getAllSymptoms();
    final userTracked = await _symptomRepo.getUserTrackedSymptoms(widget.userId);

    if (mounted) {
      setState(() {
        _allSymptoms = all;
        _trackedSymptomIds.clear();
        _trackedSymptomIds.addAll(userTracked.map((s) => s.id));
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSymptom(String symptomId) async {
    final willEnable = !_trackedSymptomIds.contains(symptomId);
    setState(() {
      if (willEnable) {
        _trackedSymptomIds.add(symptomId);
      } else {
        _trackedSymptomIds.remove(symptomId);
      }
    });

    await _symptomRepo.toggleUserSymptom(widget.userId, symptomId, willEnable);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings.manage_symptoms')),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: _allSymptoms.map((sym) {
            final isSelected = _trackedSymptomIds.contains(sym.id);
            return SelectionCard(
              title: sym.defaultName,
              subtitle: sym.defaultDescription,
              icon: sym.materialIcon,
              assetKey: sym.assetKey,
              isSelected: isSelected,
              onTap: () => _toggleSymptom(sym.id),
            );
          }).toList(),
        ),
      ),
    );
  }
}
