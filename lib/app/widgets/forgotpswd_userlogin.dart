// import 'dart:ui';
// import 'package:eshoppy/app/modules/userlogin/view/user_signup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../merchantlogin/view/merchant_registration.dart';
// import '../../userlogin/widget/usersignin_form.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/products/shopnow.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.35),
//                   Colors.black.withOpacity(0.35),
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Welcome to eShoppy!",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     _glassContainer(
//                       child: UsersigninForm(),
//                       blur: 20,
//                       padding: const EdgeInsets.all(24),
//                     ),
//                     const SizedBox(height: 16),
//                     // Forgot Password Button
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () => _showForgotPasswordSheet(context),
//                         child: const Text(
//                           "Forgot Password?",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             decoration: TextDecoration.underline,
//                             decorationColor: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Don't have an account?",
//                           style:
//                           TextStyle(color: Colors.white70, fontSize: 14),
//                         ),
//                         TextButton(
//                           onPressed: () => _showSignupRoleSheet(context),
//                           child: const Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showForgotPasswordSheet(BuildContext context) {
//     final TextEditingController emailController = TextEditingController();
//     final RxBool isLoading = false.obs;
//     final RxBool emailSent = false.obs;
//
//     Get.bottomSheet(
//       ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.black26.withOpacity(0.6),
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(28)),
//             ),
//             child: Obx(() => emailSent.value
//                 ? _buildSuccessView()
//                 : _buildForgotPasswordForm(
//                 emailController, isLoading, emailSent)),
//           ),
//         ),
//       ),
//       isScrollControlled: true,
//       isDismissible: true,
//       enableDrag: true,
//     );
//   }
//
//   Widget _buildForgotPasswordForm(TextEditingController emailController,
//       RxBool isLoading, RxBool emailSent) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.lock_reset,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               "Forgot Password?",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           "No worries! Enter your email address and we'll send you a link to reset your password.",
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 14,
//             height: 1.5,
//           ),
//         ),
//         const SizedBox(height: 24),
//         _glassContainer(
//           blur: 15,
//           padding: const EdgeInsets.all(16),
//           child: TextField(
//             controller: emailController,
//             keyboardType: TextInputType.emailAddress,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: "Enter your email",
//               hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
//               prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         Obx(() => _glassButton(
//           title: isLoading.value ? "Sending..." : "Send Reset Link",
//           icon: isLoading.value ? Icons.hourglass_empty : Icons.send,
//           color: Colors.white,
//           onTap: isLoading.value
//               ? () {}
//               : () async {
//             if (emailController.text.trim().isEmpty) {
//               Get.snackbar(
//                 "Error",
//                 "Please enter your email address",
//                 backgroundColor: Colors.red.withOpacity(0.8),
//                 colorText: Colors.white,
//                 snackPosition: SnackPosition.BOTTOM,
//                 margin: const EdgeInsets.all(16),
//               );
//               return;
//             }
//
//             isLoading.value = true;
//             // Simulate API call
//             await Future.delayed(const Duration(seconds: 2));
//             isLoading.value = false;
//             emailSent.value = true;
//
//             // TODO: Implement actual password reset logic here
//             // Example: await authController.sendPasswordResetEmail(emailController.text);
//           },
//         )),
//         const SizedBox(height: 12),
//         Center(
//           child: TextButton(
//             onPressed: () => Get.back(),
//             child: const Text(
//               "Back to Login",
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSuccessView() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.green.withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.check_circle_outline,
//             color: Colors.greenAccent,
//             size: 60,
//           ),
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           "Email Sent!",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Text(
//             "We've sent a password reset link to your email. Please check your inbox and follow the instructions.",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//               height: 1.5,
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         _glassButton(
//           title: "Back to Login",
//           icon: Icons.arrow_back,
//           color: Colors.white,
//           onTap: () => Get.back(),
//         ),
//         const SizedBox(height: 12),
//         TextButton(
//           onPressed: () {
//             // TODO: Implement resend logic
//             Get.snackbar(
//               "Email Resent",
//               "Password reset link has been sent again",
//               backgroundColor: Colors.green.withOpacity(0.8),
//               colorText: Colors.white,
//               snackPosition: SnackPosition.BOTTOM,
//               margin: const EdgeInsets.all(16),
//             );
//           },
//           child: const Text(
//             "Didn't receive the email? Resend",
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 13,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showSignupRoleSheet(BuildContext context) {
//     Get.bottomSheet(
//       ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.black26.withOpacity(0.6),
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(28)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Choose Account Type",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 24),
//                 _glassButton(
//                   title: "User Sign Up",
//                   icon: Icons.person,
//                   color: Colors.white,
//                   onTap: () => Get.to(() => UserSignup()),
//                 ),
//                 const SizedBox(height: 16),
//                 _glassButton(
//                   title: "Merchant Sign Up",
//                   icon: Icons.storefront,
//                   color: Colors.orangeAccent,
//                   onTap: () => Get.to(() => MerchantRegisterScreen()),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }
//
//   Widget _glassContainer(
//       {required Widget child,
//         double blur = 10,
//         EdgeInsets padding = const EdgeInsets.all(16)}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(22),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//         child: Container(
//           padding: padding,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.18),
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(color: Colors.white.withOpacity(0.3)),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
//
//   Widget _glassButton(
//       {required String title,
//         required IconData icon,
//         required Color color,
//         required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//           child: Container(
//             height: 65,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, color: color),
//                 const SizedBox(width: 12),
//                 Text(title,
//                     style: TextStyle(
//                         color: color,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }