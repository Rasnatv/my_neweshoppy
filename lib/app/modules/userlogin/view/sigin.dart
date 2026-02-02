//
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../merchantlogin/view/merchant_registration.dart';
// import '../../userlogin/view/user_signup.dart';
// import '../../userlogin/widget/usersignin_form.dart';
// import '../../forgotpassowrd/view/forgotpassword.dart';
// import '../controller/userlogin_controller.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _floatController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     _floatController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat(reverse: true);
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutCubic,
//     ));
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _floatController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFF8F9FA),
//               Color(0xFFE9ECEF),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             _buildFloatingShapes(),
//             SafeArea(
//               child: Center(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildBrandSection(),
//                           const SizedBox(height: 40),
//                           _buildRoleSelector(),
//                           const SizedBox(height: 32),
//                           _buildLoginCard(),
//                           const SizedBox(height: 5),
//                           _buildForgotPassword(),
//                           const SizedBox(height: 8),
//                           _buildSignUpSection(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingShapes() {
//     return Stack(
//       children: [
//         // Animated floating shape 1
//         AnimatedBuilder(
//           animation: _floatController,
//           builder: (context, child) {
//             return Positioned(
//               top: 100 + (_floatController.value * 30),
//               right: -50,
//               child: Transform.rotate(
//                 angle: _floatController.value * math.pi / 4,
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF009788).withOpacity(0.15),
//                         const Color(0xFF009788).withOpacity(0.05),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(60),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // Animated floating shape 2
//         AnimatedBuilder(
//           animation: _floatController,
//           builder: (context, child) {
//             return Positioned(
//               bottom: 150 - (_floatController.value * 40),
//               left: -80,
//               child: Transform.rotate(
//                 angle: -_floatController.value * math.pi / 3,
//                 child: Container(
//                   width: 250,
//                   height: 250,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF009788).withOpacity(0.12),
//                         const Color(0xFF26A69A).withOpacity(0.03),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(70),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // Static decorative element
//         Positioned(
//           top: 50,
//           left: 40,
//           child: Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 colors: [
//                   const Color(0xFF009788).withOpacity(0.2),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBrandSection() {
//     return Column(
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFF009788),
//                 Color(0xFF00796B),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF009788).withOpacity(0.3),
//                 blurRadius: 24,
//                 offset: const Offset(0, 12),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.shopping_bag_rounded,
//             color: Colors.white,
//             size: 40,
//           ),
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           "Welcome to eShoppy",
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF212121),
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Please sign in to continue",
//           style: TextStyle(
//             fontSize: 16,
//             color: const Color(0xFF757575),
//             fontWeight: FontWeight.w400,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRoleSelector() {
//     final controller = Get.find<UserloginController>();
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Account Type",
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF757575),
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(() {
//             return Row(
//               children: controller.roles.entries.map((entry) {
//                 final role = entry.value;
//                 final isSelected = controller.selectedRole.value == role.id;
//
//                 return Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: _buildRoleChip(
//                       role: role,
//                       isSelected: isSelected,
//                       onTap: () => controller.setRole(role.id),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRoleChip({
//     required dynamic role,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeInOut,
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? const LinearGradient(
//             colors: [
//               Color(0xFF009788),
//               Color(0xFF00796B),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           )
//               : null,
//           color: isSelected ? null : const Color(0xFFF8F9FA),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected
//                 ? const Color(0xFF009788)
//                 : const Color(0xFFE0E0E0),
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: isSelected
//               ? [
//             BoxShadow(
//               color: const Color(0xFF009788).withOpacity(0.25),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ]
//               : [],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               role.icon,
//               color: isSelected ? Colors.white : const Color(0xFF757575),
//               size: 24,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               role.name,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : const Color(0xFF424242),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.3,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 24,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(32),
//       child: UsersigninForm(),
//     );
//   }
//
//   Widget _buildForgotPassword() {
//     return TextButton(
//       onPressed: () => Get.to(() => ForgotPasswordEmailView()),
//       style: TextButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         //mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Forgot your password?",
//             style: TextStyle(
//               color: const Color(0xFF009788),
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: 4),
//           Icon(
//             Icons.arrow_forward_rounded,
//             size: 16,
//             color: const Color(0xFF009788),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSignUpSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFE0E0E0),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Don't have an account?",
//             style: TextStyle(
//               color: const Color(0xFF616161),
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           TextButton(
//             onPressed: () => _showSignupBottomSheet(context),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//             ),
//             child: const Text(
//               "Sign Up",
//               style: TextStyle(
//                 color: Color(0xFF009788),
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
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
//                 color: const Color(0xFFE0E0E0),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Create Account",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF212121),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Choose your account type to get started",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: const Color(0xFF757575),
//               ),
//             ),
//             const SizedBox(height: 28),
//             _buildSignupOption(
//               title: "User Account",
//               subtitle: "Shop and discover products",
//               icon: Icons.person_outline_rounded,
//               onTap: () {
//                 Get.back();
//                 Get.to(() => UserSignup());
//               },
//             ),
//             const SizedBox(height: 12),
//             _buildSignupOption(
//               title: "Merchant Account",
//               subtitle: "Sell products and manage inventory",
//               icon: Icons.storefront_outlined,
//               onTap: () {
//                 Get.back();
//                 Get.to(() => MerchantRegisterScreen());
//               },
//             ),
//             const SizedBox(height: 12),
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
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8F9FA),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: const Color(0xFFE0E0E0),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color(0xFF009788),
//                     Color(0xFF097569),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: Colors.white, size: 24),
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
//                       color: Color(0xFF212121),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: const Color(0xFF757575),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 16,
//               color: const Color(0xFF9E9E9E),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBrandSection(),
                const SizedBox(height: 40),
                _buildRoleSelector(),
                const SizedBox(height: 24),
                _buildLoginCard(),
                const SizedBox(height: 16),
                _buildForgotPassword(),
                const SizedBox(height: 24),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF009788),
                Color(0xFF32CCB6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 45,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "eShoppy",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to continue shopping",
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    final controller = Get.find<UserloginController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Type",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Row(
              children: controller.roles.entries.map((entry) {
                final role = entry.value;
                final isSelected = controller.selectedRole.value == role.id;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildRoleChip(
                      role: role,
                      isSelected: isSelected,
                      onTap: () => controller.setRole(role.id),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRoleChip({
    required dynamic role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [
              Color(0xFF009788),
              Color(0xFF02715E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              role.icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              role.name,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF374151),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: UsersigninForm(),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => ForgotPasswordEmailView()),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showSignupBottomSheet(Get.context!),
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose your account type",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 28),
            _buildSignupOption(
              title: "User Account",
              subtitle: "Shop and discover products",
              icon: Icons.person_outline_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              onTap: () {
                Get.back();
                Get.to(() => UserSignup());
              },
            ),
            const SizedBox(height: 16),
            _buildSignupOption(
              title: "Merchant Account",
              subtitle: "Sell and manage inventory",
              icon: Icons.storefront_outlined,
              gradient: const LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
              ),
              onTap: () {
                Get.back();
                Get.to(() => MerchantRegisterScreen());
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}