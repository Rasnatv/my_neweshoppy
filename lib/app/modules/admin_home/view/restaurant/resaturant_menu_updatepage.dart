
import 'package:entenaadu/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../widget/menuupdating.dart';
import '../widget/tableupdating.dart';
import '../widget/timeupdating.dart';
import 'controller/restaurant_menuupdatecontroller.dart';


/// Main entry point — registers the controller and delegates
/// each tab to its own focused widget file.
class MenuUpdatePage extends StatelessWidget {
  final int restaurantId;
  const MenuUpdatePage({super.key, required this.restaurantId});

  String get _tag => restaurantId.toString();

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: _tag);

  @override
  Widget build(BuildContext context) {
    Get.put(
      RestaurantMenuUpdateController(restaurantId: restaurantId),
      tag: _tag,
    );

    return DefaultTabController(
      length: 3,
      child: NetworkAwareWrapper(
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: _buildAppBar(),
          body: TabBarView(
            children: [
              TablesTab(tag: _tag),
              TimingsTab(tag: _tag),
              MenuTab(tag: _tag),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    automaticallyImplyLeading: true,
    backgroundColor: AppColors.kPrimary,
    elevation: 0,
    title: const Text(
      'Restaurant Menu',
      style: TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
    ),
    actions: [
      Obx(() {
        final loading = c.isLoadingTables.value ||
            c.isLoadingTimings.value ||
            c.isLoadingMenuItems.value;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: loading
              ? const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: Colors.white),
            tooltip: 'Refresh All',
            onPressed: c.fetchAll,
          ),
        );
      }),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: AppColors.kPrimary,
        child: const TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8),
          unselectedLabelStyle:
          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: [
            Tab(
              icon: Icon(Icons.table_restaurant_outlined, size: 18),
              text: 'TABLES',
            ),
            Tab(
              icon: Icon(Icons.schedule_outlined, size: 18),
              text: 'TIMINGS',
            ),
            Tab(
              icon: Icon(Icons.menu_book_outlined, size: 18),
              text: 'MENU',
            ),
          ],
        ),
      ),
    ),
  );
}