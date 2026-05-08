
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/text_String.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/Headline2.dart';
import '../controller/checkemailotp_controller.dart';

class CheckemailScreen extends StatefulWidget {
  const CheckemailScreen({super.key});

  @override
  State<CheckemailScreen> createState() => _CheckemailScreenState();
}

class _CheckemailScreenState extends State<CheckemailScreen> {
  late final CheckEmailOtpController controller;

  @override
  void initState() {
    super.initState();
    // ✅ Put controller here — tied to this widget's lifecycle
    controller = Get.put(CheckEmailOtpController());
  }

  @override
  void dispose() {
    // ✅ Manually delete so GetX doesn't double-dispose
    Get.delete<CheckEmailOtpController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.kPrimary.withOpacity(0.1),
              child: const Icon(
                Icons.lock_outline,
                size: 50,
                color: AppColors.kPrimary,
              ),
            ),

            const SizedBox(height: 25),

            Subheadlines(
              head1: AppTexts.check,
              head2: AppTexts.checksubtitle,
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 48,
                  height: 58,
                  child: TextField(
                    controller: controller.otpControllers[index],
                    focusNode: controller.focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (val) => controller.onOtpChanged(val, index),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.verifyOtp,
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
                  "Verify Code",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Haven't got the email yet?",
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: controller.resendOtp,
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}