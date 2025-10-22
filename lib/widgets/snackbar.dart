import 'package:flutter/material.dart';

enum SnackType { success, error, info }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  required SnackType type,
}) {
  final overlay = Overlay.of(context);

  switch (type) {
    case SnackType.success:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            message,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
      break;

    case SnackType.error:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
      break;

    case SnackType.info:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.yellow,
          content: Text(
            message,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
      break;
  }
}
