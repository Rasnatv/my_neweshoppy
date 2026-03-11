// import 'package:flutter/material.dart';
//
// class DTextFormFieldTheme{
//   DTextFormFieldTheme._();
//   static InputDecorationTheme lightinputdecorationTheme=InputDecorationTheme(
//     errorMaxLines: 3,
//     prefixIconColor: Colors.grey,
//     suffixIconColor: Colors.grey,
//     labelStyle: const TextStyle().copyWith(fontSize: 14,color: Colors.grey),
//     hintStyle:  const TextStyle().copyWith(fontSize: 14,color: Colors.grey),
//     errorStyle:  const TextStyle().copyWith(fontStyle: FontStyle.normal),
//     floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withOpacity(0.5),),
//     border:OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(width: 1,color: Colors.grey)),
//     enabledBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(width: 1,color: Colors.grey)),
//     focusedBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(width: 1,color: Colors.black12)),
//     errorBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(width: 1,color: Colors.red)),
//     focusedErrorBorder:OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(width: 1,color: Colors.orange)),
//   );
// }
//
import 'package:flutter/material.dart';

class DInputDecoration {
  DInputDecoration._(); // prevent instantiation

  // ── Brand Colors ──────────────────────────────────────────────────────────
  static const Color _primary      = Color(0xFF009788);
  static const Color _labelColor   = Color(0xFF9E9E9E);
  static const Color _iconColor    = Color(0xFF757575);
  static const Color _fillColor    = Color(0xFFF8F9FA);
  static const Color _borderColor  = Color(0xFFE0E0E0);
  static const Color _errorColor   = Color(0xFFE57373);
  static const Color _errorText    = Color(0xFFD32F2F);
  static const Color _inputText    = Color(0xFF212121);

  // ── Text style for typed input (use on TextFormField.style) ──────────────
  static const TextStyle inputTextStyle = TextStyle(
    color: _inputText,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  // ── Core factory ─────────────────────────────────────────────────────────
  static InputDecoration of(
      String label,
      IconData icon, {
        String? hintText,
        Widget? suffixIcon,
        bool isRequired = false,
      }) {
    return InputDecoration(
      labelText: isRequired ? "$label *" : label,
      hintText: hintText,
      labelStyle: const TextStyle(
        color: _labelColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: _labelColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: const TextStyle(
        color: _primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, color: _iconColor, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _errorColor, width: 2),
      ),
      errorStyle: const TextStyle(
        color: _errorText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      ),
    );
  }

  // ── Convenience shorthands ────────────────────────────────────────────────

  /// For password fields — pass your show/hide suffix button
  static InputDecoration password({
    String label = "Password",
    Widget? suffixIcon,
  }) =>
      of(label, Icons.lock_outline, suffixIcon: suffixIcon);

  /// For search fields — adds a search icon and clear button
  static InputDecoration search({
    String hintText = "Search...",
    VoidCallback? onClear,
  }) =>
      of(
        "",
        Icons.search,
        hintText: hintText,
        suffixIcon: onClear != null
            ? IconButton(
          icon: const Icon(Icons.clear, size: 18, color: _iconColor),
          onPressed: onClear,
        )
            : null,
      );
}