
import 'package:eshoppy/app/modules/admin_home/view/restaurant/admin_Restauranthome.dart';
import 'package:eshoppy/app/modules/admin_home/view/restaurant/admin_merchanthome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../core/utils/auth_service.dart';
import '../admin_shoppage.dart';
import '../controller/admin_dashboardcontroller.dart';
import '../event/view/admin_event.dart';
import '../categories/views/Admin_catgorypage.dart';
import '../locations/views/admin_locationmanagement.dart';
import '../offer/views/AdminView_offerpage.dart';
import '../users/views/admin_registereduserlist.dart';
import '../banners/views/adminadvertisment.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Admin Dashboard",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        actions: [
          // Refresh button
          Obx(() => controller.isLoading.value
              ? const Padding(
            padding: EdgeInsets.all(14),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.fetchDashboardCounts,
          )),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildQuickStats(controller), // 👈 Pass controller
            const SizedBox(height: 24),
            _buildSectionHeader("Management Menu"),
            const SizedBox(height: 12),
            _buildMenuGrid(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildLogoutButton(),
    );
  }

  // ----------- Welcome Card -----------
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kPrimary,
            AppColors.kPrimary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome !",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage your platform efficiently",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------- Quick Stats (now uses controller) -----------
  Widget _buildQuickStats(AdminDashboardController controller) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.store_outlined,
            value: controller.totalMerchants.value,
            label: "Merchants",
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.people_outline,
            value: controller.totalUsers.value,
            label: "Users",
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.shopping_bag_outlined,
            value: controller.totalProducts.value,
            label: "Products",
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    ));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ----------- Section Header -----------
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2D3748),
      ),
    );
  }

  // ----------- Menu Grid -----------
  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      MenuItemData(
        icon: Icons.store_rounded,
        title: "Merchants",
        subtitle: "Manage merchants",
        color: const Color(0xFF6366F1),
        onTap: () => Get.to(() => AdminMerchantHomePageUI()),
      ),
      MenuItemData(
        icon: Icons.category_rounded,
        title: "Categories",
        subtitle: "Products & categories",
        color: const Color(0xFF8B5CF6),
        onTap: () => Get.to(() => AddCategoryPage()),
      ),
      MenuItemData(
        icon: Icons.event_rounded,
        title: "Events",
        subtitle: "Manage events",
        color: const Color(0xFFEC4899),
        onTap: () => Get.to(() => AdminEventPage()),
      ),
      MenuItemData(
        icon: Icons.flag_rounded,
        title: "Banners",
        subtitle: "Advertisement banners",
        color: const Color(0xFFF59E0B),
        onTap: () => Get.to(() => AdminAdvertisementPage()),
      ),
      MenuItemData(
        icon: Icons.people_rounded,
        title: "Users",
        subtitle: "Registered users",
        color: const Color(0xFF10B981),
        onTap: () => Get.to(() => AdminUserListPage()),
      ),
      MenuItemData(
        icon: Icons.restaurant_rounded,
        title: "Restaurant",
        subtitle: "Manage restaurants",
        color: const Color(0xFFEF4444),
        onTap: () => Get.to(() => AdminRestauranthome()),
      ),
      MenuItemData(
        icon: Icons.shopping_bag_rounded,
        title: "Shop",
        subtitle: "Manage shops",
        color: const Color(0xFF3B82F6),
        onTap: () => Get.to(() => AdminShopPage()),
      ),
      MenuItemData(
        icon: Icons.location_on_rounded,
        title: "Locations",
        subtitle: "State/District/Area",
        color: const Color(0xFF06B6D4),
        onTap: () => Get.to(() => AdminAddLocationPage()),
      ),
      MenuItemData(
        icon: Icons.local_offer_rounded,
        title: "Offers",
        subtitle: "Merchant offers",
        color: const Color(0xFFF97316),
        onTap: () =>Get.to(()=>OffersListingScreen()),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _buildMenuItem(menuItems[index]);
      },
    );
  }

  Widget _buildMenuItem(MenuItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: item.color, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => AuthService.showLogoutDialog(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                "Logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------- Menu Item Data Model -----------
class MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}