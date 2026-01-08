
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/text_String.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/Headline2.dart';
import '../controller/forgotpswd_controller.dart';
import 'checkemail.dart';

class ForgotPasswordEmailView extends GetView<ForgotPasswordController>{
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // 📧 Icon Circle
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.kPrimary.withOpacity(0.1),
              child: const Icon(
                Icons.email_outlined,
                color: AppColors.kPrimary,
                size: 50,
              ),
            ),

            const SizedBox(height: 25),

            Subheadlines( head1: AppTexts.forgotpswd, head2:AppTexts.forgotpasswordsubtitle,),
            const SizedBox(height: 40),

            // 🪪 Email Field Card
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
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child:  Column(
                  children: [
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        prefixIcon: const Icon(Icons.email_rounded,),
                            //),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:()=>Get.to(CheckemailScreen()),
                        child: const Text(
                          "Send ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔙 Back to Login
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Back to Login",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.kbackground,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.kbackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:ui';
// import 'package:abc/app/modules/forgotpassowrd/view/checkemail.dart';
// import 'package:abc/app/widgets/Headline2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:abc/app/common/style/app_colors.dart';
// import '../../../common/constants/text_String.dart';
// import '../controller/forgotpswd_controller.dart';
//
// class ForgotPasswordEmailView extends GetView<ForgotPasswordController> {
//   const ForgotPasswordEmailView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ForgotPasswordController());
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 🌈 Fullscreen Background Gradient
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFE4E9F1),
//                   Color(0xff6ac1b4),
//                   Color(0xFFD2EDED),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           // Scroll Content Over Background
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 const SizedBox(height: 100),
//
//                 // 💠 Glass Circular Icon
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(80),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: CircleAvatar(
//                       radius: 55,
//                       backgroundColor: Colors.white.withOpacity(0.25),
//                       child: const Icon(
//                         Icons.email_outlined,
//                         color: Colors.white,
//                         size: 50,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 Subheadlines(
//                   head1: AppTexts.forgotpswd,
//                   head2: AppTexts.forgotpasswordsubtitle,
//                   head2Color: Colors.white,
//
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // 🧊 Glassmorphic Card
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(25),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.18),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextField(
//                             controller: controller.emailController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: InputDecoration(
//                               labelText: "Email Address",
//                               labelStyle: TextStyle(
//                                   color: Colors.white.withOpacity(0.9)),
//                               prefixIcon: Icon(
//                                 Icons.email_rounded,
//                                 color: Colors.white.withOpacity(0.9),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.white.withOpacity(0.5)),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                   color: Colors.white,
//                                   width: 1.5,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 25),
//
//                           // SEND BUTTON
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: AppColors.kPrimary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding:
//                                 const EdgeInsets.symmetric(vertical: 14),
//                               ),
//                               onPressed: () => Get.to(CheckemailScreen()),
//                               child: const Text(
//                                 "Send",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // BACK TO LOGIN
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text(
//                     "Back to Login",
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white,
//                       decoration: TextDecoration.underline,
//                       decorationColor: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
