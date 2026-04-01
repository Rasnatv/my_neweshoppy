
import 'package:eshoppy/app/modules/profile/view/profile_view.dart';
import 'package:get/get.dart';
import '../modules/admin_home/banners/views/adminadvertisment.dart';
import '../modules/admin_home/districtadmin/view/districtadmin_advertismentupdatepage.dart';
import '../modules/admin_home/districtadmin/view/districtadmin_home.dart';
import '../modules/admin_home/offer/views/Admin_productdetailscreen.dart';
import '../modules/admin_home/offer/views/admin_viewofferproduct.dart';
import '../modules/forgotpassowrd/binding/checkemailotp_binding.dart';
import '../modules/forgotpassowrd/binding/forgotpswd_binding.dart';
import '../modules/forgotpassowrd/binding/newpswd_bindings.dart';
import '../modules/forgotpassowrd/view/checkemail.dart';
import '../modules/forgotpassowrd/view/forgotpassword.dart';
import '../modules/forgotpassowrd/view/newpasswordscreen.dart';

import '../modules/splashscreen/splashscreen.dart';
import '../modules/userhome/view/userhome.dart';
import '../modules/userlogin/bindings/editprofile_binding.dart';
import '../modules/userlogin/bindings/userlogin_binding.dart';
import '../modules/userlogin/bindings/usersignup_bindings.dart';
import '../modules/userlogin/view/sigin.dart';
import '../modules/userlogin/view/user_signup.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // GetPage(
    //   name: _Paths.ADMINLOGIN,
    //   page: () => AdminLoginPage()
    //   //binding: AdminloginBindings(),
    // ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
      //binding: AdminloginBindings(),
    ),


    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: UserLoginBinding (),
    ),

    GetPage(
      name: _Paths.FORGOTPSWD,
      page: () =>ForgotPasswordEmailView(),
     binding:ForgotpswdBinding(),
    ),

    GetPage(
      name: _Paths.NewPSWD,
      page: () => SetNewPasswordView(),
      binding: NewpswdBindings(),
     // bindings: [HomeBinding(),WishlistBinding()]
    ),
    GetPage(
      name: _Paths.DISTRICTADMINADVUPDATION,
      page: () =>   DistrictAdvertisementUpdatePage(),

    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => UserSignup(),
      binding: UsersignupBindings(),
    ),
    GetPage(
      name: Routes.CHECKEMAIL,
      page: () => const CheckemailScreen(),
      binding: CheckEmailBinding(),
    ),

    //
    GetPage(
      name: _Paths.USERHOME,
      page: () =>  Userhome(),
      //binding: CartBinding(),
    ),
    // In your GetPages / AppPages:
    GetPage(
      name: '/offer-products',
      page: () => const AdminOfferProductScreen(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut(() => OfferProductsController());
      //}),
    ),
    GetPage(
      name: '/offer-product-detail',
      page: () => const AdminSingleOfferProductScreen(),
    ),
    GetPage(
      name: '/adminadvertismentupdation',
      page: () =>  AdminAdvertisementPage(),
    ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () =>  ProfileView(),
    //   binding: EditprofileBinding(),
    // ),
    GetPage(
      name: _Paths.DISTRICTADMINHOME,
      page: () => Districtadminhomepage())];
}
