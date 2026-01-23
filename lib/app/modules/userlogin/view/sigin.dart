
import 'dart:ui';
import 'package:eshoppy/app/modules/forgotpassowrd/view/forgotpassword.dart';
import 'package:eshoppy/app/modules/userlogin/view/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../merchantlogin/view/merchant_registration.dart';
import '../../userlogin/widget/usersignin_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Image with Parallax Effect
          Positioned.fill(
            child: Image.asset(
              'assets/images/products/shopnow.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Logo or Icon (Optional)
                        _buildAppLogo(),
                        const SizedBox(height: 24),

                        // Welcome Text
                        const Text(
                          "Welcome to eShoppy!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Sign in to continue shopping",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Login Form in Glass Container
                        _glassContainer(
                          child:  UsersigninForm(),
                          blur: 25,
                          padding: const EdgeInsets.all(28),
                        ),
                        const SizedBox(height: 16),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.to(() => ForgotPasswordEmailView()),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showSignupRoleSheet(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const Icon(
            Icons.shopping_bag_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showSignupRoleSheet(BuildContext context) {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const Text(
                  "Choose Account Type",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Select how you want to join eShoppy",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),

                _glassButton(
                  title: "User Sign Up",
                  subtitle: "Shop amazing products",
                  icon: Icons.person_outline_rounded,
                  color: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.to(() => UserSignup());
                  },
                ),
                const SizedBox(height: 16),

                _glassButton(
                  title: "Merchant Sign Up",
                  subtitle: "Start selling today",
                  icon: Icons.storefront_outlined,
                  color: Colors.orangeAccent,
                  onTap: () {
                    Get.back();
                    Get.to(() => MerchantRegisterScreen());
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  Widget _glassContainer({
    required Widget child,
    double blur = 10,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _glassButton({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: color.withOpacity(0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}