import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khata/l10n/app_localizations.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onpressed;
  const SubmitButton({super.key, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onpressed,
        child: Text(
          loc.save,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontStyle: GoogleFonts.inter().fontStyle,
          ),
        ),
      ),
    );
  }
}
