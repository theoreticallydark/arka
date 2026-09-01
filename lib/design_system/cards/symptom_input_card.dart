import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../icons/medical_graphic_icon.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

enum MeasurementType {
  scale,
  yesNo,
  numeric,
  duration,
  text,
}

/// Dynamic input card for logging a symptom based on its measurement type.
class SymptomInputCard extends StatefulWidget {
  final String symptomName;
  final String? symptomDescription;
  final IconData icon;
  final String? assetKey;
  final MeasurementType measurementType;
  final String? unit;
  final Function(dynamic value, String? noteText, String? voiceFilePath) onSave;
  final VoidCallback onCancel;
  final VoidCallback onRecordVoice;
  final String? currentVoiceFilePath;
  final VoidCallback? onClearVoice;

  const SymptomInputCard({
    super.key,
    required this.symptomName,
    this.symptomDescription,
    required this.icon,
    this.assetKey,
    required this.measurementType,
    this.unit,
    required this.onSave,
    required this.onCancel,
    required this.onRecordVoice,
    this.currentVoiceFilePath,
    this.onClearVoice,
  });

  @override
  State<SymptomInputCard> createState() => _SymptomInputCardState();
}

class _SymptomInputCardState extends State<SymptomInputCard> {
  // Input values
  double _scaleValue = 5.0;
  bool? _yesNoValue;
  final TextEditingController _numericController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _showNotes = false;

  @override
  void initState() {
    super.initState();
    if (widget.measurementType == MeasurementType.numeric) {
      _numericController.text = '100';
    }
  }

  @override
  void dispose() {
    _numericController.dispose();
    _textController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleSave() {
    dynamic finalValue;
    switch (widget.measurementType) {
      case MeasurementType.scale:
        finalValue = _scaleValue.round();
        break;
      case MeasurementType.yesNo:
        finalValue = _yesNoValue ?? false;
        break;
      case MeasurementType.numeric:
        finalValue = double.tryParse(_numericController.text) ?? 0.0;
        break;
      case MeasurementType.duration:
      case MeasurementType.text:
        finalValue = _textController.text.trim();
        break;
    }

    final noteText = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
    widget.onSave(finalValue, noteText, widget.currentVoiceFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              MedicalGraphicIcon(
                assetKey: widget.assetKey,
                fallbackIcon: widget.icon,
                size: 32,
                iconColor: AppColors.primary,
                backgroundColor: AppColors.primaryLight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.symptomName,
                      style: AppTypography.titleLarge,
                    ),
                    if (widget.symptomDescription != null &&
                        widget.symptomDescription!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.symptomDescription!,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Measurement Input Selector
          _buildInputControl(),

          const SizedBox(height: 20),

          // Voice note indicator / button
          Row(
            children: [
              Expanded(
                child: widget.currentVoiceFilePath != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.mic, color: AppColors.success, size: 20),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Voice note attached',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                            if (widget.onClearVoice != null)
                              GestureDetector(
                                onTap: widget.onClearVoice,
                                child: const Icon(Icons.close, color: AppColors.danger, size: 20),
                              ),
                          ],
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: widget.onRecordVoice,
                        icon: const Icon(Icons.mic, size: 22, color: AppColors.primary),
                        label: const Text('Speak / Record Voice'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              IconButton.outlined(
                tooltip: 'Add note',
                icon: Icon(
                  _showNotes ? Icons.notes : Icons.edit_note,
                  color: _showNotes ? AppColors.primary : AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _showNotes = !_showNotes;
                  });
                },
              ),
            ],
          ),

          // Optional text notes field
          if (_showNotes) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 2,
              style: AppTypography.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Type any additional notes here...',
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SecondaryButton(
                  label: 'Cancel',
                  onPressed: widget.onCancel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Save Log',
                  icon: Icons.check,
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputControl() {
    switch (widget.measurementType) {
      case MeasurementType.scale:
        return _buildScaleControl();
      case MeasurementType.yesNo:
        return _buildYesNoControl();
      case MeasurementType.numeric:
        return _buildNumericControl();
      case MeasurementType.duration:
      case MeasurementType.text:
        return _buildTextControl();
    }
  }

  Widget _buildScaleControl() {
    String anchorText = 'Moderate (5/10)';
    Color anchorColor = AppColors.warning;
    final val = _scaleValue.round();
    if (val <= 3) {
      anchorText = 'Mild ($val/10)';
      anchorColor = AppColors.success;
    } else if (val <= 7) {
      anchorText = 'Moderate ($val/10)';
      anchorColor = AppColors.warning;
    } else {
      anchorText = 'Severe ($val/10)';
      anchorColor = AppColors.danger;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: anchorColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            anchorText,
            style: AppTypography.titleMedium.copyWith(
              color: anchorColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: anchorColor,
            inactiveTrackColor: AppColors.chipBackground,
            thumbColor: anchorColor,
            overlayColor: anchorColor.withValues(alpha: 0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
            trackHeight: 8,
          ),
          child: Slider(
            value: _scaleValue,
            min: 1,
            max: 10,
            divisions: 9,
            label: '${_scaleValue.round()}',
            onChanged: (value) {
              setState(() {
                _scaleValue = value;
              });
            },
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 (Mild)', style: AppTypography.bodySmall),
            Text('5 (Moderate)', style: AppTypography.bodySmall),
            Text('10 (Severe)', style: AppTypography.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildYesNoControl() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _yesNoValue = true),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: _yesNoValue == true ? AppColors.primaryLight : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _yesNoValue == true ? AppColors.primary : AppColors.border,
                  width: _yesNoValue == true ? 2.5 : 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Yes (हाँ / हो)',
                style: AppTypography.titleMedium.copyWith(
                  color: _yesNoValue == true ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _yesNoValue = false),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: _yesNoValue == false ? AppColors.primaryLight : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _yesNoValue == false ? AppColors.primary : AppColors.border,
                  width: _yesNoValue == false ? 2.5 : 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'No (नहीं / नाही)',
                style: AppTypography.titleMedium.copyWith(
                  color: _yesNoValue == false ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericControl() {
    return Row(
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.remove, size: 28),
          style: IconButton.styleFrom(
            minimumSize: const Size(56, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {
            final current = double.tryParse(_numericController.text) ?? 100.0;
            final updated = (current - 1).clamp(0, 1000);
            setState(() {
              _numericController.text = updated % 1 == 0 ? updated.toInt().toString() : updated.toStringAsFixed(1);
            });
          },
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _numericController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(color: AppColors.primary),
            decoration: InputDecoration(
              suffixText: widget.unit ?? '',
              suffixStyle: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton.filledTonal(
          icon: const Icon(Icons.add, size: 28),
          style: IconButton.styleFrom(
            minimumSize: const Size(56, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {
            final current = double.tryParse(_numericController.text) ?? 100.0;
            final updated = (current + 1).clamp(0, 1000);
            setState(() {
              _numericController.text = updated % 1 == 0 ? updated.toInt().toString() : updated.toStringAsFixed(1);
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextControl() {
    return TextField(
      controller: _textController,
      maxLines: 2,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: 'e.g. 30 minutes / mild soreness',
        suffixText: widget.unit,
      ),
    );
  }
}
