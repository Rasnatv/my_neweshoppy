// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../admin_home/view/admin_home.dart';
//
// class AdminLoginController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final isPasswordHidden = true.obs;
//
//   void togglePassword() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }
//
//   void loginAdmin() {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar("Error", "Please fill in all fields",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     // 🔹 You can replace this with Firebase or API check
//     if (email == "admin@eshopper.com" && password == "admin123") {
//       Get.snackbar("Success", "Welcome Admin",
//           snackPosition: SnackPosition.BOTTOM);
//       Get.offAll(() =>  AdminTabPanel());
//     } else {
//       Get.snackbar("Login Failed", "Invalid admin credentials",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
// }
