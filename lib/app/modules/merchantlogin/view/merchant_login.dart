
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/merchant_logform.dart';
import 'merchant_registration.dart';

class MerchantLoginScreen extends StatelessWidget {
  const MerchantLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 🌈 Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/shopimage.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // 🌑 Dark Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.35),
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
                const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    /// 🏪 Glassmorphism Shop Icon
                    _glassCircleIcon(
                      icon: Icons.storefront_rounded,
                      size: 52,
                    ),

                    const SizedBox(height: 24),

                    /// 🧾 Heading
                    const Text(
                      "Merchant Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Welcome back, please login to continue",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// 🌟 Glassmorphism Login Form
                    _glassContainer(
                      child: const MerchantLogform(),
                      blur: 20,
                      padding: const EdgeInsets.all(24),
                    ),

                    const SizedBox(height: 22),

                    /// 📝 Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "New Merchant? ",
                          style:
                          TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () =>
                              Get.to(() => const MerchantRegisterScreen()),
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
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
  static Widget _glassCircleIcon({
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

  // 🔵 Glassmorphism Container
  static Widget _glassContainer({
    required Widget child,
    double blur = 10,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.30),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

