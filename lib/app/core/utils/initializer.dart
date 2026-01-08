//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../controllers/auth_controller.dart';
//
// abstract class Initializer {
//   static void init(VoidCallback runApp) {
//     runZonedGuarded(() async {
//       WidgetsFlutterBinding.ensureInitialized();
//       await GetStorage.init();
//       FlutterError.onError = (details) {
//         FlutterError.dumpErrorToConsole(details);
//         Get.printInfo(info: details.stack.toString());
//       };
//       await _initScreenPreference();
//       runApp();
//     }, (error, stack) {
//       Get.printInfo(info: 'runZonedGuarded Error: $error\n$stack');
//     });
//   }
//
//   static Future<void> _initScreenPreference() async {
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
//     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   }
// }
//
// class InitialBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(AuthController(), permanent: true);
//   }
// }
