
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
          _buildBackground(),
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

  // ===========================================================================
  // BACKGROUND
  // ===========================================================================
  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/products/store.jpg',
            fit: BoxFit.cover,
          ),
        ),
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

  // ===========================================================================
  // HEADER
  // ===========================================================================
  Widget _buildHeader() {
    return Column(
      children: [
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
        const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign up to get started",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SIGNUP FORM
  // ===========================================================================
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

                /// ✅ ADDRESS FIELD – LOCATION AWARE
                _buildGlassField(
                  controller: controller.addressController,
                  label: "Address",
                  hint: 'Enter your address',
                  maxLines: 2,
                   icon: Icons.location_on_outlined,
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
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
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

  // ===========================================================================
  // GLASS FIELD (SAFE EXTENDED VERSION)
  // ===========================================================================
  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
    Color? hintColor,
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
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            maxLines: obscure ? 1 : maxLines,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: hintColor ?? Colors.white.withOpacity(0.5),
              ),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: suffix,
              border: InputBorder.none,
              errorStyle: const TextStyle(height: 0),
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

  // ===========================================================================
  // SIGNUP BUTTON
  // ===========================================================================
  Widget _buildSignupButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : controller.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF667eea),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

  // ===========================================================================
  // LOGIN PROMPT
  // ===========================================================================
  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
