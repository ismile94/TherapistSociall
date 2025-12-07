import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/hcpc_professions.dart';
import '../../core/themes/colors.dart';

/// Dropdown widget for selecting HCPC professions
class ProfessionAutocomplete extends StatefulWidget {
  final String? value;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;

  const ProfessionAutocomplete({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<ProfessionAutocomplete> createState() => _ProfessionAutocompleteState();
}

class _ProfessionAutocompleteState extends State<ProfessionAutocomplete> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<String>(
      value: widget.value,
      decoration: InputDecoration(
        labelText: '${l10n.profession} *',
        hintText: l10n.selectYourProfession,
        prefixIcon: const Icon(Icons.work_outline),
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: HCPCProfessions.professions.map((String profession) {
        return DropdownMenuItem<String>(
          value: profession,
          child: Text(
            profession,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        widget.onChanged?.call(newValue);
        if (newValue != null && widget.nextFocusNode != null) {
          // Small delay to ensure dropdown closes before focusing next field
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              widget.nextFocusNode!.requestFocus();
            }
          });
        }
      },
      validator: widget.validator,
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: AppColors.textSecondary,
      ),
      iconSize: 28,
      dropdownColor: AppColors.surface,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
      borderRadius: BorderRadius.circular(12),
      menuMaxHeight: 400,
    );
  }
}
