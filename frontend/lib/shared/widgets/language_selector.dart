import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/themes/colors.dart';
import '../../core/providers/locale_provider.dart';

/// Language selector widget for switching app language
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const Map<String, Locale> supportedLanguages = {
    'English': Locale('en', ''),
    'Español': Locale('es', ''),
    'Türkçe': Locale('tr', ''),
    'Français': Locale('fr', ''),
    'Deutsch': Locale('de', ''),
    'Português': Locale('pt', ''),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 4),
            Text(
              _getLanguageName(currentLocale),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (BuildContext context) {
        return supportedLanguages.entries.map((entry) {
          final isSelected = entry.value == currentLocale;
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: AppColors.primaryBlue,
                    size: 20,
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: 8),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (String language) {
        final locale = supportedLanguages[language];
        if (locale != null) {
          ref.read(localeProvider.notifier).setLocale(locale);
        }
      },
    );
  }

  String _getLanguageName(Locale locale) {
    return supportedLanguages.entries
        .firstWhere(
          (entry) => entry.value == locale,
          orElse: () => const MapEntry('English', Locale('en', '')),
        )
        .key;
  }
}
