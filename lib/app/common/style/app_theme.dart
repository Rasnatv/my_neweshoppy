
import 'package:eshoppy/app/common/style/themes/elevatedbutton_theme.dart';
import 'package:eshoppy/app/common/style/themes/textform_theme.dart';
import 'package:eshoppy/app/common/style/themes/texttheme.dart';
import 'package:flutter/material.dart';


import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
       textTheme:  DTextTheme.lightTheme,
      primaryColor: AppColors.black,
      primarySwatch: AppColors.kPrimarySwatch,
      elevatedButtonTheme:DElevatedButtonTheme.LightElevatedButtonTheme,
      // inputDecorationTheme:DTextFormFieldTheme.lightInputDecorationTheme,
      //outlinedButtonTheme: DOutlineButtonTheme.LightOutlineButtonTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(16, 76, 146, 1),
        onSurface: AppColors.kPrimary,
      ),

      scaffoldBackgroundColor: AppColors.kScaffoldBackground,
      useMaterial3: true,
      appBarTheme: AppBarTheme(backgroundColor: AppColors.kScaffoldBackground,foregroundColor: AppColors.black),
      dialogBackgroundColor: Colors.white);

}
