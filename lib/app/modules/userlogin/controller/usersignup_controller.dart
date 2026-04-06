//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../landingview/view/landing_screen.dart';
// import '../../userhome/controller/district _controller.dart';
//
// class UsersignupController extends GetxController {
//   final formKey = GlobalKey<FormState>();
//
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//
//   RxBool isLoading = false.obs;
//   RxBool isPasswordVisible = false.obs;
//
//   final box = GetStorage();
//
//   void togglePasswordVisibility() {
//     isPasswordVisible.toggle();
//   }
//
//   // ─── Styled Snackbar Helpers ──────────────────────────────────────────────
//
//   // void _showSuccessSnackbar(String message) {
//   //   Get.snackbar(
//   //     "",
//   //     "",
//   //     titleText: Row(
//   //       children: const [
//   //         Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
//   //         SizedBox(width: 8),
//   //         Text(
//   //           "Success",
//   //           style: TextStyle(
//   //             color: Colors.white,
//   //             fontWeight: FontWeight.w700,
//   //             fontSize: 15,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //     messageText: Text(
//   //       message,
//   //       style: const TextStyle(color: Colors.white70, fontSize: 13),
//   //     ),
//   //     backgroundColor: const Color(0xFF4DB6AC),
//   //     borderRadius: 14,
//   //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//   //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//   //     snackPosition: SnackPosition.TOP,
//   //     duration: const Duration(seconds: 3),
//   //     animationDuration: const Duration(milliseconds: 400),
//   //   );
//   // }
//   AppSnackbar.success("Merchant registered successfully!");
//
//   void _showErrorSnackbar(String message) {
//     Get.snackbar(
//       "",
//       "",
//       titleText: Row(
//         children: const [
//           Icon(Icons.error_rounded, color: Colors.white, size: 20),
//           SizedBox(width: 8),
//           Text(
//             "Error",
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
//       backgroundColor: const Color(0xFFD32F2F),
//       borderRadius: 14,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//       animationDuration: const Duration(milliseconds: 400),
//       boxShadows: [
//         BoxShadow(
//           color: const Color(0xFFD32F2F).withOpacity(0.4),
//           blurRadius: 12,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     );
//   }
//
//   // ─── Register ─────────────────────────────────────────────────────────────
//
//   Future<void> register() async {
//     if (!formKey.currentState!.validate()) return;
//
//     isLoading.value = true;
//
//     try {
//       final response = await http.post(
//         Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/user/signup",
//         ),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "full_name": nameController.text.trim(),
//           "email": emailController.text.trim(),
//           "password": passwordController.text.trim(),
//           "phone": phoneController.text.trim(),
//           "address": addressController.text.trim(),
//         }),
//       );
//
//       final decodedData = jsonDecode(response.body);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final token = decodedData["data"]["auth_token"];
//
//         await box.write("auth_token", token);
//         await box.write("is_logged_in", true);
//         await box.write("role", 1);
//         await box.write("user_data", decodedData["data"]);
//
//         if (Get.isRegistered<UserLocationController>()) {
//           Get.find<UserLocationController>().fetchLocations();
//         }
//
//         _showSuccessSnackbar("Welcome! Your account has been created.");
//
//         Get.offAll(() => LandingView());
//       } else {
//         _showErrorSnackbar(decodedData["message"] ?? "Signup failed. Please try again.");
//       }
//     } catch (e) {
//       _showErrorSnackbar("Something went wrong. Check your connection.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../landingview/view/landing_screen.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../userhome/controller/district _controller.dart';


class UsersignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/user/signup",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
          "address": addressController.text.trim(),
        }),
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = decodedData["data"]["auth_token"];

        await box.write("auth_token", token);
        await box.write("is_logged_in", true);
        await box.write("role", 1);
        await box.write("user_data", decodedData["data"]);

        if (Get.isRegistered<UserLocationController>()) {
          Get.find<UserLocationController>().fetchLocations();
        }

        AppSnackbar.success("Welcome! Your account has been created."); // 👈

        Get.offAll(() => LandingView());
      } else {
        AppSnackbar.error(decodedData["message"] ?? "Signup failed. Please try again."); // 👈
      }
    } catch (e) {
      AppSnackbar.error("Something went wrong. Check your connection."); // 👈
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}