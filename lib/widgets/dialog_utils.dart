import 'package:flutter/material.dart';

class DialogUtils {
  /// Shows a confirmation dialog and returns the user's choice
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    Color? confirmTextColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmTextColor != null
                ? TextButton.styleFrom(foregroundColor: confirmTextColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a remove member confirmation dialog
  static Future<bool?> showRemoveMemberDialog({
    required BuildContext context,
    required String memberName,
  }) {
    return showConfirmationDialog(
      context: context,
      title: 'Remove Member',
      content: 'Remove $memberName from your account?',
      confirmText: 'Remove',
      confirmTextColor: Colors.red,
    );
  }

  /// Shows a leave account confirmation dialog
  static Future<bool?> showLeaveAccountDialog({
    required BuildContext context,
    required String ownerName,
  }) {
    return showConfirmationDialog(
      context: context,
      title: 'Leave Shared Account',
      content:
          'Are you sure you want to leave $ownerName\'s account? '
          'You will no longer have access to shared expenses.',
      confirmText: 'Leave',
      confirmTextColor: Colors.red,
    );
  }

  /// Shows a success SnackBar
  static void showSuccessSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }

  /// Shows an error SnackBar
  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
      ),
    );
  }

  /// Shows an info SnackBar
  static void showInfoSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: duration));
  }
}
