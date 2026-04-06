import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/userlogin_controller.dart';

class UsersigninForm extends StatelessWidget {
  UsersigninForm({super.key});

  final UserloginController controller = Get.find<UserloginController>();
  final _formKey = GlobalKey<FormState>();

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF009788),
        size: 22,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF009788),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 2,
        ),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFEF4444),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          TextFormField(
            controller: controller.username,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return "Email is required";
              }
              if (!GetUtils.isEmail(v)) {
                return "Please enter a valid email";
              }
              return null;
            },
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: "Email",
              icon: Icons.email_outlined,
            ),
          ),

          const SizedBox(height: 20),

          // Password Field
          Obx(() => TextFormField(
            controller: controller.password,
            obscureText: !controller.isPasswordVisible.value,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              if (_formKey.currentState!.validate()) {
                controller.submit();
              }
            },
            validator: (v) {
              if (v == null || v.isEmpty) {
                return "Password is required";
              }
              if (v.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: "Password",
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF9CA3AF),
                  size: 22,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          )),

          const SizedBox(height: 28),

          // // Login Button
          // Obx(() => SizedBox(
          //   width: double.infinity,
          //   height: 54,
          //   child: ElevatedButton(
          //     onPressed: controller.isLoading.value
          //         ? null
          //         : () {
          //       if (_formKey.currentState!.validate()) {
          //         FocusScope.of(context).unfocus();
          //         controller.submit();
          //       }
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.teal,
          //       foregroundColor: Colors.white,
          //       disabledBackgroundColor: const Color(0xFFD1D5DB),
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     child: controller.isLoading.value
          //         ? const SizedBox(
          //       width: 22,
          //       height: 22,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 2.5,
          //         valueColor: AlwaysStoppedAnimation<Color>(
          //           Colors.white,
          //         ),
          //       ),
          //     )
          //         : const Text(
          //       "Sign In",
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w700,
          //         letterSpacing: 0.3,
          //       ),
          //     ),
          //   ),
          // )),
          // Login Button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  controller.submit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.teal,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          )),

          const SizedBox(height: 24),

          // Social Login Buttons

        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(
        icon,
        color: const Color(0xFF6B7280),
        size: 22,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF374151),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}