import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String transaction;
  final String time;
  final String amount;
  final bool isDebit;

  const TransactionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.transaction,
    required this.time,
    required this.amount,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Format time using locale
    String formattedTime;
    try {
      final dt = DateTime.parse(
        time.split(' ').first + 'T' + time.split(' ').last,
      );
      formattedTime = DateFormat(
        'hh:mm a',
        Localizations.localeOf(context).toString(),
      ).format(dt);
    } catch (_) {
      formattedTime = time;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconBgColor,
                radius: 24,
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction,
                    style: TextStyle(
                      fontStyle: GoogleFonts.inter().fontStyle,
                      fontSize: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                      fontStyle: GoogleFonts.inter().fontStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              color: isDebit ? Colors.red : Colors.green,
              fontStyle: GoogleFonts.inter().fontStyle,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
