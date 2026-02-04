// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../merchantlogin/view/merchant_registration.dart';
// // import '../../userlogin/view/user_signup.dart';
// // import '../../userlogin/widget/usersignin_form.dart';
// // import '../../forgotpassowrd/view/forgotpassword.dart';
// // import '../controller/userlogin_controller.dart';
// //
// // class LoginScreen extends StatelessWidget {
// //   const LoginScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F7FA),
// //       body: SafeArea(
// //         child: Center(
// //           child: SingleChildScrollView(
// //             physics: const BouncingScrollPhysics(),
// //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 _buildBrandSection(),
// //                 const SizedBox(height: 40),
// //                 _buildRoleSelector(),
// //                 const SizedBox(height: 24),
// //                 _buildLoginCard(),
// //                 const SizedBox(height: 16),
// //                 _buildForgotPassword(),
// //                 const SizedBox(height: 24),
// //                 _buildSignUpSection(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBrandSection() {
// //     return Column(
// //       children: [
// //         Container(
// //           width: 90,
// //           height: 90,
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(
// //               colors: [
// //                 Color(0xFF009788),
// //                 Color(0xFF32CCB6),
// //               ],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //             borderRadius: BorderRadius.circular(24),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: const Color(0xFF6366F1).withOpacity(0.3),
// //                 blurRadius: 20,
// //                 offset: const Offset(0, 10),
// //               ),
// //             ],
// //           ),
// //           child: const Icon(
// //             Icons.shopping_bag_rounded,
// //             color: Colors.white,
// //             size: 45,
// //           ),
// //         ),
// //         const SizedBox(height: 24),
// //         const Text(
// //           "eShoppy",
// //           style: TextStyle(
// //             fontSize: 36,
// //             fontWeight: FontWeight.w800,
// //             color: Color(0xFF1F2937),
// //             letterSpacing: -1,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           "Sign in to continue shopping",
// //           style: TextStyle(
// //             fontSize: 15,
// //             color: const Color(0xFF6B7280),
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildRoleSelector() {
// //     final controller = Get.find<UserloginController>();
// //
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       padding: const EdgeInsets.all(20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             "Account Type",
// //             style: TextStyle(
// //               fontSize: 14,
// //               fontWeight: FontWeight.w600,
// //               color: Color(0xFF6B7280),
// //               letterSpacing: 0.3,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Obx(() {
// //             return Row(
// //               children: controller.roles.entries.map((entry) {
// //                 final role = entry.value;
// //                 final isSelected = controller.selectedRole.value == role.id;
// //
// //                 return Expanded(
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(right: 12),
// //
// //                     child: _buildRoleChip(
// //                       role: role,
// //                       isSelected: isSelected,
// //                       onTap: () => controller.setRole(role.id),
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             );
// //           }),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRoleChip({
// //     required dynamic role,
// //     required bool isSelected,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
// //         decoration: BoxDecoration(
// //           gradient: isSelected
// //               ? const LinearGradient(
// //             colors: [
// //               Color(0xFF009788),
// //               Color(0xFF02715E),
// //             ],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           )
// //               : null,
// //           color: isSelected ? null : const Color(0xFFF9FAFB),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: isSelected
// //                 ? Colors.transparent
// //                 : const Color(0xFFE5E7EB),
// //             width: 1.5,
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             Icon(
// //               role.icon,
// //               color: isSelected ? Colors.white : const Color(0xFF6B7280),
// //               size: 28,
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               role.name,
// //               style: TextStyle(
// //                 color: isSelected ? Colors.white : const Color(0xFF374151),
// //                 fontSize: 13,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// //
// //   Widget _buildLoginCard() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.08),
// //             blurRadius: 20,
// //             offset: const Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       padding: const EdgeInsets.all(28),
// //       child: UsersigninForm(),
// //     );
// //   }
// //
// //   Widget _buildForgotPassword() {
// //     return Align(
// //       alignment: Alignment.centerRight,
// //       child: TextButton(
// //         onPressed: () => Get.to(() => ForgotPasswordEmailView()),
// //         style: TextButton.styleFrom(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //         ),
// //         child: const Text(
// //           "Forgot Password?",
// //           style: TextStyle(
// //             color: Color(0xFF6366F1),
// //             fontSize: 14,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSignUpSection() {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: const Color(0xFFE5E7EB),
// //           width: 1,
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Text(
// //             "Don't have an account?",
// //             style: TextStyle(
// //               color: Color(0xFF6B7280),
// //               fontSize: 14,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           GestureDetector(
// //             onTap: () => _showSignupBottomSheet(Get.context!),
// //             child: const Text(
// //               "Sign Up",
// //               style: TextStyle(
// //                 color: Color(0xFF6366F1),
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.w700,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _showSignupBottomSheet(BuildContext context) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //       ),
// //       builder: (context) => Container(
// //         decoration: const BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //         ),
// //         padding: EdgeInsets.fromLTRB(
// //           24,
// //           20,
// //           24,
// //           MediaQuery.of(context).viewInsets.bottom + 24,
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Container(
// //               width: 40,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFE5E7EB),
// //                 borderRadius: BorderRadius.circular(2),
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               "Create Account",
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.w700,
// //                 color: Color(0xFF1F2937),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             const Text(
// //               "Choose your account type",
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Color(0xFF6B7280),
// //               ),
// //             ),
// //             const SizedBox(height: 28),
// //             _buildSignupOption(
// //               title: "User Account",
// //               subtitle: "Shop and discover products",
// //               icon: Icons.person_outline_rounded,
// //               gradient: const LinearGradient(
// //                 colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
// //               ),
// //               onTap: () {
// //                 Get.back();
// //                 Get.to(() => UserSignup());
// //               },
// //             ),
// //             const SizedBox(height: 16),
// //             _buildSignupOption(
// //               title: "Merchant Account",
// //               subtitle: "Sell and manage inventory",
// //               icon: Icons.storefront_outlined,
// //               gradient: const LinearGradient(
// //                 colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
// //               ),
// //               onTap: () {
// //                 Get.back();
// //                 Get.to(() => MerchantRegisterScreen());
// //               },
// //             ),
// //             const SizedBox(height: 16),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSignupOption({
// //     required String title,
// //     required String subtitle,
// //     required IconData icon,
// //     required Gradient gradient,
// //     required VoidCallback onTap,
// //   }) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(16),
// //       child: Container(
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFF9FAFB),
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(
// //             color: const Color(0xFFE5E7EB),
// //             width: 1,
// //           ),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 52,
// //               height: 52,
// //               decoration: BoxDecoration(
// //                 gradient: gradient,
// //                 borderRadius: BorderRadius.circular(14),
// //               ),
// //               child: Icon(icon, color: Colors.white, size: 26),
// //             ),
// //             const SizedBox(width: 16),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title,
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                       color: Color(0xFF1F2937),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     subtitle,
// //                     style: const TextStyle(
// //                       fontSize: 13,
// //                       color: Color(0xFF6B7280),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const Icon(
// //               Icons.arrow_forward_ios_rounded,
// //               size: 18,
// //               color: Color(0xFF9CA3AF),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../merchantlogin/view/merchant_registration.dart';
// import '../../userlogin/view/user_signup.dart';
// import '../../userlogin/widget/usersignin_form.dart';
// import '../../forgotpassowrd/view/forgotpassword.dart';
// import '../controller/userlogin_controller.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildBrandSection(),
//                 const SizedBox(height: 40),
//                 _buildRoleSelector(),
//                 const SizedBox(height: 24),
//                 _buildLoginCard(),
//                 const SizedBox(height: 16),
//                 _buildForgotPassword(),
//                 const SizedBox(height: 24),
//                 _buildSignUpSection(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBrandSection() {
//     return Column(
//       children: [
//         Container(
//           width: 90,
//           height: 90,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFF009788),
//                 Color(0xFF32CCB6),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF009788).withOpacity(0.3),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.shopping_bag_rounded,
//             color: Colors.white,
//             size: 45,
//           ),
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           "eShoppy",
//           style: TextStyle(
//             fontSize: 36,
//             fontWeight: FontWeight.w800,
//             color: Color(0xFF1F2937),
//             letterSpacing: -1,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Sign in to continue shopping",
//           style: TextStyle(
//             fontSize: 15,
//             color: const Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRoleSelector() {
//     final controller = Get.find<UserloginController>();
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(4),
//       child: Obx(() {
//         return Row(
//           children: controller.roles.entries.map((entry) {
//             final role = entry.value;
//             final isSelected = controller.selectedRole.value == role.id;
//             return Expanded(
//               child: GestureDetector(
//                 onTap: () => controller.setRole(role.id),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   curve: Curves.easeInOut,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: BoxDecoration(
//                     color: isSelected ? Colors.white : Colors.transparent,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: isSelected
//                         ? [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ]
//                         : null,
//                   ),
//                   child: Text(
//                     role.name,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//                       color: isSelected
//                           ? const Color(0xFF009788)
//                           : const Color(0xFF6B7280),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       }),
//     );
//   }
//
//   Widget _buildLoginCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(28),
//       child: UsersigninForm(),
//     );
//   }
//
//   Widget _buildForgotPassword() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: TextButton(
//         onPressed: () => Get.to(() => ForgotPasswordEmailView()),
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         ),
//         child: const Text(
//           "Forgot Password?",
//           style: TextStyle(
//             color: Color(0xFF6366F1),
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFE5E7EB),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Don't have an account?",
//             style: TextStyle(
//               color: Color(0xFF6B7280),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () => _showSignupBottomSheet(Get.context!),
//             child: const Text(
//               "Sign Up",
//               style: TextStyle(
//                 color: Color(0xFF6366F1),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSignupBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: EdgeInsets.fromLTRB(
//           24,
//           20,
//           24,
//           MediaQuery.of(context).viewInsets.bottom + 24,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE5E7EB),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Create Account",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1F2937),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//             const SizedBox(height: 28),
//             _buildSignupOption(
//               title: "User Account",
//               subtitle: "Shop and discover products",
//               icon: Icons.person_outline_rounded,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//               ),
//               onTap: () {
//                 Get.back();
//                 Get.to(() => UserSignup());
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildSignupOption(
//               title: "Merchant Account",
//               subtitle: "Sell and manage inventory",
//               icon: Icons.storefront_outlined,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF009788), Color(0xFF02715E)],
//               ),
//               onTap: () {
//                 Get.back();
//                 Get.to(() => MerchantRegisterScreen());
//               },
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignupOption({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF9FAFB),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: const Color(0xFFE5E7EB),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 52,
//               height: 52,
//               decoration: BoxDecoration(
//                 gradient: gradient,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(icon, color: Colors.white, size: 26),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF6B7280),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 18,
//               color: Color(0xFF9CA3AF),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../merchantlogin/view/merchant_registration.dart';
import '../../userlogin/view/user_signup.dart';
import '../../userlogin/widget/usersignin_form.dart';
import '../../forgotpassowrd/view/forgotpassword.dart';
import '../controller/userlogin_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 48),
                _buildRoleSelector(),
                const SizedBox(height: 32),
                _buildLoginCard(),
                const SizedBox(height: 20),
                _buildForgotPassword(),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Modern Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF009788),
                Color(0xFF009788),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: const Color(0xFF00BFA5).withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        // App Name
        const Text(
          "eShoppy",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          "Welcome! Please login to continue",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    final controller = Get.find<UserloginController>();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Obx(() {
        return Row(
          children: controller.roles.entries.map((entry) {
            final role = entry.value;
            final isSelected = controller.selectedRole.value == role.id;
            final isFirst = controller.roles.entries.first.key == entry.key;
            final isLast = controller.roles.entries.last.key == entry.key;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.setRole(role.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(
                    right: isLast ? 0 : 4,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [
                        Color(0xFF009788),
                        Color(0xFF009788),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: isSelected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: const Color(0xFF009788).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        role.icon,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        role.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: UsersigninForm(),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => ForgotPasswordEmailView()),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
            color: Color(0xFF009688),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE9ECEF),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE9ECEF),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => _showSignupBottomSheet(Get.context!),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Color(0xFF009688),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  void _showSignupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Header
            const Text(
              "Create New Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose your account type to get started",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            // User Account Option
            _buildSignupOption(
              title: "User Account",
              subtitle: "Browse and shop for amazing products",
              icon: Icons.person_outline_rounded,
              gradientColors: const [Color(0xFF00BFA5), Color(0xFF009688)],
              onTap: () {
                Get.back();
                Get.to(() => UserSignup());
              },
            ),
            const SizedBox(height: 16),
            // Merchant Account Option
            _buildSignupOption(
              title: "Merchant Account",
              subtitle: "Sell products and grow your business",
              icon: Icons.store_outlined,
              gradientColors: const [Color(0xFF7C4DFF), Color(0xFF651FFF)],
              onTap: () {
                Get.back();
                Get.to(() => MerchantRegisterScreen());
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE9ECEF),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}