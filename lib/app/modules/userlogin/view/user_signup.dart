//
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/usersignup_controller.dart';
//
// class UserSignup extends StatelessWidget {
//   UserSignup({super.key});
//
//   final UsersignupController controller =
//   Get.put(UsersignupController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Image.asset(
//                   'assets/images/products/store.jpg',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               Container(
//                 color: Colors.black.withOpacity(0.4),
//               ),
//
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Form(
//                     key: controller.formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const SizedBox(height: 60),
//
//                         const Text(
//                           "Create Account",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         const SizedBox(height: 20),
//
//                         _glassField(
//                           controller: controller.nameController,
//                           label: "Full Name",
//                           icon: Icons.person,
//                         ),
//
//                         _glassField(
//                           controller: controller.emailController,
//                           label: "Email",
//                           icon: Icons.email,
//                           isEmail: true,
//                         ),
//
//                         _glassField(
//                           controller: controller.phoneController,
//                           label: "Phone",
//                           icon: Icons.phone,
//                         ),
//
//                         _glassField(
//                           controller: controller.addressController,
//                           label: "Address",
//                           icon: Icons.location_on,
//                         ),
//
//                         Obx(() => _glassField(
//                           controller:
//                           controller.passwordController,
//                           label: "Password",
//                           icon: Icons.lock,
//                           obscure:
//                           !controller.isPasswordVisible.value,
//                           suffix: IconButton(
//                             icon: Icon(
//                               controller.isPasswordVisible.value
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: Colors.white70,
//                             ),
//                             onPressed: controller
//                                 .togglePasswordVisibility,
//                           ),
//                         )),
//
//                         const SizedBox(height: 20),
//
//                         Obx(() => SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed:
//                             controller.isLoading.value
//                                 ? null
//                                 : controller.register,
//                             child: controller.isLoading.value
//                                 ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                                 : const Text("Sign Up"),
//                           ),
//                         )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _glassField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscure = false,
//     bool isEmail = false,
//     Widget? suffix,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscure,
//             style: const TextStyle(color: Colors.white),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Required";
//               }
//               if (isEmail && !value.contains("@")) {
//                 return "Invalid email";
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               labelText: label,
//               labelStyle:
//               const TextStyle(color: Colors.white70),
//               prefixIcon:
//               Icon(icon, color: Colors.white70),
//               suffixIcon: suffix,
//               filled: true,
//               fillColor:
//               Colors.white.withOpacity(0.15),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/usersignup_controller.dart';
//
// class UserSignup extends StatelessWidget {
//   UserSignup({super.key});
//
//   final UsersignupController controller = Get.put(UsersignupController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image with Gradient Overlay
//           _buildBackground(),
//
//           // Main Content
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),
//                     _buildHeader(),
//                     const SizedBox(height: 40),
//                     _buildSignupForm(context),
//                     const SizedBox(height: 20),
//                     _buildLoginPrompt(),
//                     const SizedBox(height: 30),
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
//   // ============================================================================
//   // BACKGROUND
//   // ============================================================================
//   Widget _buildBackground() {
//     return Stack(
//       children: [
//         // Background Image
//         Positioned.fill(
//           child: Image.asset(
//             'assets/images/products/store.jpg',
//             fit: BoxFit.cover,
//           ),
//         ),
//
//         // Gradient Overlay
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black.withOpacity(0.7),
//                 Colors.black.withOpacity(0.5),
//                 Colors.black.withOpacity(0.7),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================================
//   // HEADER
//   // ============================================================================
//   Widget _buildHeader() {
//     return Column(
//       children: [
//         // Logo or Icon
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white.withOpacity(0.15),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.3),
//               width: 2,
//             ),
//           ),
//           child: const Icon(
//             Icons.shopping_bag_rounded,
//             size: 50,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 24),
//
//         // Title
//         const Text(
//           "Create Account",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 0.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // Subtitle
//         Text(
//           "Sign up to get started",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================================
//   // SIGNUP FORM
//   // ============================================================================
//   Widget _buildSignupForm(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.2),
//               width: 1.5,
//             ),
//           ),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               children: [
//                 _buildGlassField(
//                   controller: controller.nameController,
//                   label: "Full Name",
//                   hint: "Enter your full name",
//                   icon: Icons.person_outline_rounded,
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildGlassField(
//                   controller: controller.emailController,
//                   label: "Email",
//                   hint: "Enter your email",
//                   icon: Icons.email_outlined,
//                   isEmail: true,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildGlassField(
//                   controller: controller.phoneController,
//                   label: "Phone",
//                   hint: "Enter your phone number",
//                   icon: Icons.phone_outlined,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildGlassField(
//                   controller: controller.addressController,
//                   label: "Address",
//                   hint: "Enter your address",
//                   icon: Icons.location_on_outlined,
//                   maxLines: 2,
//                 ),
//                 const SizedBox(height: 16),
//
//                 Obx(() => _buildGlassField(
//                   controller: controller.passwordController,
//                   label: "Password",
//                   hint: "Create a strong password",
//                   icon: Icons.lock_outline_rounded,
//                   obscure: !controller.isPasswordVisible.value,
//                   suffix: IconButton(
//                     icon: Icon(
//                       controller.isPasswordVisible.value
//                           ? Icons.visibility_rounded
//                           : Icons.visibility_off_rounded,
//                       color: Colors.white70,
//                       size: 22,
//                     ),
//                     onPressed: controller.togglePasswordVisibility,
//                   ),
//                 )),
//                 const SizedBox(height: 28),
//
//                 _buildSignupButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ============================================================================
//   // GLASS FIELD
//   // ============================================================================
//   Widget _buildGlassField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     bool obscure = false,
//     bool isEmail = false,
//     Widget? suffix,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscure,
//             keyboardType: keyboardType,
//             maxLines: obscure ? 1 : maxLines,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "$label is required";
//               }
//               if (isEmail && !GetUtils.isEmail(value)) {
//                 return "Please enter a valid email";
//               }
//               if (label == "Password" && value.length < 6) {
//                 return "Password must be at least 6 characters";
//               }
//               if (label == "Phone" && value.length < 10) {
//                 return "Please enter a valid phone number";
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: Colors.white.withOpacity(0.5),
//                 fontSize: 14,
//               ),
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.white70,
//                 size: 22,
//               ),
//               suffixIcon: suffix,
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================================
//   // SIGNUP BUTTON
//   // ============================================================================
//   Widget _buildSignupButton() {
//     return Obx(() => Container(
//       width: double.infinity,
//       height: 56,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: controller.isLoading.value
//             ? null
//             : const LinearGradient(
//           colors: [
//             Color(0xFF667eea),
//             Color(0xFF764ba2),
//           ],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         color: controller.isLoading.value
//             ? Colors.white.withOpacity(0.2)
//             : null,
//         boxShadow: controller.isLoading.value
//             ? null
//             : [
//           BoxShadow(
//             color: const Color(0xFF667eea).withOpacity(0.5),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: controller.isLoading.value ? null : controller.register,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: controller.isLoading.value
//             ? const SizedBox(
//           height: 24,
//           width: 24,
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 2.5,
//           ),
//         )
//             : const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Create Account",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             SizedBox(width: 8),
//             Icon(Icons.arrow_forward_rounded, size: 20),
//           ],
//         ),
//       ),
//     ));
//   }
//
//   // ============================================================================
//   // LOGIN PROMPT
//   // ============================================================================
//   Widget _buildLoginPrompt() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Already have an account?",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 14,
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             Get.back(); // Navigate to login page
//           },
//           style: TextButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//           ),
//           child: const Text(
//             "Sign In",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               decoration: TextDecoration.underline,
//               decorationColor: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/usersignup_controller.dart';

class UserSignup extends StatelessWidget {
  UserSignup({super.key});

  final UsersignupController controller = Get.put(UsersignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          _buildBackground(),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildSignupForm(context),
                    const SizedBox(height: 20),
                    _buildLoginPrompt(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // BACKGROUND
  // ============================================================================
  Widget _buildBackground() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/products/store.jpg',
            fit: BoxFit.cover,
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // HEADER
  // ============================================================================
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo or Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          "Sign up to get started",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // SIGNUP FORM
  // ============================================================================
  Widget _buildSignupForm(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                _buildGlassField(
                  controller: controller.nameController,
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),

                _buildGlassField(
                  controller: controller.emailController,
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  isEmail: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                _buildGlassField(
                  controller: controller.phoneController,
                  label: "Phone",
                  hint: "Enter your phone number",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                _buildGlassField(
                  controller: controller.addressController,
                  label: "Address",
                  hint: "Enter your address",
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                Obx(() => _buildGlassField(
                  controller: controller.passwordController,
                  label: "Password",
                  hint: "Create a strong password",
                  icon: Icons.lock_outline_rounded,
                  obscure: !controller.isPasswordVisible.value,
                  suffix: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
                const SizedBox(height: 28),

                _buildSignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // GLASS FIELD - FIXED VERSION (NO SIZE INCREASE)
  // ============================================================================
  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool isEmail = false,
    Widget? suffix,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            maxLines: obscure ? 1 : maxLines,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            // ⚠️ FIX: Remove validator to prevent field expansion
            // Validation will be done manually on button click
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white70,
                size: 22,
              ),
              suffixIcon: suffix,
              border: InputBorder.none,
              // ⚠️ FIX: Hide error text completely
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // SIGNUP BUTTON WITH VALIDATION
  // ============================================================================
  Widget _buildSignupButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: controller.isLoading.value
            ? null
            : const LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        color: controller.isLoading.value
            ? Colors.white.withOpacity(0.2)
            : null,
        boxShadow: controller.isLoading.value
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () => _handleSignup(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    ));
  }

  // ============================================================================
  // MANUAL VALIDATION
  // ============================================================================
  void _handleSignup() {
    // Validate Full Name
    if (controller.nameController.text.trim().isEmpty) {
      _showError("Full Name is required");
      return;
    }

    // Validate Email
    if (controller.emailController.text.trim().isEmpty) {
      _showError("Email is required");
      return;
    }
    if (!GetUtils.isEmail(controller.emailController.text.trim())) {
      _showError("Please enter a valid email");
      return;
    }

    // Validate Phone
    if (controller.phoneController.text.trim().isEmpty) {
      _showError("Phone is required");
      return;
    }
    if (controller.phoneController.text.trim().length < 10) {
      _showError("Please enter a valid phone number");
      return;
    }

    // Validate Address
    if (controller.addressController.text.trim().isEmpty) {
      _showError("Address is required");
      return;
    }

    // Validate Password
    if (controller.passwordController.text.isEmpty) {
      _showError("Password is required");
      return;
    }
    if (controller.passwordController.text.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    // All validations passed - proceed with registration
    controller.register();
  }

  // ============================================================================
  // SHOW ERROR SNACKBAR
  // ============================================================================
  void _showError(String message) {
    Get.snackbar(
      "Validation Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  // ============================================================================
  // LOGIN PROMPT
  // ============================================================================
  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Navigate to login page
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}