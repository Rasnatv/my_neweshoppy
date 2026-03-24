import 'package:eshoppy/app/modules/userlogin/view/sigin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/userlogin_controller.dart';
import 'admin_loginpage.dart';


class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserloginController());

    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: const [
          AdminLoginScreen(), // page 0 — swipe left to reach
          LoginScreen(),      // page 1 — opens first
        ],
      ),
    );
  }
}