
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/text_String.dart';
import '../../../widgets/headline.dart';
import '../../userlogin/view/sigin.dart';
import '../widget/merchant_regform.dart';

class MerchantRegisterScreen extends StatelessWidget {
  const MerchantRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 🌈 Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/products/newbackground.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🌑 Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.40),
                  Colors.black.withOpacity(0.30),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _glassCircleIcon(
                      icon: Icons.storefront_rounded,
                      size: 52,
                    ),
                    const SizedBox(height: 12),
                    Headline(
                      head1: AppTexts.Title4,
                      head2: AppTexts.Title5,
                    ),
                    const SizedBox(height: 25),
                    _glassContainer(
                      blur: 20,
                      padding: const EdgeInsets.all(24),
                      child: MerchantRegform(),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () =>
                              Get.to(() => const LoginScreen(),),
                          child: const Text(
                            "Login Here",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔵 Glassmorphism Circular Icon
  Widget _glassCircleIcon({
    required IconData icon,
    double size = 48,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.18),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            size: size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _glassContainer({
    required Widget child,
    double blur = 10,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.17),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

