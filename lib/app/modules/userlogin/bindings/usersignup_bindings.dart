
import 'package:get/get.dart';

import '../controller/usersignup_controller.dart';
class UsersignupBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersignupController>(
          () => UsersignupController(),
    );
  }
}
