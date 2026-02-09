//
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
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
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Stack(
//         children: [
//           _buildFloatingShapes(),
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
//                         const Color(0xFF26A69A).withOpacity(0.12),
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
//                   const Color(0xFF80CBC4).withOpacity(0.2),
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
//   Widget _buildBackButton() {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 8,
//       left: 8,
//       child: IconButton(
//         onPressed: () => Get.back(),
//         icon: const Icon(Icons.arrow_back_ios_rounded),
//         color: const Color(0xFF212121),
//         style: IconButton.styleFrom(
//           backgroundColor: Colors.white,
//           padding: const EdgeInsets.all(12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
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
//           "Create Account",
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF212121),
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Sign up to get started",
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
//             _buildTextField(
//               controller: controller.nameController,
//               label: "Full Name",
//               icon: Icons.person_outline_rounded,
//               validator: (v) {
//                 if (v == null || v.isEmpty) {
//                   return "Name is required";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             _buildTextField(
//               controller: controller.emailController,
//               label: "Email",
//               icon: Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//               validator: (v) {
//                 if (v == null || v.isEmpty) {
//                   return "Email is required";
//                 }
//                 if (!GetUtils.isEmail(v)) {
//                   return "Please enter a valid email";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             _buildTextField(
//               controller: controller.phoneController,
//               label: "Phone",
//               icon: Icons.phone_outlined,
//               keyboardType: TextInputType.phone,
//               validator: (v) {
//                 if (v == null || v.isEmpty) {
//                   return "Phone is required";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             _buildTextField(
//               controller: controller.addressController,
//               label: "Address",
//               icon: Icons.location_on_outlined,
//               maxLines: 2,
//               validator: (v) {
//                 if (v == null || v.isEmpty) {
//                   return "Address is required";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             Obx(() => _buildTextField(
//               controller: controller.passwordController,
//               label: "Password",
//               icon: Icons.lock_outline_rounded,
//               obscureText: !controller.isPasswordVisible.value,
//               validator: (v) {
//                 if (v == null || v.isEmpty) {
//                   return "Password is required";
//                 }
//                 if (v.length < 6) {
//                   return "Password must be at least 6 characters";
//                 }
//                 return null;
//               },
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   controller.isPasswordVisible.value
//                       ? Icons.visibility_outlined
//                       : Icons.visibility_off_outlined,
//                   color: const Color(0xFF757575),
//                   size: 20,
//                 ),
//                 onPressed: controller.togglePasswordVisibility,
//               ),
//             )),
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
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       maxLines: obscureText ? 1 : maxLines,
//       validator: validator,
//       style: const TextStyle(
//         color: Color(0xFF212121),
//         fontSize: 15,
//         fontWeight: FontWeight.w500,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(
//           color: Color(0xFF9E9E9E),
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//         floatingLabelStyle: const TextStyle(
//           color: Color(0xFF009788),
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//         prefixIcon: Icon(
//           icon,
//           color: const Color(0xFF757575),
//           size: 20,
//         ),
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: const Color(0xFFF8F9FA),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 20,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: Color(0xFFE0E0E0),
//             width: 1,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: Color(0xFFE0E0E0),
//             width: 1,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: Color(0xFF009788),
//             width: 2,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: Color(0xFFE57373),
//             width: 1,
//           ),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: Color(0xFFE57373),
//             width: 2,
//           ),
//         ),
//         errorStyle: const TextStyle(
//           color: Color(0xFFD32F2F),
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignupButton() {
//     return Obx(() => SizedBox(
//       width: double.infinity,
//       height: 54,
//       child: ElevatedButton(
//         onPressed: controller.isLoading.value
//             ? null
//             : () {
//           if (controller.formKey.currentState!.validate()) {
//             controller.register();
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF009788),
//           foregroundColor: Colors.white,
//           disabledBackgroundColor:
//           const Color(0xFF009788).withOpacity(0.5),
//           elevation: 0,
//           shadowColor: const Color(0xFF009788).withOpacity(0.3),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: controller.isLoading.value
//             ? const SizedBox(
//           width: 20,
//           height: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2.5,
//             valueColor: AlwaysStoppedAnimation<Color>(
//               Colors.white,
//             ),
//           ),
//         )
//             : const Text(
//           "Create Account",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ),
//     ));
//   }
//
//   Widget _buildLoginPrompt() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
//             "Already have an account?",
//             style: TextStyle(
//               color: const Color(0xFF616161),
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           TextButton(
//             onPressed: () => Get.back(),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//             ),
//             child: const Text(
//               "Sign In",
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
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/usersignup_controller.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup>
    with TickerProviderStateMixin {
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
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

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
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_rounded),
        color: const Color(0xFF212121),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF009788),
                Color(0xFF00796B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF009788).withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 40,
          ),
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
            _buildTextField(
              controller: controller.nameController,
              label: "Full Name",
              icon: Icons.person_outline_rounded,
              validator: (v) =>
              v == null || v.isEmpty ? "Name is required" : null,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: controller.emailController,
              label: "Email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return "Email is required";
                if (!GetUtils.isEmail(v)) return "Enter valid email";
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: controller.phoneController,
              label: "Phone",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) =>
              v == null || v.isEmpty ? "Phone is required" : null,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: controller.addressController,
              label: "Address",
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: (v) =>
              v == null || v.isEmpty ? "Address is required" : null,
            ),
            const SizedBox(height: 20),

            Obx(() => _buildTextField(
              controller: controller.passwordController,
              label: "Password",
              icon: Icons.lock_outline_rounded,
              obscureText: !controller.isPasswordVisible.value,
              validator: (v) {
                if (v == null || v.isEmpty) return "Password required";
                if (v.length < 6) return "Min 6 characters";
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            )),
            const SizedBox(height: 28),

            _buildSignupButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return Obx(() => SizedBox(
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
    ));
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
