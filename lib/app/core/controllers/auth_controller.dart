import 'package:eshoppy/app/modules/userlogin/view/sigin.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modules/admin_home/view/admin_home.dart';
import '../../modules/landingview/view/landing_screen.dart';
import '../../modules/merchant_home/views/merchant_home.dart';


class AuthCheckController extends GetxController {
  final box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = box.read('auth_token');
    final isLoggedIn = box.read('is_logged_in') ?? false;
    final roleRaw = box.read('role');
    final int? role = roleRaw is int ? roleRaw : int.tryParse(roleRaw?.toString() ?? '');

    if (isLoggedIn && token != null && token.isNotEmpty && role != null) {
      _navigateByRole(role);
    } else {
      _forceLogout();
    }
  }
  void _forceLogout() {
    box.remove('auth_token');
    box.remove('is_logged_in');
    box.remove('role');
    Get.offAllNamed('/login');
  }
  void _navigateByRole(int role) {
    switch (role) {
      case 1:
        Get.offAll(() => LandingView());
        break;
      case 2:
        Get.offAll(() => MerchantDashboardPage());
        break;
      case 3:
        Get.offAll(() => AdminDashboard());
        break;
      default:
        Get.offAll(() => LoginScreen());
    }
  }
}
