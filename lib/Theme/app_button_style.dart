import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static final ButtonStyle linkButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(
      const Color(0xFF01B4E4),
    ),
    textStyle: MaterialStateProperty.all(
      // ignore: prefer_const_constructors
      TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
