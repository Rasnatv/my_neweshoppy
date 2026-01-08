import 'package:flutter/material.dart';

class DTextFormFieldTheme{
  DTextFormFieldTheme._();
  static InputDecorationTheme lightinputdecorationTheme=InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14,color: Colors.grey),
    hintStyle:  const TextStyle().copyWith(fontSize: 14,color: Colors.grey),
    errorStyle:  const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withOpacity(0.5),),
    border:OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1,color: Colors.grey)),
    enabledBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1,color: Colors.grey)),
    focusedBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1,color: Colors.black12)),
    errorBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1,color: Colors.red)),
    focusedErrorBorder:OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1,color: Colors.orange)),
  );
}