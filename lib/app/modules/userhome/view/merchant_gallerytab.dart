// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../merchant_home/views/merchant_gallerycontroller.dart';
//
// class MerchantGalleryTab extends StatelessWidget {
//   final int merchantId;
//
//   MerchantGalleryTab({super.key, required this.merchantId});
//
//   final controller = Get.put(MerchantGalleryController());
//
//   @override
//   Widget build(BuildContext context) {
//     controller.loadGallery(merchantId);
//
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return Center(
//           child: CircularProgressIndicator(color: AppColors.kPrimary),
//         );
//       }
//
//       if (controller.images.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.photo_library_outlined,
//                   size: 72, color: Colors.grey[400]),
//               const SizedBox(height: 16),
//               Text(
//                 "No Gallery Images",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return GridView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: controller.images.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemBuilder: (context, index) {
//           final image = controller.images[index];
//
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               image.imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, progress) {
//                 if (progress == null) return child;
//                 return Container(
//                   color: Colors.grey[200],
//                   child: const Center(
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                 );
//               },
//               errorBuilder: (_, __, ___) => Container(
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.broken_image),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
