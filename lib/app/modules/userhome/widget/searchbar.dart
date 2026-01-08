import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../common/style/app_text_style.dart';
class buildSearchbar extends StatelessWidget {
  const buildSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: TextField(
            style:  AppTextStyle.rTextNunitoBlack16w400,
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.black),
              hintText: "Search products...",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,// <-- No border
              focusedBorder: InputBorder.none,   // <-- No border when typing
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }


}
