import 'package:flutter/material.dart';

/// A reusable avatar widget that handles user photos with fallback to icons
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final double radius;
  final IconData fallbackIcon;

  const UserAvatar({
    super.key,
    this.photoUrl,
    this.name,
    this.radius = 20,
    this.fallbackIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
          ? NetworkImage(photoUrl!)
          : null,
      child: photoUrl == null || photoUrl!.isEmpty ? Icon(fallbackIcon) : null,
    );
  }
}
