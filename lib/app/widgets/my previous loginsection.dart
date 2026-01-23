//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/userlogin_controller.dart';
// import '../../../common/style/app_colors.dart';
//
// class UsersigninForm extends StatelessWidget {
//   UsersigninForm({super.key});
//   final UserloginController controller = Get.find<UserloginController>();
//
//   // final controller = Get.put(UserloginController());
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
// import 'dart:ui';
// import 'package:eshoppy/app/modules/forgotpassowrd/view/forgotpassword.dart';
// import 'package:eshoppy/app/modules/userlogin/view/user_signup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../merchantlogin/view/merchant_registration.dart';
// import '../../userlogin/widget/usersignin_form.dart';
//
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
//                     const SizedBox(height: 22),
//                 Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () => Get.to(ForgotPasswordEmailView()),
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
//                     const SizedBox(height: 5),
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

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../admin_home/view/admin_home.dart';
// import '../../landingview/view/landing_screen.dart';
// import '../../merchant_home/views/merchant_home.dart';
// import '../../userhome/view/userhome.dart';
//
// class UserloginController extends GetxController {
//   final TextEditingController username = TextEditingController();
//   final TextEditingController password = TextEditingController();
//
//   final RxBool isLoading = false.obs;
//   final GetStorage box = GetStorage();
//
//   final String loginUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/login";
//
//   @override
//   void onClose() {
//     username.dispose();
//     password.dispose();
//     super.onClose();
//   }
//
//   Future<void> submit() async {
//     final String email = username.text.trim();
//     final String pass = password.text.trim();
//
//     if (email.isEmpty || pass.isEmpty) {
//       _error("Email and password required");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       for (int role in [1, 2, 3]) {
//         final bool success = await _loginWithRole(
//           email: email,
//           password: pass,
//           role: role,
//         );
//
//         if (success) return;
//       }
//
//       _error("Invalid email or password");
//     } catch (e) {
//       _error("Something went wrong");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> _loginWithRole({
//     required String email,
//     required String password,
//     required int role,
//   }) async {
//     final response = await http.post(
//       Uri.parse(loginUrl),
//       headers: {
//         "Accept": "application/json",
//       },
//       body: {
//         "email": email,
//         "password": password,
//         "role": role.toString(),
//       },
//     );
//
//     final Map<String, dynamic> body = jsonDecode(response.body);
//
//     final status = body['status'];
//     final bool isSuccess =
//         status == true || status == 1 || status == "1";
//
//     if (!isSuccess) return false;
//
//     final data = body['data'];
//
//     // Store auth data
//     box.write("auth_token", data['auth_token']);
//     box.write("role", data['role']);
//     box.write("user_data", data);
//
//     // Navigate based on role
//     if (data['role'] == 1) {
//       Get.offAll(() => LandingView());
//     } else if (data['role'] == 2) {
//       Get.offAll(() => MerchantDashboardPage());
//     } else {
//       Get.offAll(() => AdminDashboard());
//     }
//
//     Get.snackbar(
//       "Success",
//       body['message'] ?? "Login successful",
//     );
//
//     return true;
//   }
//
//   void _error(String msg) {
//     Get.snackbar(
//       "Login Failed",
//       msg,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }