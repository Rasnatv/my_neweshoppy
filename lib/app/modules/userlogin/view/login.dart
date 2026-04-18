
import 'package:eshoppy/app/modules/userlogin/view/sigin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/networkconnection_checkpage.dart';
import '../controller/userlogin_controller.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {

  @override
  void initState() {
    super.initState();
    // ✅ Delete any stale instance first, then put fresh one
    Get.delete<UserloginController>(force: true);
    Get.put(UserloginController(), permanent: false);
  }

  @override
  void dispose() {
    Get.delete<UserloginController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
