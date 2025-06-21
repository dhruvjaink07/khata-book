import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khata/l10n/app_localizations.dart';

class AppearanceCard extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool largeText;
  final ValueChanged<bool> onLargeTextChanged;

  const AppearanceCard({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
    required this.largeText,
    required this.onLargeTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              CupertinoIcons.moon,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            title: Text(loc.darkMode),
            value: darkMode,
            onChanged: onThemeChanged,
          ),
          Divider(height: 1),
          SwitchListTile(
            secondary: Icon(
              Icons.format_size,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            title: Text(loc.largeTextMode),
            value: largeText,
            onChanged: onLargeTextChanged,
          ),
        ],
      ),
    );
  }
}
