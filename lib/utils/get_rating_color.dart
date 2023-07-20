import 'package:flutter/material.dart';

Color getRatingColor(double rating) {
  if (rating >= 65) {
    return Colors.green;
  } else if (rating >= 30) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}
