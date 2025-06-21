import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khata/l10n/app_localizations.dart';
import '../service/settings_service.dart';

class LanguageCard extends StatelessWidget {
  final Locale selectedLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final SettingsService service;

  const LanguageCard({
    super.key,
    required this.selectedLocale,
    required this.onLocaleChanged,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(
          CupertinoIcons.globe,
          color: colorScheme.onSurface.withOpacity(0.7),
          size: 26,
        ),
        title: Text(loc.language),
        trailing: DropdownButton<Locale>(
          value: selectedLocale,
          underline: SizedBox(),
          items: service.buildLocaleDropdownItems(selectedLocale),
          onChanged: (locale) {
            if (locale != null) service.changeLanguage(locale, onLocaleChanged);
          },
        ),
      ),
    );
  }
}
