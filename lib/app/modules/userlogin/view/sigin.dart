
import 'package:eshoppy/app/widgets/iconbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../merchantlogin/view/merchant_registration.dart';
import '../../userlogin/view/user_signup.dart';
import '../../userlogin/widget/usersignin_form.dart';
import '../../forgotpassowrd/view/forgotpassword.dart';
import '../controller/userlogin_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ─── Entrance controller ──────────────────────────────────────────────────
  late AnimationController _masterController;

  // ─── Shimmer for title only ───────────────────────────────────────────────
  late AnimationController _shimmerController;

  // ─── Background blob gentle drift ────────────────────────────────────────
  late AnimationController _bgDriftController;

  // ─── Entrance animations ──────────────────────────────────────────────────
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset>  _logoSlide;
  late Animation<double> _titleFade;
  late Animation<Offset>  _titleSlide;
  late Animation<double> _roleFade;
  late Animation<Offset>  _roleSlide;
  late Animation<double> _cardFade;
  late Animation<Offset>  _cardSlide;
  late Animation<double> _bottomFade;

  // ─── Shimmer value ────────────────────────────────────────────────────────
  late Animation<double> _shimmerValue;
  late Animation<double> _bgDrift;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _bgDriftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    // Logo entrance (0–380ms)
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.38, curve: Curves.elasticOut),
      ),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
      ),
    );

    // Title (200–500ms)
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.15, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Role selector (350–650ms)
    _roleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );
    _roleSlide = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Card (500–850ms)
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.45, 0.78, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.45, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // Bottom (700ms–end)
    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    _shimmerValue = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _bgDrift = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _bgDriftController, curve: Curves.easeInOut),
    );

    _masterController.forward();
  }

  @override
  void dispose() {
    _masterController.dispose();
    _shimmerController.dispose();
    _bgDriftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _roleFade,
                      child: SlideTransition(
                        position: _roleSlide,
                        child: _buildRoleSelector(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _cardFade,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: _buildLoginCard(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _bottomFade,
                      child: Column(
                        children: [
                          _buildForgotPassword(),
                          const SizedBox(height: 32),
                          _buildSignUpSection(),
                        ],
                      ),
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

  // ─── Softly drifting background blobs ────────────────────────────────────
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgDrift,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              top: -60 + _bgDrift.value * 0.4,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00BFA5).withOpacity(0.13),
                      const Color(0xFF009788).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -40 - _bgDrift.value * 0.25,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF009788).withOpacity(0.09),
                      const Color(0xFF00BFA5).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.38 +
                  _bgDrift.value * 0.6,
              right: 20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00BFA5).withOpacity(0.16),
                      const Color(0xFF00BFA5).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo — entrance only, fully static after
        FadeTransition(
          opacity: _logoFade,
          child: SlideTransition(
            position: _logoSlide,
            child: ScaleTransition(
              scale: _logoScale,
              child: _buildStaticLogo(),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Title + shimmer
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Column(
              children: [
                       const Text(
                        "eShoppy",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: -1.2,
                        ),
                      ),

                const SizedBox(height: 8),
                Text(
                  "Welcome! Please login to continue",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── STATIC LOGO — Glossy premium icon, zero continuous animation ─────────
  Widget _buildStaticLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer soft glow ring (static)
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00BFA5).withOpacity(0.08),
          ),
        ),
        // Mid ring
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00BFA5).withOpacity(0.18),
              width: 1.5,
            ),
          ),
        ),
        // Inner ring
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF009788).withOpacity(0.12),
              width: 1.0,
            ),
          ),
        ),
        // Glossy icon box
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00D4B8),
                Color(0xFF009788),
                Color(0xFF006E63),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF009788).withOpacity(0.45),
                blurRadius: 24,
                offset: const Offset(0, 10),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: const Color(0xFF00BFA5).withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glossy top highlight
              Positioned(
                top: 5,
                left: 8,
                right: 8,
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.40),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom inner sheen
              Positioned(
                bottom: 5,
                left: 12,
                right: 12,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.12),
                      ],
                    ),
                  ),
                ),
              ),
              // Icon
              Center(
                child: IconBox(
                  imagePath: 'assets/images/logo/eshoppycatlogo.png',
                  iconColor: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Role selector ────────────────────────────────────────────────────────
  Widget _buildRoleSelector() {
    final controller = Get.find<UserloginController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF009788)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Select Account Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(5),
          child: Obx(() {
            return Row(
              children: controller.roles.entries.map((entry) {
                final role       = entry.value;
                final isSelected = controller.selectedRole.value == role.id;
                final isLast =
                    controller.roles.entries.last.key == entry.key;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setRole(role.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOutCubic,
                      margin: EdgeInsets.only(right: isLast ? 0 : 5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                          colors: [
                            Color(0xFF00C9B1),
                            Color(0xFF009788),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: const Color(0xFF009788)
                                .withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              role.icon,
                              key: ValueKey('${role.id}_$isSelected'),
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            role.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              letterSpacing: isSelected ? 0.2 : 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }

  // ─── Login card ───────────────────────────────────────────────────────────
  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF009788).withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF009788)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: UsersigninForm(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Forgot password ──────────────────────────────────────────────────────
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(
              () => ForgotPasswordEmailView(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
            color: Color(0xFF009688),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF009688),
          ),
        ),
      ),
    );
  }

  // ─── Sign-up section ──────────────────────────────────────────────────────
  Widget _buildSignUpSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _showSignupBottomSheet(Get.context!),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF009788)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => const _SignupBottomSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign-up bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class _SignupBottomSheet extends StatefulWidget {
  const _SignupBottomSheet();

  @override
  State<_SignupBottomSheet> createState() => _SignupBottomSheetState();
}

class _SignupBottomSheetState extends State<_SignupBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _userFade;
  late Animation<Offset>  _userSlide;
  late Animation<double> _merchantFade;
  late Animation<Offset>  _merchantSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _userFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _userSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _merchantFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );
    _merchantSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF009788).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "✦ New to eShoppy?",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF009788),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Create Your Account",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Choose your account type to get started",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: _userFade,
            child: SlideTransition(
              position: _userSlide,
              child: _buildSignupOption(
                title: "User Account",
                subtitle: "Browse and shop for amazing products",
                icon: Icons.person_outline_rounded,
                gradientColors: const [Color(0xFF00C9B1), Color(0xFF009788)],
                badgeText: "Most Popular",
                onTap: () {
                  Get.back();
                  Get.to(
                        () => UserSignup(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 350),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _merchantFade,
            child: SlideTransition(
              position: _merchantSlide,
              child: _buildSignupOption(
                title: "Merchant Account",
                subtitle: "Sell products and grow your business",
                icon: Icons.store_outlined,
                gradientColors: const [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                onTap: () {
                  Get.back();
                  Get.to(
                        () => MerchantRegisterScreen(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 350),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSignupOption({
    required String       title,
    required String       subtitle,
    required IconData     icon,
    required List<Color>  gradientColors,
    required VoidCallback onTap,
    String?               badgeText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: gradientColors[0].withOpacity(0.1),
        highlightColor: gradientColors[0].withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: gradientColors[1].withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[1].withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: gradientColors[0].withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: gradientColors[1],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}