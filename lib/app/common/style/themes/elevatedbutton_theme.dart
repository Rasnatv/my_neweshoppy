// import 'package:flutter/material.dart';
// import '../app_colors.dart';
//
// class DElevatedButtonTheme{
//   DElevatedButtonTheme._();
//   static final LightElevatedButtonTheme=ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//           elevation: 0,
//           foregroundColor: Colors.white,
//           backgroundColor:AppColors.kPrimary,
//           disabledBackgroundColor: Colors.grey,
//           disabledForegroundColor: Colors.grey,
//           side: const BorderSide(color: AppColors.kPrimary),
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           textStyle: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
//       )
//   );
// }
import 'package:flutter/material.dart';
import '../app_colors.dart';

class DElevatedButtonTheme {
  DElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: AppColors.kPrimary,
      disabledBackgroundColor: Colors.grey.shade400,
      disabledForegroundColor: Colors.white70,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}