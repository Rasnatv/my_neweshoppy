// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../controller/restaurant_detailupdatecontroller.dart';
// class RestaurantUpdatePage extends StatelessWidget {
//   final controller = Get.put(RestaurantUpdateController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Restaurant"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Obx(() => GestureDetector(
//               onTap: controller.pickImage,
//               child: Container(
//                 height: 160,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: controller.restaurantImage.value == null
//                     ? const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt),
//                       SizedBox(height: 6),
//                       Text("Change Restaurant Image"),
//                     ],
//                   ),
//                 )
//                     : Image.file(controller.restaurantImage.value!,
//                     fit: BoxFit.cover),
//               ),
//             )),
//             const SizedBox(height: 24),
//
//             _field("Owner Name", controller.ownerCtrl),
//             _field("Address", controller.addressCtrl),
//             _field("Phone", controller.phoneCtrl),
//             _field("Email", controller.emailCtrl),
//             _field("Website", controller.websiteCtrl),
//             _field("Whatsapp", controller.whatsappCtrl),
//             _field("Facebook", controller.facebookCtrl),
//             _field("Instagram", controller.instaCtrl),
//
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: controller.updateRestaurant,
//                 child: const Text("Update Restaurant"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _field(String label, TextEditingController ctrl) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: ctrl,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/restaurant_detailupdatecontroller.dart';

class AdminRestaurantUpdatePage extends StatelessWidget {
  final RestaurantUpdateController controller =
  Get.put(RestaurantUpdateController());

  AdminRestaurantUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Restaurant"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ✅ Image Section
            Obx(() {
              if (controller.restaurantImage.value != null) {
                return Image.file(
                  controller.restaurantImage.value!,
                  fit: BoxFit.cover,
                  height: 160,
                  width: double.infinity,
                );
              } else if (controller.restaurantData?['restaurant_image'] != null &&
                  controller.restaurantData!['restaurant_image'].isNotEmpty) {
                return Image.network(
                  controller.restaurantData!['restaurant_image'],
                  fit: BoxFit.cover,
                  height: 160,
                  width: double.infinity,
                );
              } else {
                return GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt),
                          SizedBox(height: 6),
                          Text("Change Restaurant Image"),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
            const SizedBox(height: 24),

            _field("Owner Name", controller.ownerCtrl),
            _field("Address", controller.addressCtrl),
            _field("Phone", controller.phoneCtrl),
            _field("Email", controller.emailCtrl),
            _field("Website", controller.websiteCtrl),
            _field("Whatsapp", controller.whatsappCtrl),
            _field("Facebook", controller.facebookCtrl),
            _field("Instagram", controller.instaCtrl),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => controller.updateRestaurant(),
                child: const Text("Update Restaurant"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
