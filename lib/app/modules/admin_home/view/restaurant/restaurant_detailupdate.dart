//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/restaurant_detailupdatecontroller.dart';
//
//
// class AdminRestaurantUpdatePage extends StatelessWidget {
//   final dynamic restaurantId;
//   final Map<String, dynamic> restaurantData;
//
//   const AdminRestaurantUpdatePage({
//     Key? key,
//     required this.restaurantId,
//     required this.restaurantData,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Delete any existing instance first to ensure fresh data
//     Get.delete<RestaurantUpdateController>();
//
//     // Initialize controller with the passed data
//     final controller = Get.put(RestaurantUpdateController()
//       ..restaurantId = int.parse(restaurantId.toString())
//       ..restaurantData = restaurantData
//       ..initializeFields());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Restaurant"),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Restaurant Image Picker
//             Center(
//               child: GestureDetector(
//                 onTap: () => controller.pickImage(),
//                 child: Obx(() {
//                   return Container(
//                     width: 150,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[400]!),
//                     ),
//                     child: controller.restaurantImage.value != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         controller.restaurantImage.value!,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : restaurantData['restaurant_image'] != null &&
//                         restaurantData['restaurant_image'].isNotEmpty
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         restaurantData['restaurant_image'],
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.camera_alt, size: 40, color: Colors.grey[600]),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Tap to upload",
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Restaurant Name
//             _buildTextField(
//               controller: controller.nameCtrl,
//               label: "Restaurant Name",
//               icon: Icons.restaurant,
//             ),
//             const SizedBox(height: 16),
//
//             // Owner Name
//             _buildTextField(
//               controller: controller.ownerCtrl,
//               label: "Owner Name",
//               icon: Icons.person,
//             ),
//             const SizedBox(height: 16),
//
//             // Address
//             _buildTextField(
//               controller: controller.addressCtrl,
//               label: "Address",
//               icon: Icons.location_on,
//               maxLines: 2,
//             ),
//             const SizedBox(height: 16),
//
//             // Phone
//             _buildTextField(
//               controller: controller.phoneCtrl,
//               label: "Phone",
//               icon: Icons.phone,
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//
//             // Email
//             _buildTextField(
//               controller: controller.emailCtrl,
//               label: "Email",
//               icon: Icons.email,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//
//             // Website
//             _buildTextField(
//               controller: controller.websiteCtrl,
//               label: "Website",
//               icon: Icons.language,
//               keyboardType: TextInputType.url,
//             ),
//             const SizedBox(height: 16),
//
//             // WhatsApp
//             _buildTextField(
//               controller: controller.whatsappCtrl,
//               label: "WhatsApp",
//               icon: Icons.chat,
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//
//             // Facebook
//             _buildTextField(
//               controller: controller.facebookCtrl,
//               label: "Facebook Link",
//               icon: Icons.facebook,
//               keyboardType: TextInputType.url,
//             ),
//             const SizedBox(height: 16),
//
//             // Instagram
//             _buildTextField(
//               controller: controller.instaCtrl,
//               label: "Instagram Link",
//               icon: Icons.camera_alt,
//               keyboardType: TextInputType.url,
//             ),
//             const SizedBox(height: 32),
//
//             // Update Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () => controller.updateRestaurant(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Update Restaurant",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.blue, width: 2),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/restaurant_detailupdatecontroller.dart';

class AdminRestaurantUpdatePage extends StatefulWidget {
  final dynamic restaurantId;
  final Map<String, dynamic> restaurantData;

  const AdminRestaurantUpdatePage({
    Key? key,
    required this.restaurantId,
    required this.restaurantData,
  }) : super(key: key);

  @override
  State<AdminRestaurantUpdatePage> createState() => _AdminRestaurantUpdatePageState();
}

class _AdminRestaurantUpdatePageState extends State<AdminRestaurantUpdatePage> {
  late RestaurantUpdateController controller;

  @override
  void initState() {
    super.initState();

    print("🔍 ========== UPDATE PAGE INIT ==========");
    print("🔍 restaurantId: ${widget.restaurantId}");
    print("🔍 restaurantData: ${widget.restaurantData}");
    print("🔍 ========================================");

    // Delete any existing instance
    Get.delete<RestaurantUpdateController>();

    // Create new controller and initialize it
    controller = Get.put(RestaurantUpdateController());
    controller.init(
      int.parse(widget.restaurantId.toString()),
      widget.restaurantData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Restaurant"),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        // Wait for initialization to complete
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Image Picker
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Obx(() {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: controller.restaurantImage.value != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          controller.restaurantImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : widget.restaurantData['restaurant_image'] != null &&
                          widget.restaurantData['restaurant_image'].isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.restaurantData['restaurant_image'],
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            "Tap to upload",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              _buildTextField(controller: controller.restaurantnameCtrl,
                label: "Restaurant Name",
                icon: Icons.restaurant,
              ),

              const SizedBox(height: 16),

              // Owner Name
              _buildTextField(
                controller: controller.ownerCtrl,
                label: "Owner Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Address
              _buildTextField(
                controller: controller.addressCtrl,
                label: "Address",
                icon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildTextField(
                controller: controller.phoneCtrl,
                label: "Phone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                controller: controller.emailCtrl,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Website
              _buildTextField(
                controller: controller.websiteCtrl,
                label: "Website",
                icon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // WhatsApp
              _buildTextField(
                controller: controller.whatsappCtrl,
                label: "WhatsApp",
                icon: Icons.chat,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Facebook
              _buildTextField(
                controller: controller.facebookCtrl,
                label: "Facebook Link",
                icon: Icons.facebook,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Instagram
              _buildTextField(
                controller: controller.instaCtrl,
                label: "Instagram Link",
                icon: Icons.camera_alt,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => controller.updateRestaurant(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Update Restaurant",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}