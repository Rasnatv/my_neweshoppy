//
// import 'package:eshoppy/app/widgets/iconbox.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../merchantlogin/view/merchant_registration.dart';
// import '../../userlogin/view/user_signup.dart';
// import '../../userlogin/widget/usersignin_form.dart';
// import '../../forgotpassowrd/view/forgotpassword.dart';
// import '../controller/userlogin_controller.dart';
//
//
// class _T {
//
//   // static const primary      = AppColors.kPrimary;
//   // static const primaryDark  = AppColors.kPrimary;
//   // static const primaryDeep  = AppColors.kPrimary;
//   static const surface      = Color(0xFFFFFFFF);
//   static const bg           = Color(0xFFF5F7F9);
//   static const divider      = Color(0xFFEAEDF1);
//
//   static const ink900 = Color(0xFF0D1117);
//   static const ink600 = Color(0xFF4B5563);
//   static const ink400 = Color(0xFF9CA3AF);
//
//   // Elevation shadows
//   static List<BoxShadow> cardShadow = [
//     BoxShadow(
//       color: Colors.black.withOpacity(0.06),
//       blurRadius: 24,
//       offset: const Offset(0, 8),
//       spreadRadius: -4,
//     ),
//     BoxShadow(
//       color: Colors.black.withOpacity(0.03),
//       blurRadius: 8,
//       offset: const Offset(0, 2),
//     ),
//   ];
//
//   static List<BoxShadow> primaryShadow = [
//     BoxShadow(
//       color: AppColors.kPrimary,
//       blurRadius: 20,
//       offset: const Offset(0, 8),
//       spreadRadius: -4,
//     ),
//   ];
// }
//
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//
//   late final AnimationController _enter;
//   late final List<Animation<double>> _fades;
//   late final List<Animation<Offset>>  _slides;
//
//   // 5 staggered sections: logo, title, role, card, bottom
//   static const _count = 5;
//   static const _delays = [0.00, 0.12, 0.28, 0.42, 0.58];
//   static const _ends   = [0.30, 0.40, 0.56, 0.72, 0.90];
//
//   @override
//   void initState() {
//     super.initState();
//     _enter = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//
//     _fades  = List.generate(_count, (i) =>
//         Tween<double>(begin: 0, end: 1).animate(
//           CurvedAnimation(
//             parent: _enter,
//             curve: Interval(_delays[i], _ends[i], curve: Curves.easeOut),
//           ),
//         ),
//     );
//
//     _slides = List.generate(_count, (i) {
//       final offsets = [
//         const Offset(0, -0.4),  // logo   – drops in from top
//         const Offset(0,  0.3),  // title  – rises from below
//         const Offset(0.2, 0),   // role   – slides from right
//         const Offset(0,  0.35), // card   – rises from below
//         const Offset(0,  0.2),  // bottom – gentle rise
//       ];
//       return Tween<Offset>(begin: offsets[i], end: Offset.zero).animate(
//         CurvedAnimation(
//           parent: _enter,
//           curve: Interval(_delays[i], _ends[i], curve: Curves.easeOutCubic),
//         ),
//       );
//     });
//
//     _enter.forward();
//   }
//
//   @override
//   void dispose() {
//     _enter.dispose();
//     super.dispose();
//   }
//
//   Widget _reveal(int i, Widget child) => FadeTransition(
//     opacity: _fades[i],
//     child: SlideTransition(position: _slides[i], child: child),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // ── Solid background tinted with kPrimary at very low opacity ──
//         color: AppColors.kPrimary.withOpacity(0.03),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _reveal(0, _buildLogo()),
//                   const SizedBox(height: 32),
//                   _reveal(1, _buildTitleBlock()),
//                   const SizedBox(height: 40),
//                   _reveal(2, _buildRoleSelector()),
//                   const SizedBox(height: 24),
//                   _reveal(3, _buildLoginCard()),
//                   const SizedBox(height: 16),
//                   _reveal(4, Column(
//                     children: [
//                       _buildForgotPassword(),
//                       const SizedBox(height: 28),
//                       _buildSignUpSection(),
//                     ],
//                   )),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ─── Logo ─────────────────────────────────────────────────────────────────
//   Widget _buildLogo() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(28),
//       child: Container(
//         width: 88,
//         height: 88,
//         color: Colors.teal,
//         child: Padding(
//           padding: const EdgeInsets.all(12), // controls image size — increase to shrink
//           child: Center(child:Image.asset(
//             'assets/images/logo/eshoppycatlogo.png',
//             fit: BoxFit.contain,
//           )),
//         ),
//       ),
//     );
//   }
//
//   // ─── Title block ──────────────────────────────────────────────────────────
//   Widget _buildTitleBlock() {
//     return Column(
//       children: [
//         const Text(
//           "eShoppy",
//           style: TextStyle(
//             fontSize: 34,
//             fontWeight: FontWeight.w800,
//             color: _T.ink900,
//             letterSpacing: -1.5,
//             height: 1.1,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Sign in to your account",
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//             color: _T.ink400,
//             letterSpacing: 0.1,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ─── Role selector ────────────────────────────────────────────────────────
//   Widget _buildRoleSelector() {
//     final controller = Get.find<UserloginController>();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 2, bottom: 12),
//           child: Text(
//             "Account type",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: _T.ink400,
//               letterSpacing: 0.8,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: _T.surface,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _T.divider, width: 1),
//             boxShadow: _T.cardShadow,
//           ),
//           padding: const EdgeInsets.all(4),
//           child: Obx(() {
//             return Row(
//               children: controller.roles.entries.map((entry) {
//                 final role       = entry.value;
//                 final isSelected = controller.selectedRole.value == role.id;
//                 final isLast     = controller.roles.entries.last.key == entry.key;
//
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () => controller.setRole(role.id),
//                     child: Container(
//                       margin: EdgeInsets.only(right: isLast ? 0 : 4),
//                       padding: const EdgeInsets.symmetric(vertical: 13),
//                       decoration: BoxDecoration(
//                         color: isSelected ? AppColors.kPrimary : Colors.transparent,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: isSelected
//                             ? [
//                           BoxShadow(
//                             color: AppColors.kPrimary.withOpacity(0.30),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ]
//                             : null,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             role.icon,
//                             size: 17,
//                             color: isSelected ? Colors.white : _T.ink400,
//                           ),
//                           const SizedBox(width: 7),
//                           Text(
//                             role.name,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//                               color: isSelected ? Colors.white : _T.ink400,
//                               letterSpacing: isSelected ? 0.1 : 0,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   // ─── Login card ───────────────────────────────────────────────────────────
//   Widget _buildLoginCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: _T.surface,
//         borderRadius: BorderRadius.circular(24),
//         //border: Border.all(color: _T.divider, width: 1),
//         boxShadow: _T.cardShadow,
//       ),
//       child: Column(
//         children: [
//
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
//             child: UsersigninForm(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── Forgot password ──────────────────────────────────────────────────────
//   Widget _buildForgotPassword() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: TextButton(
//         onPressed: () => Get.to(
//               () => ForgotPasswordEmailView(),
//           transition: Transition.fadeIn,
//           duration: const Duration(milliseconds: 280),
//         ),
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//           minimumSize: Size.zero,
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         child: const Text(
//           "Forgot password?",
//           style: TextStyle(
//             color: Colors.teal,         // ← was _T.primaryDark
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ─── Sign-up section ──────────────────────────────────────────────────────
//   Widget _buildSignUpSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: _T.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _T.divider, width: 1),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Don't have an account?",
//             style: TextStyle(
//               color: _T.ink600,
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () => _showSignupBottomSheet(Get.context!),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//               decoration: BoxDecoration(
//                 color: AppColors.kPrimary,     // ← was gradient
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.kPrimary.withOpacity(0.30),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Text(
//                 "Sign Up",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSignupBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       transitionAnimationController: AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 380),
//       ),
//       builder: (_) => const _SignupBottomSheet(),
//     );
//   }
// }
//
//
// class _SignupBottomSheet extends StatefulWidget {
//   const _SignupBottomSheet();
//
//   @override
//   State<_SignupBottomSheet> createState() => _SignupBottomSheetState();
// }
//
// class _SignupBottomSheetState extends State<_SignupBottomSheet>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _userFade;
//   late Animation<Offset>  _userSlide;
//   late Animation<double> _merchantFade;
//   late Animation<Offset>  _merchantSlide;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _userFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _ctrl,
//           curve: const Interval(0.1, 0.6, curve: Curves.easeOut)),
//     );
//     _userSlide = Tween<Offset>(
//       begin: const Offset(0, 0.25), end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _ctrl,
//         curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic)));
//
//     _merchantFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _ctrl,
//           curve: const Interval(0.3, 0.85, curve: Curves.easeOut)),
//     );
//     _merchantSlide = Tween<Offset>(
//       begin: const Offset(0, 0.25), end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _ctrl,
//         curve: const Interval(0.3, 0.85, curve: Curves.easeOutCubic)));
//
//     _ctrl.forward();
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: _T.surface,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       padding: EdgeInsets.fromLTRB(
//         24, 20, 24,
//         MediaQuery.of(context).viewInsets.bottom + 32,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle bar
//           Container(
//             width: 40, height: 4,
//             decoration: BoxDecoration(
//               color: _T.divider,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 28),
//
//           // Header
//           Row(
//             children: [
//               Container(
//                 width: 42, height: 42,
//                 decoration: BoxDecoration(
//                   color: AppColors.kPrimary,   // ← was gradient
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.person_add_outlined,
//                     color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 14),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Create Account",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w800,
//                       color: _T.ink900,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//                   Text(
//                     "Choose your account type",
//                     style: TextStyle(fontSize: 13, color: _T.ink400),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 8),
//           Divider(color: _T.divider, height: 32),
//
//           FadeTransition(
//             opacity: _userFade,
//             child: SlideTransition(
//               position: _userSlide,
//               child: _buildSignupOption(
//                 title: "User Account",
//                 subtitle: "Browse and shop for amazing products",
//                 icon: Icons.person_outline_rounded,
//                 color: AppColors.kPrimary,     // ← was _T.primary
//                 badgeText: "Popular",
//                 onTap: () {
//                   Get.back();
//                   Get.to(() => UserSignup(),
//                       transition: Transition.rightToLeft,
//                       duration: const Duration(milliseconds: 320));
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           FadeTransition(
//             opacity: _merchantFade,
//             child: SlideTransition(
//               position: _merchantSlide,
//               child: _buildSignupOption(
//                 title: "Merchant Account",
//                 subtitle: "Sell products and grow your business",
//                 icon: Icons.store_outlined,
//                 color: const Color(0xFF7C4DFF),
//                 onTap: () {
//                   Get.back();
//                   Get.to(() => MerchantRegisterScreen(),
//                       transition: Transition.rightToLeft,
//                       duration: const Duration(milliseconds: 320));
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSignupOption({
//     required String       title,
//     required String       subtitle,
//     required IconData     icon,
//     required Color        color,
//     required VoidCallback onTap,
//     String?               badgeText,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         splashColor: color.withOpacity(0.08),
//         highlightColor: color.withOpacity(0.04),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: _T.surface,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _T.divider, width: 1),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.06),
//                 blurRadius: 16,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 52, height: 52,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: _T.ink900,
//                           ),
//                         ),
//                         if (badgeText != null) ...[
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 7, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: color.withOpacity(0.10),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               badgeText,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                                 color: color,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 12, color: _T.ink400),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Icon(Icons.arrow_forward_ios_rounded,
//                   size: 14, color: _T.ink400),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../merchantlogin/view/merchant_registration.dart';
import '../../userlogin/view/user_signup.dart';
import '../../userlogin/widget/usersignin_form.dart';
import '../../forgotpassowrd/view/forgotpassword.dart';
import '../controller/userlogin_controller.dart';

// ─── Design tokens (mirrors AdminLoginScreen) ─────────────────────────────────
class _T {
  static const surface = Color(0xFFFFFFFF);
  static const bg      = Color(0xFFF5F7F9);
  static const divider = Color(0xFFEAEDF1);

  static const ink900 = Color(0xFF0D1117);
  static const ink600 = Color(0xFF4B5563);
  static const ink400 = Color(0xFF9CA3AF);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> accentShadow(Color c) => [
    BoxShadow(
      color: c.withOpacity(0.32),
      blurRadius: 18,
      offset: const Offset(0, 6),
      spreadRadius: -3,
    ),
  ];
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  // ── Stagger animation ─────────────────────────────────────────────────────
  late final AnimationController _enter;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>>  _slides;

  static const _count  = 5;
  static const _delays = [0.00, 0.12, 0.28, 0.42, 0.58];
  static const _ends   = [0.30, 0.40, 0.56, 0.72, 0.90];

  @override
  void initState() {
    super.initState();

    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fades = List.generate(
      _count,
          (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _enter,
          curve: Interval(_delays[i], _ends[i], curve: Curves.easeOut),
        ),
      ),
    );

    final offsets = [
      const Offset(0, -0.4),  // badge   – drops from top
      const Offset(0,  0.3),  // title   – rises from below
      const Offset(-0.2, 0),  // selector – slides from left
      const Offset(0,  0.35), // card    – rises from below
      const Offset(0,  0.2),  // bottom  – gentle rise
    ];
    _slides = List.generate(
      _count,
          (i) => Tween<Offset>(begin: offsets[i], end: Offset.zero).animate(
        CurvedAnimation(
          parent: _enter,
          curve: Interval(_delays[i], _ends[i], curve: Curves.easeOutCubic),
        ),
      ),
    );

    _enter.forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  Widget _reveal(int i, Widget child) => FadeTransition(
    opacity: _fades[i],
    child: SlideTransition(position: _slides[i], child: child),
  );

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.kPrimary.withOpacity(0.04),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _reveal(0, _buildBadge()),
                  const SizedBox(height: 32),
                  _reveal(1, _buildTitleBlock()),
                  const SizedBox(height: 40),
                  _reveal(2, _buildRoleSelector()),
                  const SizedBox(height: 24),
                  _reveal(3, _buildLoginCard()),
                  const SizedBox(height: 16),
                  _reveal(4, Column(
                    children: [
                      _buildForgotPassword(),
                      const SizedBox(height: 28),
                      _buildSignUpSection(),
                    ],
                  )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Badge ────────────────────────────────────────────────────────────────
  Widget _buildBadge() {
    // return Container(
    //   width: 88,
    //   height: 88,
    //   decoration: BoxDecoration(
    //     color: AppColors.kPrimary,
    //     borderRadius: BorderRadius.circular(28),
    //     boxShadow: _T.accentShadow(AppColors.kPrimary),
    //   ),
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       Positioned.fill(
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(28),
    //           child: CustomPaint(painter: _RingPainter(AppColors.kPrimary)),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(14),
    //         child: Image.asset(
    //           'assets/images/logo/eshoppycatlogo.png',
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: _T.accentShadow(AppColors.kPrimary),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(painter: _RingPainter(AppColors.kPrimary)),
            ),
          ),
          SizedBox(
          width: 52,
          height: 52,
    child: Center(
    child: Image.asset(
    'assets/images/logo/eshoppycatlogo.png',
    fit: BoxFit.contain,
    ),
    ),
    )
        ],
      ),
    );
  }

  // ─── Title block ──────────────────────────────────────────────────────────
  Widget _buildTitleBlock() {
    return Column(
      children: [
        const Text(
          "eShoppy",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: _T.ink900,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Sign in to your account",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: _T.ink400,
            letterSpacing: 0.1,
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
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 12),
          child: Text(
            "ACCOUNT TYPE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _T.ink400,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _T.divider, width: 1),
            boxShadow: _T.cardShadow,
          ),
          padding: const EdgeInsets.all(4),
          child: Obx(() {
            return Row(
              children: controller.roles.entries.map((entry) {
                final role       = entry.value;
                final isSelected = controller.selectedRole.value == role.id;
                final isLast     = controller.roles.entries.last.key == entry.key;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setRole(role.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.only(right: isLast ? 0 : 4),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.kPrimary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color:
                            AppColors.kPrimary.withOpacity(0.30),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            role.icon,
                            size: 17,
                            color:
                            isSelected ? Colors.white : _T.ink400,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            role.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : _T.ink400,
                              letterSpacing: isSelected ? 0.1 : 0,
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
        color: _T.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: _T.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: UsersigninForm(),
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
          duration: const Duration(milliseconds: 280),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          "Forgot password?",
          style: TextStyle(
            color: AppColors.kPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
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
        color: _T.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.divider, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: _T.ink600,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showSignupBottomSheet(Get.context!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.kPrimary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: _T.accentShadow(AppColors.kPrimary),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
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
        duration: const Duration(milliseconds: 380),
      ),
      builder: (_) => const _SignupBottomSheet(),
    );
  }
}

// ─── Signup bottom sheet ──────────────────────────────────────────────────────
class _SignupBottomSheet extends StatefulWidget {
  const _SignupBottomSheet();

  @override
  State<_SignupBottomSheet> createState() => _SignupBottomSheetState();
}

class _SignupBottomSheetState extends State<_SignupBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _userFade;
  late Animation<Offset>  _userSlide;
  late Animation<double> _merchantFade;
  late Animation<Offset>  _merchantSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _userFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.1, 0.6, curve: Curves.easeOut)),
    );
    _userSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic)));

    _merchantFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.3, 0.85, curve: Curves.easeOut)),
    );
    _merchantSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 0.85, curve: Curves.easeOutCubic)));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _T.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),

          // Header
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _T.accentShadow(AppColors.kPrimary),
                ),
                child: const Icon(Icons.person_add_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _T.ink900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Choose your account type",
                    style: TextStyle(fontSize: 13, color: _T.ink400),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),
          Divider(color: _T.divider, height: 32),

          FadeTransition(
            opacity: _userFade,
            child: SlideTransition(
              position: _userSlide,
              child: _buildSignupOption(
                title: "User Account",
                subtitle: "Browse and shop for amazing products",
                icon: Icons.person_outline_rounded,
                color: AppColors.kPrimary,
                badgeText: "Popular",
                onTap: () {
                  Get.back();
                  Get.to(
                        () => UserSignup(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 320),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _merchantFade,
            child: SlideTransition(
              position: _merchantSlide,
              child: _buildSignupOption(
                title: "Merchant Account",
                subtitle: "Sell products and grow your business",
                icon: Icons.store_outlined,
                color: const Color(0xFF7C4DFF),
                onTap: () {
                  Get.back();
                  Get.to(
                        () => MerchantRegisterScreen(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 320),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSignupOption({
    required String       title,
    required String       subtitle,
    required IconData     icon,
    required Color        color,
    required VoidCallback onTap,
    String?               badgeText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.08),
        highlightColor: color.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _T.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _T.ink900,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: _T.ink400),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: _T.ink400),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ring painter (same as AdminLoginScreen) ──────────────────────────────────
class _RingPainter extends CustomPainter {
  final Color color;
  const _RingPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = Colors.white.withOpacity(0.10)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final cx = size.width / 2;
    final cy = size.height / 2;
    for (final r in [
      size.width * 0.55,
      size.width * 0.75,
      size.width * 0.95,
    ]) {
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.color != color;
}