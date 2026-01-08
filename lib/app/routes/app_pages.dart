
import 'package:get/get.dart';
import '../modules/forgotpassowrd/binding/forgotpswd_binding.dart';
import '../modules/forgotpassowrd/binding/newpswd_bindings.dart';
import '../modules/forgotpassowrd/view/forgotpassword.dart';
import '../modules/forgotpassowrd/view/newpasswordscreen.dart';

import '../modules/splashscreen/splashscreen.dart';
import '../modules/userhome/view/userhome.dart';
import '../modules/userlogin/bindings/userlogin_binding.dart';
import '../modules/userlogin/bindings/usersignup_bindings.dart';
import '../modules/userlogin/view/sigin.dart';
import '../modules/userlogin/view/user_signup.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // GetPage(
    //   name: _Paths.ADMINLOGIN,
    //   page: () => AdminLoginPage()
    //   //binding: AdminloginBindings(),
    // ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => AnimatedSplash(),
      //binding: AdminloginBindings(),
    ),


    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      binding:UserloginBindings(),
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
    // GetPage(
    //   name: _Paths.SALESREGISTER,
    //   page: () =>  SalesRegisterForm(),
    //    binding: SalesegisterBindings (),
    // ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => UserSignup(),
      binding: UsersignupBindings(),
    ),
    //
    GetPage(
      name: _Paths.USERHOME,
      page: () =>  Userhome(),
      //binding: CartBinding(),
    ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () =>  ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CATEGORYS,
    //   page: () => CategoriesScreen(),
    //     binding: CategoryBinding()
    // ),
  ];
}
