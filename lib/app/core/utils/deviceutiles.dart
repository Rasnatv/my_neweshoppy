// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
//
//
// class DeviceUtilits{
//
//   static double getScreenHeight(){
//     return MediaQuery.of(Get.context!).size.height;
//   }
//   static double getScreenWidth(){
//     return MediaQuery.of(Get.context!).size.width;
//   }
//   static double getAppBarHeight(){
//     return kToolbarHeight;
//   }
//   static double getBottomappbarHeight(){
//     return kBottomNavigationBarHeight;
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceUtilits {

  static double getScreenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double getScreenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getBottomappbarHeight() {
    return kBottomNavigationBarHeight;
  }

  // Responsive Width
  static double w(double value) {
    return (value / 375) * getScreenWidth();
  }

  // Responsive Height
  static double h(double value) {
    return (value / 812) * getScreenHeight();
  }

  // Responsive Font
  static double sp(double value) {
    double scaleFactor = getScreenWidth() / 375;
    return value * scaleFactor;
  }

  // Tablet Check
  static bool isTablet() {
    return getScreenWidth() >= 600;
  }

  // Mobile Check
  static bool isMobile() {
    return getScreenWidth() < 600;
  }
}