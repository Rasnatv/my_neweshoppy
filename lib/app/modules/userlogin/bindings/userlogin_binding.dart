
import 'package:get/get.dart';
import '../controller/userlogin_controller.dart';

class UserLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserloginController>(
      UserloginController(),
    );
  }
}
