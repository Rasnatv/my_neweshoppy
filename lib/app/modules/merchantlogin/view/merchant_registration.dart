
import 'dart:ui';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/backarrowwidget.dart';
import 'package:eshoppy/app/widgets/iconbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../../userlogin/view/sigin.dart';
import '../widget/merchant_regform.dart';

class MerchantRegisterScreen extends StatefulWidget {
  const MerchantRegisterScreen({super.key});

  @override
  State<MerchantRegisterScreen> createState() => _MerchantRegisterScreenState();
}

class _MerchantRegisterScreenState extends State<MerchantRegisterScreen>
    with TickerProviderStateMixin {
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
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(

      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildFormCard(),
                      const SizedBox(height: 24),
                      _buildLoginPrompt(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildBackButton()
        ],
      ),
    ));
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
     child:BackArrow()
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        IconBox(icon: Icons.storefront_rounded,backgroundColor: AppColors.kPrimary,),
        const SizedBox(height: 24),
        const Text(
          "Merchant Registration",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Create your merchant account",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: MerchantRegform(),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account?",
            style: TextStyle(
              color: Color(0xFF616161),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: () => Get.to(() => const LoginScreen()),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              "Login Here",
              style: TextStyle(
                color: Color(0xFF009788),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
