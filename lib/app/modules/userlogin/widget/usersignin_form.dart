//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/userlogin_controller.dart';
// import '../../../common/style/app_colors.dart';
//
// class UsersigninForm extends StatelessWidget {
//   UsersigninForm({super.key});
//
//   final controller = Get.put(UserloginController());
//   final _formKey = GlobalKey<FormState>();
//
//   InputDecoration _decoration({required String hint, required IconData icon}) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: Colors.white70),
//       prefixIcon: Icon(icon, color: Colors.white),
//       filled: true,
//       fillColor: Colors.white.withOpacity(0.12),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(
//           color: AppColors.kPrimary,
//           width: 1.5,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           // Email
//           SizedBox(
//             height: 58,
//             child: TextFormField(
//               controller: controller.username,
//               validator: (v) => v == null || v.isEmpty ? "Email required" : null,
//               textAlignVertical: TextAlignVertical.center,
//               style: const TextStyle(color: Colors.white),
//               decoration:
//               _decoration(hint: "Email", icon: Icons.email_outlined),
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Password
//           SizedBox(
//             height: 58,
//             child: TextFormField(
//               controller: controller.password,
//               obscureText: true,
//               validator: (v) =>
//               v == null || v.isEmpty ? "Password required" : null,
//               textAlignVertical: TextAlignVertical.center,
//               style: const TextStyle(color: Colors.white),
//               decoration:
//               _decoration(hint: "Password", icon: Icons.lock_outline),
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   controller.submit();
//                 }
//               },
//               child: const Text(
//                 "Login",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/userlogin_controller.dart';
import '../../../common/style/app_colors.dart';

class UsersigninForm extends StatelessWidget {
  UsersigninForm({super.key});

  final controller = Get.put(UserloginController());
  final _formKey = GlobalKey<FormState>();

  InputDecoration _decoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.kPrimary,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          SizedBox(
            height: 58,
            child: TextFormField(
              controller: controller.username,
              validator: (v) => v == null || v.isEmpty ? "Email required" : null,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white),
              decoration:
              _decoration(hint: "Email", icon: Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // Password
          SizedBox(
            height: 58,
            child: TextFormField(
              controller: controller.password,
              obscureText: true,
              validator: (v) =>
              v == null || v.isEmpty ? "Password required" : null,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white),
              decoration:
              _decoration(hint: "Password", icon: Icons.lock_outline),
            ),
          ),

          const SizedBox(height: 12),
      Obx(() {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: controller.isLoading.value
                ? null
                : () {
              if (_formKey.currentState!.validate()) {
                controller.submit();
              }
            },
            child: controller.isLoading.value
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              "Login",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      })



      ],
      ),
    );
  }
}


