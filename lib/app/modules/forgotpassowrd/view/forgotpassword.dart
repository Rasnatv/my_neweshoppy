
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/text_String.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/Headline2.dart';
import '../controller/forgotpswd_controller.dart';

class ForgotPasswordEmailView extends GetView<ForgotPasswordController> {
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());

    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.kPrimary.withOpacity(0.1),
              child: const Icon(Icons.email_outlined,
                  color: AppColors.kPrimary, size: 50),
            ),

            const SizedBox(height: 25),

            Subheadlines(
              head1: AppTexts.forgotpswd,
              head2: AppTexts.forgotpasswordsubtitle,
            ),

            const SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                color: AppColors.grayButton.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        labelStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.email_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.sendOtp,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Back to Login",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.kbackground,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}