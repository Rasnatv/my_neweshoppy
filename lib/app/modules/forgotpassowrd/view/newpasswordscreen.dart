
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/text_String.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/Headline2.dart';
import '../controller/newpswd_controller.dart';

class SetNewPasswordView
    extends GetView<NewPasswordController> {
  const SetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
   // Get.put(NewPasswordController());

    return Scaffold(
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

            const Text("Password",
                style: TextStyle(fontWeight: FontWeight.w600)),

            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText:
              controller.isPasswordHidden.value,
              decoration: InputDecoration(
                hintText: "Enter new password",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed:
                  controller.togglePasswordVisibility,
                ),
              ),
            )),

            const SizedBox(height: 20),

            const Text("Confirm Password",
                style: TextStyle(fontWeight: FontWeight.w600)),

            Obx(() => TextField(
              controller:
              controller.confirmPasswordController,
              obscureText: controller
                  .isConfirmPasswordHidden.value,
              decoration: InputDecoration(
                hintText: "Re-enter password",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller
                      .toggleConfirmPasswordVisibility,
                ),
              ),
            )),

            const SizedBox(height: 30),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Update Password",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
