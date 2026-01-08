
import 'package:get/get.dart';

import '../controller/userlogin_controller.dart';
class UserloginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserloginController>(
          () => UserloginController(),
    );
  }
}
