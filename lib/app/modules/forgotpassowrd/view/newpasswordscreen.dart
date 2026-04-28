
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/text_String.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/Headline2.dart';
import '../controller/newpswd_controller.dart';

class SetNewPasswordView extends GetView<NewPasswordController> {
  const SetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),

            Subheadlines(
              head1: AppTexts.Setnewpassword,
              head2: AppTexts.Setnewpswdsubtitle,
            ),

            const SizedBox(height: 30),

            const Text(
              "Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "Enter new password",
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            )),

            const SizedBox(height: 20),

            const Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            Obx(() => TextField(
              controller: controller.confirmPasswordController,
              obscureText: controller.isConfirmPasswordHidden.value,
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "Re-enter password",
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              ),
            )),

            const SizedBox(height: 30),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Update Password",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    ));
  }
}