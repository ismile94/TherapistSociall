import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/mapbox_geocoding_service.dart';
import '../../core/themes/colors.dart';

/// Autocomplete widget for selecting cities using Mapbox Geocoding
class CityAutocomplete extends StatefulWidget {
  final String? value;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;

  const CityAutocomplete({
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
  State<CityAutocomplete> createState() => _CityAutocompleteState();
}

class _CityAutocompleteState extends State<CityAutocomplete> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  List<String> _options = [];
  String _currentQuery = '';
  String? _selectedCity; // Only valid if selected from Mapbox options
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _textController.text = widget.value!;
      _selectedCity = widget.value; // Assume initial value is valid
    }
    final effectiveFocusNode = widget.focusNode ?? _focusNode;
    effectiveFocusNode.addListener(_onFocusChange);
    _textController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(CityAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value &&
        widget.value != _textController.text) {
      _textController.text = widget.value ?? '';
      _selectedCity =
          widget.value; // Update selected city if value changed externally
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    final effectiveFocusNode = widget.focusNode ?? _focusNode;
    effectiveFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _textController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    final effectiveFocusNode = widget.focusNode ?? _focusNode;
    if (!effectiveFocusNode.hasFocus) {
      _removeOverlay();
      // If user didn't select from list, clear the field or restore selected value
      if (_selectedCity != null && _textController.text != _selectedCity) {
        _textController.text = _selectedCity!;
        widget.onChanged?.call(_selectedCity);
      } else if (_selectedCity == null && _textController.text.isNotEmpty) {
        // User typed something but didn't select from list - clear it
        _textController.clear();
        widget.onChanged?.call(null);
      }
    }
  }

  void _onTextChanged() {
    final query = _textController.text;
    // If user is typing and it doesn't match the selected city, clear selection
    if (_selectedCity != null && query != _selectedCity) {
      setState(() {
        _selectedCity = null; // Clear selection when user types
      });
    }
    _searchPlaces(query);
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty || query.length < 2) {
      setState(() {
        _options = [];
        _isLoading = false;
      });
      _removeOverlay();
      return;
    }

    if (query == _currentQuery && _options.isNotEmpty) {
      return; // Already have results for this query
    }

    setState(() {
      _currentQuery = query;
      _isLoading = true;
    });

    try {
      final results = await MapboxGeocodingService.searchPlaces(query);

      if (mounted && query == _currentQuery) {
        setState(() {
          _options = results;
          _isLoading = false;
        });
        _showOverlay();
      }
    } catch (e) {
      if (mounted && query == _currentQuery) {
        setState(() {
          _options = [];
          _isLoading = false;
        });
        _removeOverlay();
      }
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final effectiveFocusNode = widget.focusNode ?? _focusNode;
    if (_options.isEmpty || !effectiveFocusNode.hasFocus) return;

    final overlay = Overlay.of(context);
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final option = _options[index];
                final isSelected = option == widget.value;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCity = option; // Mark as selected from Mapbox
                    });
                    _textController.text = option;
                    widget.onChanged?.call(option);
                    _removeOverlay();
                    final effectiveFocusNode = widget.focusNode ?? _focusNode;
                    effectiveFocusNode.unfocus();
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode!.requestFocus();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.divider.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveFocusNode = widget.focusNode ?? _focusNode;

    return RawAutocomplete<String>(
      textEditingController: _textController,
      focusNode: effectiveFocusNode,
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _options;
      },
      displayStringForOption: (String option) => option,
      onSelected: (String selection) {
        setState(() {
          _selectedCity = selection; // Mark as selected from Mapbox
        });
        _textController.text = selection;
        widget.onChanged?.call(selection);
        _removeOverlay();
        if (widget.nextFocusNode != null) {
          widget.nextFocusNode!.requestFocus();
        }
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          key: _fieldKey,
          controller: textEditingController,
          focusNode: effectiveFocusNode,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          decoration: InputDecoration(
            labelText: '${AppLocalizations.of(context)?.city ?? 'City'} *',
            hintText: AppLocalizations.of(context)?.startTypingYourCity ??
                'Start typing your city...',
            prefixIcon: const Icon(Icons.location_city_outlined),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryBlue),
                      ),
                    ),
                  )
                : textEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedCity = null; // Clear selection
                          });
                          textEditingController.clear();
                          widget.onChanged?.call(null);
                          _removeOverlay();
                        },
                      )
                    : null,
            filled: true,
            fillColor: AppColors.backgroundLight,
          ),
          validator: (String? value) {
            final l10n = AppLocalizations.of(context);
            // First check if value is selected from Mapbox options
            if (_selectedCity == null || _selectedCity!.isEmpty) {
              return l10n?.pleaseSelectACityFromTheSuggestions ??
                  'Please select a city from the suggestions';
            }
            if (value != _selectedCity) {
              return l10n?.pleaseSelectACityFromTheSuggestions ??
                  'Please select a city from the suggestions';
            }
            // Then run custom validator if provided
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
          onFieldSubmitted: (String value) {
            if (widget.nextFocusNode != null) {
              widget.nextFocusNode!.requestFocus();
            } else if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!();
            } else {
              onFieldSubmitted();
            }
          },
          onChanged: (value) {
            widget.onChanged?.call(value.isEmpty ? null : value);
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        // This won't be used since we're using overlay
        return const SizedBox.shrink();
      },
    );
  }
}
