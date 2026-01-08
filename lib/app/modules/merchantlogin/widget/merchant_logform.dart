
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/dimens.dart';
import '../../forgotpassowrd/view/forgotpassword.dart';
import '../../merchant_home/views/merchant_home.dart';

class MerchantLogform extends StatelessWidget {
  const MerchantLogform({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          TextFormField(
          decoration: const InputDecoration(
          labelText: "Business Email",
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.email_outlined,color: Colors.white,),
          ),
        ),
        Dimens.kSizedBoxH14,
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.lock_outline,color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: ()=>Get.to(()=>ForgotPasswordEmailView()),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: AppColors.kbackground),
            ),
          ),
        ),
        const SizedBox(height: 5),

        // 🔘 Login button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: () =>Get.to(
                //MerchantHomePage()),
              MerchantDashboardPage()),

            child: const Text(
              'Login ',
              style:
              TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        )]))
        );
  }
}
