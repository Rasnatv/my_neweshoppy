


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'app/common/style/app_theme.dart';
import 'app/modules/product/controller/cartcontroller.dart';
import 'app/modules/userhome/controller/district _controller.dart';
import 'app/modules/userhome/controller/promotionbanner_controller.dart';
import 'app/routes/app_pages.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize local storage
  await GetStorage.init();

  // ✅ Inject CartController globally
  Get.put(CartController(), permanent: true);
  //Get.put(UserDistrictController(), permanent: true);
  Get.lazyPut(() => PromotionController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // standard mobile base size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.themeData,
          initialRoute: Routes.LOGIN,
          getPages: AppPages.routes,
          // home: child,
        );
      },
      // child: const LoginScreen(),
    );
  }
}
