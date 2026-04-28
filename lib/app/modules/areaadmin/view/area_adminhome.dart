

import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../common/style/app_colors.dart';
import '../../../core/utils/auth_service.dart';
import '../controller/areaadmin_dashboardcountcnroller.dart';

import '../widget/areaadmin_getting_advertismentsection.dart';
import '../widget/eventwidget.dart';
import 'alladvertismentpage.dart';
import 'alleeventspage.dart';
import 'areawise_advertisment.dart';
import 'areawiseeventpage.dart';

class AreaAdminhomepage extends StatelessWidget {
  AreaAdminhomepage({super.key});
  final AreaAdminDashboardController ctrl=Get.put(AreaAdminDashboardController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.welcomecardclr,
        title: const Text(
          "Area Admin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
            onPressed: () => AuthService.showLogoutDialog(),
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
            _buildQuickStats(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: 'Recent Events',
              actionLabel: 'See all',
              onAction: ()=>Get.to(()=>AreaAdminAllEventsPage()),
            ),
            const SizedBox(height: 12),
            RecentEventsWidget(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: 'Recent Advertisements',
              actionLabel: 'See all',
              onAction: ()=>Get.to(()=>AreaAdminAllAdvertismentViewPage()),
            ),
            const SizedBox(height: 24),
            HomeAdvertisementWidget(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    ));
  }

  // ─── Welcome Card ─────────────────────────────────────────────────────────

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.welcomecardclr,
            AppColors.welcomecardclr.withOpacity(0.8),
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
              Icons.location_city_rounded,
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
                  "Welcome, Area Admin!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage your area efficiently",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickStats() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_month_rounded,
            value: '${ctrl.totalEvents.value}',
            label: 'Total Events',
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.campaign_rounded,
            value: '${ctrl.totalAdvertisements.value}',
            label: 'Active Ads',
            color: const Color(0xFFEC4899),
          ),),

        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.payments_rounded,
            value: '100',
            label: 'Total payments',
            color: const Color(0xFF10B981),
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
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons ───────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.add_circle_outline_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Post Event',
              subtitle: 'Area wise',
              onTap: () => Get.to(() => AreaAdminAddEventPage()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.campaign_rounded,
              iconColor: const Color(0xFFEC4899),
              title: 'Post Ad',
              subtitle: 'Business promo',
              onTap: () => Get.to(() => AreaAdminAddAdvertisementPage()),
            ),),
        ]
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section Header ───────────────────────────────────────────────────────

  Widget _buildSectionHeader({
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.kPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: AppColors.kPrimary),
              ],
            ),
          ),
      ],
    );
  }

}
