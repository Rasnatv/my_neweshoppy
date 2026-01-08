// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../common/style/app_colors.dart';
//
//
// class ChangePasswordPage extends StatelessWidget {
//   ChangePasswordPage({super.key});
//
//   final TextEditingController oldPasswordCtrl = TextEditingController();
//   final TextEditingController newPasswordCtrl = TextEditingController();
//   final TextEditingController confirmPasswordCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Change Password"),
//         backgroundColor: AppColors.kPrimary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             _passwordField(controller: oldPasswordCtrl, label: "Old Password"),
//             const SizedBox(height: 16),
//             _passwordField(controller: newPasswordCtrl, label: "New Password"),
//             const SizedBox(height: 16),
//             _passwordField(controller: confirmPasswordCtrl, label: "Confirm Password"),
//             const SizedBox(height: 30),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kPrimary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Validate password fields
//                   if (oldPasswordCtrl.text.isEmpty || newPasswordCtrl.text.isEmpty || confirmPasswordCtrl.text.isEmpty) {
//                     Get.snackbar("Error", "All fields are required", backgroundColor: Colors.redAccent, colorText: Colors.white);
//                     return;
//                   }
//
//                   if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
//                     Get.snackbar("Error", "New Password and Confirm Password do not match",
//                         backgroundColor: Colors.redAccent, colorText: Colors.white);
//                     return;
//                   }
//
//                   // Call API to change password here
//                   Get.back(); // Go back after success
//                   Get.snackbar("Success", "Password changed successfully",
//                       backgroundColor: Colors.green, colorText: Colors.white);
//                 },
//                 child: const Text(
//                   "Change Password",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Password TextField
//   Widget _passwordField({required TextEditingController controller, required String label}) {
//     return TextField(
//       controller: controller,
//       obscureText: true,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: const Icon(Icons.lock_outline),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController oldPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:  Text("Change Password",style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _lockIcon(),
            const SizedBox(height: 24),

            _passwordCard(),
            const SizedBox(height: 30),

            _changeButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- LOCK ICON ----------------
  Widget _lockIcon() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.kPrimary.withOpacity(0.15),
      child: const Icon(
        Icons.lock_reset,
        size: 50,
        color: AppColors.kPrimary,
      ),
    );
  }

  // ---------------- PASSWORD CARD ----------------
  Widget _passwordCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _title("Update Your Password"),
            const SizedBox(height: 20),

            _passwordField(
              controller: oldPasswordCtrl,
              label: "Old Password",
            ),
            const SizedBox(height: 16),

            _passwordField(
              controller: newPasswordCtrl,
              label: "New Password",
            ),
            const SizedBox(height: 16),

            _passwordField(
              controller: confirmPasswordCtrl,
              label: "Confirm Password",
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CHANGE BUTTON ----------------
  Widget _changeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        onPressed: () {
          if (oldPasswordCtrl.text.isEmpty ||
              newPasswordCtrl.text.isEmpty ||
              confirmPasswordCtrl.text.isEmpty) {
            Get.snackbar(
              "Error",
              "All fields are required",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            return;
          }

          if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
            Get.snackbar(
              "Error",
              "New Password and Confirm Password do not match",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            return;
          }

          // API call here
          Get.back();
          Get.snackbar(
            "Success",
            "Password changed successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        child: const Text(
          "Change Password",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------- TITLE ----------------
  Widget _title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ---------------- PASSWORD FIELD ----------------
  Widget _passwordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.kPrimary),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.kPrimary, width: 1.5),
        ),
      ),
    );
  }
}
