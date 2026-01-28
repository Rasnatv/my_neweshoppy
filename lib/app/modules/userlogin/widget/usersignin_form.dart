
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/userlogin_controller.dart';
import '../../../common/style/app_colors.dart';

class UsersigninForm extends StatelessWidget {
  UsersigninForm({super.key});

  final UserloginController controller = Get.find<UserloginController>();
  final _formKey = GlobalKey<FormState>();

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white.withOpacity(0.8),
        size: 22,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.12),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.kPrimary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 2,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.red.shade300,
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
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: _decoration(
              hint: "Email",
              icon: Icons.email_outlined,
            ),
          ),

          const SizedBox(height: 18),

          // Password Field with Toggle
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
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: _decoration(
              hint: "Password",
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white.withOpacity(0.7),
                  size: 22,
                ),
                onPressed: controller.togglePasswordVisibility,
                splashRadius: 20,
              ),
            ),
          )),

          const SizedBox(height: 28),

          // Login Button with Loading Indicator
          Obx(() => SizedBox(
            width: double.infinity,
            height: 56,
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
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.kPrimary.withOpacity(0.6),
                elevation: 0,
                shadowColor: AppColors.kPrimary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: controller.isLoading.value
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Logging in...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              )
                  : const Text(
                "Login",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}