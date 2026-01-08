
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/deviceutiles.dart';

class DCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DCustomAppBar({
    super.key,
    this.title,
    this.showbackarrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingonpressed,
    this.background = Colors.white,
  });

  final Widget? title;
  final bool showbackarrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingonpressed;
  final Color background;   // ✔ FIXED

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AppBar(
        backgroundColor: background,   // ✔ works now
        automaticallyImplyLeading: false,
        leading: showbackarrow
            ? IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        )
            : leadingIcon != null
            ? IconButton(
          onPressed: leadingonpressed,
          icon: Icon(leadingIcon),
        )
            : null,
        title: title,
        centerTitle: false,
        actions: actions,
        scrolledUnderElevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(DeviceUtilits.getAppBarHeight());
}
