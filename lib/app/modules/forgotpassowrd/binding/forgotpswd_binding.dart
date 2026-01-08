

import 'package:get/get.dart';

import '../controller/forgotpswd_controller.dart';

class ForgotpswdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
          () => ForgotPasswordController(),
    );
  }
}
