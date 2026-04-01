
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/area_admin_advertismentgetmodel.dart';
import '../controller/areaadmin_getting_advertismentcontroller.dart';
import '../widget/areaadmin_getting_advertismentsection.dart';
import 'area_adminhome.dart';
import 'areaadmin_updateadvertismentpage.dart'; // AdCard lives here

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
              onEdit: () => Get.to(() => AreaAdminUpdateAdvertisementPage(adId: ad.id))
                  ?.then((result) {
                if (result == true) controller.fetchAdvertisements();
              }),

              onDelete: () {
                _confirmDelete(context, ad);
              },
            );
          });
      }),
    );
  }

  void _confirmDelete(
      BuildContext context,
      AreaAdmingetAdvertisementModel advertisement,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Advertisement'),
        content: Text(
          'Are you sure you want to delete "${advertisement.advertisement}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // ✅ Correct delete call
              controller.deleteAdvertisement(advertisement.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}