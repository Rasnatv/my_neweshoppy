
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import 'controller/restaurant_dataupdatecontroller.dart';

class AdminRestaurantUpdatePage extends StatefulWidget {
  final String restaurantId;
  final Map<String, dynamic> restaurantData;

  const AdminRestaurantUpdatePage({
    super.key,
    required this.restaurantId,
    required this.restaurantData,
  });

  @override
  State<AdminRestaurantUpdatePage> createState() =>
      _AdminRestaurantUpdatePageState();
}

class _AdminRestaurantUpdatePageState
    extends State<AdminRestaurantUpdatePage> {
  late final AdminRestaurantUpdateController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AdminRestaurantUpdateController>()) {
      Get.delete<AdminRestaurantUpdateController>(force: true);
    }
    controller = Get.put(AdminRestaurantUpdateController());
    controller.restaurantId = widget.restaurantId;
    controller.loadRestaurantData(widget.restaurantData);
  }

  @override
  void dispose() {
    Get.delete<AdminRestaurantUpdateController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
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

          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Restaurant Image ─────────────────────────────
                  _buildImageSection(),
                  const SizedBox(height: 24),

                  // ── Basic Information ────────────────────────────
                  _buildSectionTitle("Basic Information"),
                  const SizedBox(height: 12),

                  _buildValidatedField(
                    controller: controller.restaurantNameController,
                    label: "Restaurant Name *",
                    icon: Icons.restaurant,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Restaurant name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  _buildValidatedField(
                    controller: controller.ownerNameController,
                    label: "Owner Name *",
                    icon: Icons.person,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Owner name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  _buildValidatedField(
                    controller: controller.addressController,
                    label: "Address *",
                    icon: Icons.location_on,
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Address is required'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // ── Contact Information ──────────────────────────
                  _buildSectionTitle("Contact Information"),
                  const SizedBox(height: 12),

                  _buildValidatedField(
                    controller: controller.phoneController,
                    label: "Phone Number *",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (v.trim().length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildValidatedField(
                    controller: controller.emailController,
                    label: "Email *",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!GetUtils.isEmail(v.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildValidatedField(
                    controller: controller.whatsappController,
                    label: "WhatsApp Number",
                    icon: Icons.chat,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: controller.validateWhatsapp,
                  ),
                  const SizedBox(height: 24),

                  // ── Online Presence ──────────────────────────────
                  _buildSectionTitle("Online Presence"),
                  const SizedBox(height: 4),
                  Text(
                    "All fields below are optional",
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 12),

                  _buildValidatedField(
                    controller: controller.websiteController,
                    label: "Website URL",
                    icon: Icons.web,
                    keyboardType: TextInputType.url,
                    validator: controller.validateWebsiteUrl,
                  ),
                  const SizedBox(height: 16),

                  _buildValidatedField(
                    controller: controller.facebookController,
                    label: "Facebook Link",
                    icon: Icons.facebook,
                    keyboardType: TextInputType.url,
                    hint: "https://facebook.com/yourpage",
                    validator: controller.validateFacebookUrl,
                  ),
                  const SizedBox(height: 16),

                  _buildValidatedField(
                    controller: controller.instagramController,
                    label: "Instagram Link",
                    icon: Icons.camera_alt,
                    keyboardType: TextInputType.url,
                    hint: "@yourhandle or https://instagram.com/yourhandle",
                    validator: controller.validateInstagramUrl,
                  ),
                  const SizedBox(height: 24),

                  // ── Additional Images ────────────────────────────
                  _buildAdditionalImagesSection(),
                  const SizedBox(height: 32),

                  // ── Payment Information ──────────────────────────
                  _buildSectionTitle("Payment Information"),
                  const SizedBox(height: 12),

                  _buildValidatedField(
                    controller: controller.upiIdController,
                    label: "UPI ID *",
                    icon: Icons.account_balance,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'UPI ID is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── QR Code ──────────────────────────────────────
                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("QR Code"),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: controller.pickQrImage,
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: controller.qrImage.value != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                controller.qrImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                                : controller.qrImageUrl.value.isNotEmpty
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.circular(12),
                              child: Image.network(
                                _getImageUrl(
                                    controller.qrImageUrl.value),
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Center(
                                child:
                                Icon(Icons.qr_code, size: 50)),
                          ),
                        ),
                        TextButton(
                          onPressed: controller.pickQrImage,
                          child: const Text("Change QR Code"),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── Submit Button ────────────────────────────────
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Restaurant Image Section ────────────────────────────────────────────
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
                  _getImageUrl(
                      controller.restaurantImageUrl.value),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImagePlaceholder(),
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
        Icon(Icons.add_photo_alternate,
            size: 60, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text("Tap to select image",
            style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  // ── Additional Images ───────────────────────────────────────────────────
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
          Text(
            "Optional",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          if (controller.existingAdditionalImageUrls.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                controller.existingAdditionalImageUrls.length,
                    (index) => _buildExistingImageTile(index),
              ),
            ),
          if (controller.additionalImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  controller.additionalImages.length,
                      (index) => _buildNewImageTile(index),
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
                child: Text("No additional images",
                    style: TextStyle(color: Colors.grey.shade600)),
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
              _getImageUrl(
                  controller.existingAdditionalImageUrls[index]),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () =>
                controller.removeExistingAdditionalImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child:
              const Icon(Icons.close, size: 16, color: Colors.white),
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
            child: Image.file(controller.additionalImages[index],
                fit: BoxFit.cover),
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
                  color: Colors.red, shape: BoxShape.circle),
              child:
              const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  String _getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) return imagePath;
    return "https://eshoppy.co.in//$imagePath";
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87),
    );
  }

  Widget _buildValidatedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 15),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.kPrimary),
        filled: true,
        fillColor: Colors.grey.shade50,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        errorStyle:
        TextStyle(color: Colors.red.shade700, fontSize: 12),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}