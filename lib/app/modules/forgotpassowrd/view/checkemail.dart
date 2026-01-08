
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/text_String.dart';
import '../../../common/style/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/Headline2.dart';
import '../controller/checkemailotp_controller.dart';

class CheckemailScreen  extends StatelessWidget {
  const CheckemailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckEmailOtpController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.kPrimary.withOpacity(0.1),
              child: Icon(Icons.lock_outline,
                  size: 50, color: AppColors.kPrimary),
            ),
            const SizedBox(height: 25),

            Subheadlines(head1: AppTexts.check, head2: AppTexts.checksubtitle),

            const SizedBox(height: 40),

            // OTP Boxes Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  height: 60,
                  child: TextField(
                    controller: controller.otpControllers[index],
                    focusNode: controller.focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (val) =>
                        controller.onOtpChanged(val, index),
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.kPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Verify Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()=>Get.toNamed(Routes.NewPSWD),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify Code",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Resend OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Haven't got the email yet",
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: controller.resendOtp,
                  child: Text(
                    "Resend email",
                    style: TextStyle(
                      color: AppColors.kPrimary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.kPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
