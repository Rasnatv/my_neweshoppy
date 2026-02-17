
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import 'controller/restaurant_dataupdatecontroller.dart';

class AdminRestaurantUpdatePage extends StatelessWidget {
  final String restaurantId;
  final Map<String, dynamic> restaurantData;

  AdminRestaurantUpdatePage({
    super.key,
    required this.restaurantId,
    required this.restaurantData,
  });

  // FIX: Delete old controller and create fresh one every time
  late final AdminRestaurantUpdateController controller = _initController();

  AdminRestaurantUpdateController _initController() {
    // Force delete any stale instance
    if (Get.isRegistered<AdminRestaurantUpdateController>()) {
      Get.delete<AdminRestaurantUpdateController>(force: true);
    }
    final ctrl = Get.put(AdminRestaurantUpdateController());
    // Load data ONCE here, not inside build()
    ctrl.restaurantId = restaurantId;
    ctrl.loadRestaurantData(restaurantData);
    return ctrl;
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Removed controller.loadRestaurantData() from here

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Restaurant",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isUpdating.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Updating restaurant..."),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildSectionTitle("Basic Information"),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.restaurantNameController,
                label: "Restaurant Name",
                icon: Icons.restaurant,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.ownerNameController,
                label: "Owner Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.addressController,
                label: "Address",
                icon: Icons.location_on,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Contact Information"),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.whatsappController,
                label: "WhatsApp Number",
                icon: Icons.chat,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Online Presence"),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.websiteController,
                label: "Website URL",
                icon: Icons.web,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.facebookController,
                label: "Facebook Link",
                icon: Icons.facebook,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.instagramController,
                label: "Instagram Link",
                icon: Icons.camera_alt,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              _buildAdditionalImagesSection(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.updateRestaurant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Update Restaurant",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
  Widget _buildImageSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Restaurant Image"),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: controller.pickRestaurantImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: controller.restaurantImage.value != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  controller.restaurantImage.value!,
                  fit: BoxFit.cover,
                ),
              )
                  : controller.restaurantImageUrl.value.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _getImageUrl(controller.restaurantImageUrl.value),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                ),
              )
                  : _buildImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: controller.pickRestaurantImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Change Image"),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          "Tap to select image",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// =========================================================
  /// Additional Images Section
  /// =========================================================
  Widget _buildAdditionalImagesSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle("Additional Images"),
              TextButton.icon(
                onPressed: controller.pickAdditionalImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Add Images"),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Display existing additional images
          if (controller.existingAdditionalImageUrls.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                controller.existingAdditionalImageUrls.length,
                    (index) {
                  return _buildExistingImageTile(index);
                },
              ),
            ),

          // Display newly selected additional images
          if (controller.additionalImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  controller.additionalImages.length,
                      (index) {
                    return _buildNewImageTile(index);
                  },
                ),
              ),
            ),

          if (controller.existingAdditionalImageUrls.isEmpty &&
              controller.additionalImages.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "No additional images",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildExistingImageTile(int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _getImageUrl(controller.existingAdditionalImageUrls[index]),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => controller.removeExistingAdditionalImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewImageTile(int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              controller.additionalImages[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => controller.removeAdditionalImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// =========================================================
  /// Helper method to construct proper image URL
  /// =========================================================
  String _getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';

    // If the path already contains the full URL, return it as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Otherwise, prepend the base URL
    return "https://rasma.astradevelops.in/e_shoppyy/public/$imagePath";
  }

  /// =========================================================
  /// Section Title
  /// =========================================================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// =========================================================
  /// Text Field
  /// =========================================================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.kPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
