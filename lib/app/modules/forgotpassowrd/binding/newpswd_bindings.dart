
import 'package:get/get.dart';

import '../controller/newpswd_controller.dart';

class NewpswdBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPasswordController>(
          () => NewPasswordController(),
    );
  }
}
