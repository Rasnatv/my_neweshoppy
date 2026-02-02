//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/constants/text_String.dart';
// import '../../../widgets/headline.dart';
// import '../../userlogin/view/sigin.dart';
// import '../widget/merchant_regform.dart';
//
// class MerchantRegisterScreen extends StatelessWidget {
//   const MerchantRegisterScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           // 🌈 Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/products/newbackground.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // 🌑 Dark overlay
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.40),
//                   Colors.black.withOpacity(0.30),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _glassCircleIcon(
//                       icon: Icons.storefront_rounded,
//                       size: 52,
//                     ),
//                     const SizedBox(height: 12),
//                     Headline(
//                       head1: AppTexts.Title4,
//                       head2: AppTexts.Title5,
//                     ),
//                     const SizedBox(height: 25),
//                     _glassContainer(
//                       blur: 20,
//                       padding: const EdgeInsets.all(24),
//                       child: MerchantRegform(),
//                     ),
//
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Already have an account?",
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         TextButton(
//                           onPressed: () =>
//                               Get.to(() => const LoginScreen(),),
//                           child: const Text(
//                             "Login Here",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🔵 Glassmorphism Circular Icon
//   Widget _glassCircleIcon({
//     required IconData icon,
//     double size = 48,
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(100),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           height: 100,
//           width: 100,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white.withOpacity(0.18),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.35),
//               width: 1.5,
//             ),
//           ),
//           child: Icon(
//             icon,
//             size: size,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _glassContainer({
//     required Widget child,
//     double blur = 10,
//     EdgeInsets padding = const EdgeInsets.all(16),
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(22),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//         child: Container(
//           padding: padding,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.17),
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.3),
//             ),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
//
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/text_String.dart';
import '../../../widgets/headline.dart';
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
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
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
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          _buildFloatingShapes(),
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
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildFloatingShapes() {
    return Stack(
      children: [
        // Animated floating shape 1
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: 100 + (_floatController.value * 30),
              right: -50,
              child: Transform.rotate(
                angle: _floatController.value * math.pi / 4,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF009788).withOpacity(0.15),
                        const Color(0xFF009788).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
            );
          },
        ),
        // Animated floating shape 2
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              bottom: 150 - (_floatController.value * 40),
              left: -80,
              child: Transform.rotate(
                angle: -_floatController.value * math.pi / 3,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF26A69A).withOpacity(0.12),
                        const Color(0xFF26A69A).withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
              ),
            );
          },
        ),
        // Static decorative element
        Positioned(
          top: 50,
          left: 40,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF80CBC4).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_rounded),
        color: const Color(0xFF212121),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF009788),
                Color(0xFF00796B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF009788).withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
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
        Text(
          "Create your merchant account",
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF757575),
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
          Text(
            "Already have an account?",
            style: TextStyle(
              color: const Color(0xFF616161),
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