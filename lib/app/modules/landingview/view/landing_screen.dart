
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/landing_controller.dart';
import '../widget/app_nav_bar.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingController());

    // ✅ Read argument and navigate to correct tab after first frame
    final arg = Get.arguments;
    if (arg is LandingItem) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.changePage(page: arg);
      });
    }

    return GetBuilder<LandingController>(
      builder: (controller) {
        return NetworkAwareWrapper(child:Scaffold(
          extendBody: true,
          body: controller.getPage(),
          bottomNavigationBar: const AppNavBar(),
        ));
      },
    );
  }
}
