import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khata/l10n/app_localizations.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceVariant
            : colorScheme.surface, // background for search bar area
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 16, color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: loc.searchTransactions,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              onPressed: () {
                // Add filter logic here
              },
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
