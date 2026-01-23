import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class DeviceUtilits{

  static double getScreenHeight(){
    return MediaQuery.of(Get.context!).size.height;
  }
  static double getScreenWidth(){
    return MediaQuery.of(Get.context!).size.width;
  }
  static double getAppBarHeight(){
    return kToolbarHeight;
  }
  static double getBottomappbarHeight(){
    return kBottomNavigationBarHeight;
  }
}