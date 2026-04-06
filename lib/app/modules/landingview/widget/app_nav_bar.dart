
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/app_icons.dart';
import '../../../common/style/app_colors.dart';
import '../controller/landing_controller.dart';
import 'app_nav_item.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.shimmerGray, width: 2.sp))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppNavItem(
              value: LandingItem.Home,
              iconPath: "assets/images/icons/ic_home.svg",
              label: "Home",
            ),
            AppNavItem(
              value: LandingItem.Wishlist,
              iconPath: "assets/images/icons/ic_wishlist.svg",
              label: "Wishlist",
            ),
            AppNavItem(
              value: LandingItem.MyOrders,
              iconPath: "assets/images/icons/ic_cart.svg",
              label: "My Orders",
            ),
            AppNavItem(
              value: LandingItem.Profile,
              iconPath: "assets/images/icons/ic_profile.svg",
              label: "Profile",
            ),

          ],
        ),
      ),
    );
  }
}
