
import 'package:get/get.dart';

import '../controller/checkemailotp_controller.dart';

class resetpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckEmailOtpController>(
          () =>CheckEmailOtpController(),
    );
  }
}
