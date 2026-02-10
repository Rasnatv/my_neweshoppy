
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
class BackArrow extends StatelessWidget {
  const BackArrow ({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back),
        color: const Color(0xFF212121),
        style: IconButton.styleFrom(
            backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
          )));

  }
}
