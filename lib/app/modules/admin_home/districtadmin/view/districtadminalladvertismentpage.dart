// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../common/style/app_colors.dart';
// import '../../../../data/models/districtadmin_advertismnetgetmodel.dart';
// import '../controller/districtadminadvertismentgetcontroller.dart';
// import '../widget/districtadmin_advertisementgetpage.dart';
//
//
// class DistrictAdminAllAdvertisementsPage extends StatelessWidget {
//   DistrictAdminAllAdvertisementsPage({super.key});
//
//   // Use Get.find — controller already registered from home widget
//   final controller = Get.find<DistrictAdminAdvertisementGetController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimary,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'All Advertisements',
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: controller.fetchAdvertisements,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: Obx(() {
//         // ── Loading ───────────────────────────────────────────────────────
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               color: Color(0xFF4F6CF7),
//             ),
//           );
//         }
//
//         // ── Empty ─────────────────────────────────────────────────────────
//         if (controller.advertisementList.isEmpty) {
//           return const Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.campaign_outlined,
//                     size: 60, color: Color(0xFFB0BAF4)),
//                 SizedBox(height: 12),
//                 Text(
//                   'No Advertisements Found',
//                   style: TextStyle(
//                     color: Color(0xFF9CA3AF),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // ── List ──────────────────────────────────────────────────────────
//         return RefreshIndicator(
//           onRefresh: controller.fetchAdvertisements,
//           color: const Color(0xFF4F6CF7),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.advertisementList.length,
//             itemBuilder: (context, index) {
//               final ad = controller.advertisementList[index];
//               return DistrictAdCard(
//                 ad: ad,
//                 onEdit: () {
//                   // TODO: Navigate to update page
//                   // Get.to(() => DistrictAdminUpdateAdvertisementPage(adId: ad.id))
//                   //     ?.then((result) {
//                   //   if (result == true) controller.fetchAdvertisements();
//                   // });
//                 },
//                 onDelete: () {
//                   debugPrint('🧪 Ad id to delete: ${ad.id}');
//                   _confirmDelete(context, ad);
//                 },
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
//
//   void _confirmDelete(
//       BuildContext context,
//       DistrictAdminGetAdvertisementModel advertisement,
//       ) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Advertisement'),
//         content: Text(
//           'Are you sure you want to delete "${advertisement.advertisement}"?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // controller.deleteAdvertisement(advertisement.id);
//             },
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../data/models/districtadmin_advertismnetgetmodel.dart';
import '../controller/districtadminadvertismentgetcontroller.dart';
import '../widget/districtadmin_advertisementgetpage.dart';

class DistrictAdminAllAdvertisementsPage extends StatelessWidget {
  DistrictAdminAllAdvertisementsPage({super.key});

  final controller = Get.find<DistrictAdminAdvertisementGetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'All Advertisements',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchAdvertisements,
            tooltip: 'Refresh',
          ),
        ],
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
                  'No Advertisements Found',
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

        return RefreshIndicator(
          onRefresh: controller.fetchAdvertisements,
          color: const Color(0xFF4F6CF7),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.advertisementList.length,
            itemBuilder: (context, index) {
              final ad = controller.advertisementList[index];
              return DistrictAdCard(
                ad: ad,
                onEdit: () async {
                  // ✅ Navigate to update page and refresh on success
                  final updated = await Get.toNamed(
                    '/districtadminadvupdation',
                    arguments: {'advertisement_id': ad.id},
                  );
                  if (updated == true) {
                    controller.fetchAdvertisements();
                  }
                },
                onDelete: () => _confirmDelete(context, ad),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmDelete(
      BuildContext context,
      DistrictAdminGetAdvertisementModel advertisement,
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
          // ✅ Obx to reactively disable button while deleting
          Obx(() => TextButton(
            onPressed: controller.isDeleting.value
                ? null
                : () async {
              Navigator.pop(context);
              await controller.deleteAdvertisement(advertisement.id); // ✅ uncommented
            },
            child: controller.isDeleting.value
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          )),
        ],
      ),
    );
  }
}