import 'package:flutter/services.dart';

class PriceInputFormatterzz extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final regex = RegExp(r'^\d*\.?\d{0,2}$');
    if (!regex.hasMatch(text)) return oldValue;
    final parts = text.split('.');
    if (parts[0].length > 8) return oldValue;
    return newValue;
  }
}