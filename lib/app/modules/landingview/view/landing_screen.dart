//
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/landing_controller.dart';
import '../widget/app_nav_bar.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is created
    Get.put(LandingController());

    return GetBuilder<LandingController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: controller.getPage(),  // NOT reactive → fine for GetBuilder
          bottomNavigationBar: const AppNavBar(),
        );
      },
    );
  }
}
