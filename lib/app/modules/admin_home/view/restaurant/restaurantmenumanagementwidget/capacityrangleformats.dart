import 'package:flutter/services.dart';

class CapacityRangeFormatterzz extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const prefix = '1-';
    if (!newValue.text.startsWith(prefix)) {
      return TextEditingValue(
        text: oldValue.text.startsWith(prefix) ? oldValue.text : prefix,
        selection: TextSelection.collapsed(
          offset: oldValue.text.startsWith(prefix)
              ? oldValue.text.length
              : prefix.length,
        ),
      );
    }
    final afterPrefix = newValue.text.substring(prefix.length);
    if (afterPrefix.isNotEmpty &&
        !RegExp(r'^\d{1,3}$').hasMatch(afterPrefix)) {
      return oldValue;
    }
    return newValue;
  }
}