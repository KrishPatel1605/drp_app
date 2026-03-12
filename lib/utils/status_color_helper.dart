import 'package:flutter/material.dart';

class StatusColorHelper {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'planning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}