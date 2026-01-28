
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../myoders/myoders/myodersview.dart';
import '../../profile/view/profile_view.dart';
import '../../userhome/view/userhome.dart';
import '../../whishlist/view/whishlist_view.dart';

class LandingController extends GetxController {
  static LandingController get to => (Get.isRegistered<LandingController>() == false) ? Get.put<LandingController>(LandingController()) : Get.find();

  LandingItem selectedPage = LandingItem.Home;

  void changePage({required LandingItem page}) {
    selectedPage = page;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Widget getPage() {
    switch (selectedPage) {
      case LandingItem.Home:
        return Userhome();
      case LandingItem.Wishlist:
        return WishlistScreen();
    // case LandingItem.filter:
    //   return FilterView();
      case LandingItem.MyOrders:
        return Myodersview();
      case LandingItem.Profile:
        return ProfileView();
    }
  }

  // void onPop() {
  //   if (selectedPage != LandingItem.Home) {
  //     selectedPage = LandingItem.Home;
  //     update();
  //     return;
  //   }
  //   Get.back();
  // }
  void onPop() {
    if (selectedPage != LandingItem.Home) {
      selectedPage = LandingItem.Home;
      update();
    } else {
      Get.back(); // Exit app or go to previous route
    }
  }

}

enum LandingItem { Home, Wishlist, MyOrders, Profile }

