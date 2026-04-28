
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {

  static void success(String message) {
    Get.snackbar(
      "", "",
      titleText: Row(
        children: const [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "Success",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
      backgroundColor: const Color(0xFF185657),
      borderRadius: 14,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  static void error(String message) {
    Get.snackbar(
      "", "",
      titleText: Row(
        children: const [
          Icon(Icons.cancel_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "Error",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
      backgroundColor: const Color(0xFFEF5350),
      borderRadius: 14,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  static void warning(String message) {
    Get.snackbar(
      "", "",
      titleText: Row(
        children: const [
          Icon(Icons.warning_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "Notice",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
      backgroundColor: const Color(0xFFFFA726),
      borderRadius: 14,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}