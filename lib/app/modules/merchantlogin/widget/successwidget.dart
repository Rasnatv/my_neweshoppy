//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AppSnackbar {
//
//   static void success(String message) {
//     Get.snackbar(
//       "", "",
//       titleText: Row(
//         children: const [
//           Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
//           SizedBox(width: 8),
//           Text(
//             "Success",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//       messageText: Text(
//         message,
//         style: const TextStyle(color: Colors.white70, fontSize: 13),
//       ),
//       backgroundColor: const Color(0xFF185657),
//       borderRadius: 14,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//       animationDuration: const Duration(milliseconds: 400),
//     );
//   }
//
//   static void error(String message) {
//     Get.snackbar(
//       "", "",
//       messageText: Text(
//         message,
//         style: const TextStyle(color: Colors.white70, fontSize: 13),
//       ),
//       backgroundColor: const Color(0xFF185657),
//       borderRadius: 14,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//       animationDuration: const Duration(milliseconds: 400),
//     );
//   }
//
//   static void warning(String message) {
//     Get.snackbar(
//       "", "",
//       titleText: Row(
//         children: const [
//           Icon(Icons.warning_rounded, color: Colors.white, size: 20),
//           SizedBox(width: 8),
//           Text(
//             "Notice",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//       messageText: Text(
//         message,
//         style: const TextStyle(color: Colors.white70, fontSize: 13),
//       ),
//       backgroundColor: const Color(0xFFFFA726),
//       borderRadius: 14,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//       animationDuration: const Duration(milliseconds: 400),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success(String message) {
    if (message.isEmpty) return;

    Get.snackbar(
      "", "",
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF00897B),
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF00897B).withOpacity(0.4),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      shouldIconPulse: false,
    );
  }

  static void error(String message) {
    if (message.isEmpty) return;

    Get.snackbar(
      "", "",
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor:Colors.orange.shade700,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      boxShadows: [
        BoxShadow(
          color:Colors.orange.shade700.withOpacity(0.4),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      shouldIconPulse: false,
    );
  }

  static void warning(String message) {
    if (message.isEmpty) return;

    Get.snackbar(
      "", "",
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF57C00),
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFFF57C00).withOpacity(0.4),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      shouldIconPulse: false,
    );
  }
}