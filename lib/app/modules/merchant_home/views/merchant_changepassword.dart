
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/merchant_chnagepasswordcontroller.dart';

class MerchantChangePasswordScreen extends StatelessWidget {
  final controller = Get.put(MerchantChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // back arrow color
        ),
        title: Text(
          "Change Password", style: AppTextStyle.rTextNunitoWhite16w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient


            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.shade600,
                          Colors.teal.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Security Update",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Update your password regularly to keep your account secure",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form Section
                  Text(
                    "Password Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Obx(() => Column(
                    children: [
                      // Current Password
                      _buildPasswordField(
                        controller: controller.currentPasswordCtrl,
                        label: "Current Password",
                        hint: "Enter your current password",
                        icon: Icons.lock_outline_rounded,
                        isObscured: controller.currentPasswordVisible.value,
                        onToggle: () => controller.currentPasswordVisible.toggle(),
                      ),

                      const SizedBox(height: 20),

                      // New Password
                      _buildPasswordField(
                        controller: controller.newPasswordCtrl,
                        label: "New Password",
                        hint: "Enter your new password",
                        icon: Icons.lock_open_rounded,
                        isObscured: controller.newPasswordVisible.value,
                        onToggle: () => controller.newPasswordVisible.toggle(),
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password
                      _buildPasswordField(
                        controller: controller.confirmPasswordCtrl,
                        label: "Confirm New Password",
                        hint: "Re-enter your new password",
                        icon: Icons.verified_user_rounded,
                        isObscured: controller.confirmPasswordVisible.value,
                        onToggle: () => controller.confirmPasswordVisible.toggle(),
                      ),

                      const SizedBox(height: 32),

                      // Password Requirements Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 18,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Password Requirements",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildRequirement("At least 8 characters long"),
                            _buildRequirement("Contains uppercase & lowercase letters"),
                            _buildRequirement("Includes at least one number"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Change Password Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: controller.isLoading.value
                                ? [Colors.grey.shade400, Colors.grey.shade400]
                                : [
                              Colors.teal,
                              Colors.teal.shade700,
                            ],
                          ),
                          boxShadow: controller.isLoading.value
                              ? []
                              : [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                            controller.changePassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Update Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
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
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(
            icon,
            color: Colors.teal,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey.shade600,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.teal,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.blue.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}