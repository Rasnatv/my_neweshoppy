import 'package:eshoppy/app/modules/userlogin/view/sigin.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  static final GetStorage box = GetStorage();

  /// 🔥 Local logout (clear token + go to login)
  static void logout({String message = "Logged out successfully"}) {
    box.remove('auth_token');
    box.remove('role');
    box.remove('user_data');

    // OR if you want full clear:
    // box.erase();

    Get.offAll(() => LoginScreen());

    Get.snackbar(
      "Logout",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
