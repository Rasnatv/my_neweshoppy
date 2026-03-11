//
// import 'dart:ui';
// import 'package:eshoppy/app/common/style/app_colors.dart';
// import 'package:eshoppy/app/widgets/iconbox.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../../common/utils/validators.dart';
// import '../../../widgets/backarrowwidget.dart';
// import '../controller/usersignup_controller.dart';
//
// class UserSignup extends StatefulWidget {
//   const UserSignup({super.key});
//
//   @override
//   State<UserSignup> createState() => _UserSignupState();
// }
//
// class _UserSignupState extends State<UserSignup> with TickerProviderStateMixin {
//   final UsersignupController controller = Get.put(UsersignupController());
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeOutCubic,
//       ),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 40),
//                         _buildHeader(),
//                         const SizedBox(height: 40),
//                         _buildSignupForm(context),
//                         const SizedBox(height: 24),
//                         _buildLoginPrompt(),
//                         const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           _buildBackButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackButton() {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 8,
//       left: 8,
//       child: BackArrow(),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       children: [
//         IconBox(
//           icon: Icons.shopping_bag_rounded,
//           backgroundColor: AppColors.kPrimary,
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           "Create Account",
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF212121),
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           "Sign up to get started",
//           style: TextStyle(
//             fontSize: 16,
//             color: Color(0xFF757575),
//             fontWeight: FontWeight.w400,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSignupForm(BuildContext context) {
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
//       padding: const EdgeInsets.all(28),
//       child: Form(
//         key: controller.formKey,
//         child: Column(
//           children: [
//             // Full Name
//             _buildTextField(
//               controller: controller.nameController,
//               label: "Full Name",
//               icon: Icons.person_outline_rounded,
//               validator: (v) => DValidator.validateEmptyText("Full Name", v),
//             ),
//             const SizedBox(height: 20),
//
//             // Email
//             _buildTextField(
//               controller: controller.emailController,
//               label: "Email",
//               icon: Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//               validator: (v) => DValidator.validateEmail(v),
//             ),
//             const SizedBox(height: 20),
//
//             // Phone — restricted to 10 digits only
//             _buildTextField(
//               controller: controller.phoneController,
//               label: "Phone",
//               icon: Icons.phone_outlined,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//               validator: (v) => DValidator.validatePhoneNumber(v),
//             ),
//             const SizedBox(height: 20),
//
//             // Address
//             _buildTextField(
//               controller: controller.addressController,
//               label: "Address",
//               icon: Icons.location_on_outlined,
//               maxLines: 2,
//               validator: (v) => DValidator.validateEmptyText("Address", v),
//             ),
//             const SizedBox(height: 20),
//
//             // Password
//             Obx(
//                   () => _buildTextField(
//                 controller: controller.passwordController,
//                 label: "Password",
//                 icon: Icons.lock_outline_rounded,
//                 obscureText: !controller.isPasswordVisible.value,
//                 validator: (v) => DValidator.validatePassword(v),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     controller.isPasswordVisible.value
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     size: 20,
//                   ),
//                   onPressed: controller.togglePasswordVisibility,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 28),
//
//             _buildSignupButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     int maxLines = 1,
//     Widget? suffixIcon,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       maxLines: obscureText ? 1 : maxLines,
//       validator: validator,
//       inputFormatters: inputFormatters,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: const Color(0xFFF8F9FA),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignupButton() {
//     return Obx(
//           () => SizedBox(
//         width: double.infinity,
//         height: 54,
//         child: ElevatedButton(
//           onPressed: controller.isLoading.value
//               ? null
//               : () {
//             if (controller.formKey.currentState!.validate()) {
//               controller.register();
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF009788),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//           child: controller.isLoading.value
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text(
//             "Create Account",
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginPrompt() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E0E0)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text("Already have an account?"),
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text(
//               "Sign In",
//               style: TextStyle(
//                 color: Color(0xFF009788),
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/iconbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/themes/textform_theme.dart';
import '../../../common/utils/validators.dart';
import '../../../widgets/backarrowwidget.dart';
import '../controller/usersignup_controller.dart';
// 👈 import your theme

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> with TickerProviderStateMixin {
  final UsersignupController controller = Get.put(UsersignupController());

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildSignupForm(context),
                        const SizedBox(height: 24),
                        _buildLoginPrompt(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: BackArrow(),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        IconBox(
          icon: Icons.shopping_bag_rounded,
          backgroundColor: AppColors.kPrimary,
        ),
        const SizedBox(height: 24),
        const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Sign up to get started",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Full Name
            TextFormField(
              controller: controller.nameController,
              style: DInputDecoration.inputTextStyle,
              decoration: DInputDecoration.of("Full Name", Icons.person_outline_rounded),
              validator: (v) => DValidator.validateEmptyText("Full Name", v),
            ),
            const SizedBox(height: 20),

            // Email
            TextFormField(
              controller: controller.emailController,
              style: DInputDecoration.inputTextStyle,
              keyboardType: TextInputType.emailAddress,
              decoration: DInputDecoration.of("Email", Icons.email_outlined),
              validator: (v) => DValidator.validateEmail(v),
            ),
            const SizedBox(height: 20),

            // Phone
            TextFormField(
              controller: controller.phoneController,
              style: DInputDecoration.inputTextStyle,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: DInputDecoration.of("Phone", Icons.phone_outlined),
              validator: (v) => DValidator.validatePhoneNumber(v),
            ),
            const SizedBox(height: 20),

            // Address
            TextFormField(
              controller: controller.addressController,
              style: DInputDecoration.inputTextStyle,
              maxLines: 2,
              decoration: DInputDecoration.of("Address", Icons.location_on_outlined),
              validator: (v) => DValidator.validateEmptyText("Address", v),
            ),
            const SizedBox(height: 20),

            // Password
            Obx(
                  () => TextFormField(
                controller: controller.passwordController,
                style: DInputDecoration.inputTextStyle,
                obscureText: !controller.isPasswordVisible.value,
                decoration: DInputDecoration.password(
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                validator: (v) => DValidator.validatePassword(v),
              ),
            ),
            const SizedBox(height: 28),

            _buildSignupButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
            if (controller.formKey.currentState!.validate()) {
              controller.register();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009788),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            "Create Account",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Sign In",
              style: TextStyle(
                color: Color(0xFF009788),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}