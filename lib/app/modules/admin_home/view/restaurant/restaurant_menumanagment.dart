
import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/menutabz.dart';
import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/tabletab.dart';
import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/timingtab.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../admin_home.dart';
import 'controller/restaurant_menuaddingcontroller.dart';


// ─── Main Page ────────────────────────────────────────────────────────────────
class MenuManagementPagezz extends StatelessWidget {
  const MenuManagementPagezz({super.key});

  RestaurantmenuController get c => Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(RestaurantmenuController());
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (tabContext) {
          return NetworkAwareWrapper(
            child: Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: _buildAppBarzz(tabContext),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const TablesTabzz(),
                  const TimingsTabzz(),
                  const MenuTabzz(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBarzz(BuildContext context) => AppBar(
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: AppColors.kPrimary,
    elevation: 0,
    title: const Text(
      'Menu Management',
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
    actions: [
      Obx(() {
        final loading = c.isLoadingPreview.value;
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
            tooltip: 'Refresh',
            onPressed: c.fetchSetupPreview,
          ),
        );
      }),
      IconButton(
        onPressed: () => Get.offAll(() => AdminDashboard()),
        icon: const Icon(Icons.home),
      ),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: AppColors.kPrimary,
        child: Obx(() {
          final hasTable = c.tableTypes.isNotEmpty;
          final hasTiming = c.timeSlots.isNotEmpty;
          return TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8),
            unselectedLabelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500),
            onTap: (index) {
              if (index == 1 && !hasTable) {
                AppSnackbar.warning(
                    'Please add at least one table first');
                DefaultTabController.of(context)?.animateTo(0);
              } else if (index == 2 && !hasTiming) {
                AppSnackbar.warning(
                    'Please add meal timings first');
                DefaultTabController.of(context)
                    ?.animateTo(hasTable ? 1 : 0);
              }
            },
            tabs: [
              const Tab(
                icon: Icon(Icons.table_restaurant_outlined, size: 18),
                text: 'TABLES',
              ),
              Tab(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.schedule_outlined, size: 18),
                    if (!hasTable)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                text: 'TIMINGS',
              ),
              Tab(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 18),
                    if (!hasTiming)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                text: 'MENU',
              ),
            ],
          );
        }),
      ),
    ),
  );
}
