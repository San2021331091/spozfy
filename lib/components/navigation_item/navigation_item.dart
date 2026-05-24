import 'package:flutter/material.dart';

Widget item({
  required IconData icon,
  required String title,
  VoidCallback? ontap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Material(
      color: const Color(0xFF111A2E),
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_sharp,
          size: 14,
          color: Colors.white24,
        ),
        onTap: ontap,
      ),
    ),
  );
}