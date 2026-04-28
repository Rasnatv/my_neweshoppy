

import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../core/utils/auth_service.dart';
import '../controller/districtadmin_dashboardcontroller.dart';
import '../widget/districtadmin_advertisementgetpage.dart';
import '../widget/recent_eventwidget.dart';
import 'Districtadmin_addeventpage.dart';
import 'districtadmin_addadvertismentpage.dart';
import 'districtadmin_alleventspage.dart';
import 'districtadminalladvertismentpage.dart';


class Districtadminhomepage extends StatelessWidget {
  Districtadminhomepage({super.key});
  final DistrictAdminDashboardController ctrl=Get.put(DistrictAdminDashboardController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.welcomecardclr,
        title: const Text(
          "DistrictAdmin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
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
              onAction: () =>Get.to(()=>DistrictAdminAllEventsPage()),
            ),
            const SizedBox(height: 12),
            DistrictAdminRecentEventsWidget(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: 'Recent Advertisements',
              actionLabel: 'See all',
              onAction: () =>Get.to(()=>DistrictAdminAllAdvertisementsPage()),
            ),
            DistrictAdminHomeAdvertisementWidget(),
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
                  "Welcome, District Admin!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage your District efficiently",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Stats ──────────────────────────────────────────────────────────

  Widget _buildQuickStats() {
    return Row(
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
            value: ' ${ctrl.totalAdvertisements.value}',
            label: 'Active Ads',
            color: const Color(0xFFEC4899),
          ),
        ),
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
    );
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
            subtitle: 'Area or district',
            onTap: () =>Get.to(()=>DistrictAdminAddEventPage ()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.campaign_rounded,
            iconColor: const Color(0xFFEC4899),
            title: 'Post Ad',
            subtitle: 'Business promo',
            onTap: ()=>Get.to(()=>DistrictAdminAddAdvertisementPage()),
          ),
        ),
      ],
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



  Widget _buildEventCard(_EventData event) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Emoji Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: event.tagColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(event.emoji,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2D3748),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: event.tagColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  event.tag,
                                  style: TextStyle(
                                    color: event.tagColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_rounded,
                                  size: 11, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(event.date,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500])),
                              const SizedBox(width: 10),
                              Icon(Icons.place_outlined,
                                  size: 11, color: Colors.grey[400]),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Footer
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16)),
                  border:
                  Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 9),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 13, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      event.district,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'View details →',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ─── Recent Ads ───────────────────────────────────────────────────────────
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _EventData {
  final String emoji;
  final String title;
  final String date;
  final String location;
  final String tag;
  final Color tagColor;
  final String district;

  _EventData({
    required this.emoji,
    required this.title,
    required this.date,
    required this.location,
    required this.tag,
    required this.tagColor,
    required this.district,
  });
}

