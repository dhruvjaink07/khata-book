import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khata/l10n/app_localizations.dart';

class DataManagementCard extends StatelessWidget {
  final bool autoBackup;
  final ValueChanged<bool> onAutoBackupChanged;

  const DataManagementCard({
    super.key,
    required this.autoBackup,
    required this.onAutoBackupChanged,
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
              CupertinoIcons.cloud_upload,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            title: Text(loc.autoBackup),
            value: true,
            onChanged: onAutoBackupChanged,
          ),
          Divider(height: 1),
          ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Under Development : Backup Frequency')),
              );
            },
            leading: Icon(
              CupertinoIcons.time,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            title: Text(loc.backupFrequency),
            trailing: Text(
              'Daily',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
