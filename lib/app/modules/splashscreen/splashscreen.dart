
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/style/app_text_style.dart';

import '../../modules/userlogin/view/login.dart';
import '../../modules/landingview/view/landing_screen.dart';
import '../../modules/merchant_home/views/merchant_home.dart';
import '../../modules/admin_home/view/admin_home.dart';
import '../../modules/admin_home/districtadmin/view/districtadmin_home.dart';
import '../../modules/areaadmin/view/area_adminhome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final token = box.read('auth_token');
    final roleRaw = box.read('role');

    final role = roleRaw is int
        ? roleRaw
        : int.tryParse(roleRaw.toString() ?? '');

    final isLoggedIn =
        token != null && token.toString().trim().isNotEmpty;

    if (isLoggedIn && role != null) {
      _navigate(role);
    }
    else {
      Get.offAll(() => const LoginPageView());
    }
  }

  void _navigate(int role) {
    switch (role) {
      case 1:
        Get.offAll(() => LandingView());
        break;
      case 2:
        Get.offAll(() => MerchantDashboardPage());
        break;
      case 3:
        Get.offAll(() => AdminDashboard());
        break;
      case 4:
        Get.offAll(() => Districtadminhomepage());
        break;
      case 5:
        Get.offAll(() => AreaAdminhomepage());
        break;
      default:
        Get.offAll(() => const LoginPageView());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF009788),
              Color(0xFF229C93),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/logo/eshoppylogo.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Buy Smart, Sell Better",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}