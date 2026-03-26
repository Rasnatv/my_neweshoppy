
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../common/style/app_colors.dart';
import '../controller/areaadmin_getting_advertismentcontroller.dart';
import '../widget/areaadmin_getting_advertismentsection.dart'; // AdCard lives here

class AreaAdminAllAdvertismentViewPage extends StatelessWidget {
  AreaAdminAllAdvertismentViewPage({super.key});

  final controller = Get.find<AreaAdminAdvertisementgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.welcomecardclr,
        title: const Text("All Advertisements"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF4F6CF7),
            ),
          );
        }

        if (controller.advertisementList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.campaign_outlined,
                    size: 60, color: Color(0xFFB0BAF4)),
                SizedBox(height: 12),
                Text(
                  "No Advertisements Found",
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.advertisementList.length, // ✅ full list, not latestAds
          itemBuilder: (context, index) {
            final ad = controller.advertisementList[index]; // ✅ direct item
            return AdCard( // ✅ single card per item, no duplication
              ad: ad,
              onEdit: () {
                // TODO: navigate to edit page
              },
              onDelete: () {
                _showDeleteDialog(context, ad);
              },
            );
          },
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic ad) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Color(0xFFFF5C5C), size: 24),
            SizedBox(width: 8),
            Text(
              'Delete Ad',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF1A1D2E),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${ad.advertisement}"? This action cannot be undone.',
          style: const TextStyle(color: Color(0xFF6B7280), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: controller.deleteAd(ad.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5C5C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Delete',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}