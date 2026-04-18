

import 'dart:io';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../merchantlogin/view/merchantmap.dart';
import '../controller/adminadd_merchantcontroller.dart';

class AdminAddMerchantPage extends StatelessWidget {
  AdminAddMerchantPage({super.key});

  final AdminAddMerchantController controller =
  Get.put(AdminAddMerchantController());
  final ImagePicker picker = ImagePicker();

  // ------------------ PICK STORE IMAGE ------------------
  Future pickImage() async {
    try {
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        controller.setStoreImage(File(picked.path));
      }
    } catch (e) {

    }
  }

  // ------------------ PICK SHOP LOCATION FROM MAP ------------------
  Future pickShopLocation() async {
    final result = await Get.to(() => ShopMapPicker(
      initialLat: controller.shopLat.value,
      initialLng: controller.shopLng.value,
      initialAddress: controller.pickedLocation.value,
    ));
    if (result != null) {
      controller.updateLocation(
        result["lat"],
        result["lng"],
        result["address"],
      );
    }
  }

  // ------------------ ENHANCED INPUT STYLE ------------------
  InputDecoration inputStyle(String label, IconData icon, {String? helperText}) {
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      helperStyle: TextStyle(color: Colors.grey[600], fontSize: 11),
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF089385), size: 22),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF089385), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // ------------------ SECTION HEADER ------------------
  Widget _sectionHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF089385).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF089385), size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ INFO BOX ------------------
  Widget _infoBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF089385).withOpacity(0.08),
            const Color(0xFF089385).withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF089385).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF089385).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline,
              color: Color(0xFF089385),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Auto Email Notification",
                  style: TextStyle(
                    color: Color(0xFF089385),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Login credentials will be automatically sent to the merchant's email after registration",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ SOCIAL / OPTIONAL FIELDS ------------------
  Widget _socialField(
      IconData icon, String label, TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: textController,
        style: const TextStyle(color: Color(0xFF1A1A1A)),
        decoration: inputStyle(label, icon),
      ),
    );
  }

  // ------------------ ENHANCED LOADING INDICATOR ------------------
  Widget _loadingIndicator(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF089385),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ------------------ ERROR CONTAINER ------------------
  Widget _errorContainer(String message, VoidCallback onRefresh) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF089385)),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Add New Merchant",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            )
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ INFO BOX ------------------
            _infoBox(),

            // ------------------ STORE IMAGE SECTION ------------------
            _sectionHeader("Store Image", icon: Icons.store),
            GestureDetector(
              onTap: pickImage,
              child: Obx(() {
                File? img = controller.storeImage.value;
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: img == null
                          ? Colors.grey[300]!
                          : const Color(0xFF089385),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: img == null
                            ? Colors.grey.withOpacity(0.1)
                            : const Color(0xFF089385).withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: img == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF089385).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate,
                          size: 44,
                          color: Color(0xFF089385),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Tap to upload store image",
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Recommended: 16:9 aspect ratio",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          img,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF089385),
                              size: 20,
                            ),
                            onPressed: pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // ------------------ BASIC DETAILS SECTION ------------------
            _sectionHeader("Basic Information", icon: Icons.info_outline),
            _buildCard(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.ownerNameController,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    decoration: inputStyle("Owner Name *", Icons.person_outline),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.shopNameController,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    decoration:
                    inputStyle("Shop Name *", Icons.storefront_outlined),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.emailController,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    decoration: inputStyle(
                      "Email *",
                      Icons.email_outlined,
                      helperText: "Credentials will be sent to this email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.phoneNo1Controller,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    decoration:
                    inputStyle("Phone Number *", Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.phoneNo2Controller,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    decoration: inputStyle("Alternate Phone (Optional)",
                        Icons.phone_android_outlined),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ------------------ ADDRESS SECTION ------------------
            _sectionHeader("Address Details", icon: Icons.location_on_outlined),
            _buildCard(
              child: Column(
                children: [
                  // STATE DROPDOWN
                  Obx(() {
                    if (controller.isLoadingStates.value) {
                      return _loadingIndicator("Loading states...");
                    }
                    if (controller.states.isEmpty) {
                      return _errorContainer(
                        "Failed to load states",
                            () => controller.fetchStates(),
                      );
                    }
                    return DropdownButtonFormField(
                      value: controller.selectedState.value.isEmpty
                          ? null
                          : controller.selectedState.value,
                      decoration: inputStyle("State *", Icons.flag_outlined),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Color(0xFF1A1A1A)),
                      items: controller.states
                          .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          controller.selectedState.value = v;
                          controller.selectedDistrict.value = "";
                          controller.selectedLocation.value = "";
                          controller.fetchDistricts(v);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // DISTRICT DROPDOWN
                  Obx(() {
                    if (controller.selectedState.value.isEmpty) {
                      return const SizedBox();
                    }
                    if (controller.isLoadingDistricts.value) {
                      return _loadingIndicator("Loading districts...");
                    }
                    if (controller.districts.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange.shade700),
                            const SizedBox(width: 12),
                            Text(
                              "No districts available",
                              style: TextStyle(color: Colors.orange.shade900),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        DropdownButtonFormField(
                          value: controller.selectedDistrict.value.isEmpty
                              ? null
                              : controller.selectedDistrict.value,
                          decoration: inputStyle(
                              "District *", Icons.location_city_outlined),
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Color(0xFF1A1A1A)),
                          items: controller.districts
                              .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d),
                          ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              controller.selectedDistrict.value = v;
                              controller.selectedLocation.value = "";
                              controller.fetchLocations(
                                  controller.selectedState.value, v);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),

                  // LOCATION DROPDOWN
                  Obx(() {
                    if (controller.selectedDistrict.value.isEmpty) {
                      return const SizedBox();
                    }
                    if (controller.isLoadingLocations.value) {
                      return _loadingIndicator("Loading locations...");
                    }
                    if (controller.locations.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange.shade700),
                            const SizedBox(width: 12),
                            Text(
                              "No locations available",
                              style: TextStyle(color: Colors.orange.shade900),
                            ),
                          ],
                        ),
                      );
                    }
                    return DropdownButtonFormField(
                      value: controller.selectedLocation.value.isEmpty
                          ? null
                          : controller.selectedLocation.value,
                      decoration:
                      inputStyle("Main Location *", Icons.place_outlined),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Color(0xFF1A1A1A)),
                      items: controller.locations
                          .map((l) => DropdownMenuItem(
                        value: l,
                        child: Text(l),
                      ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          controller.selectedLocation.value = v;
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ------------------ LOCATION PICKER SECTION ------------------
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF089385).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF089385),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Shop Location *",
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Current Location Button
                  Obx(() => ElevatedButton.icon(
                    onPressed: controller.isGettingCurrentLocation.value
                        ? null
                        : () => controller.getCurrentLocation(),
                    icon: controller.isGettingCurrentLocation.value
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.my_location, size: 20),
                    label: Text(
                      controller.isGettingCurrentLocation.value
                          ? "Getting Location..."
                          : "Use Current Location",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF089385),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  )),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Map Picker
                  Obx(() => InkWell(
                    onTap: pickShopLocation,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.shopLat.value != 0.0
                              ? const Color(0xFF089385)
                              : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                              const Color(0xFF089385).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.map_outlined,
                              size: 24,
                              color: Color(0xFF089385),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Pick Location on Map",
                                  style: TextStyle(
                                    color: Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  controller.pickedLocation.value,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  )),

                  // Display coordinates
                  Obx(() {
                    if (controller.shopLat.value != 0.0 &&
                        controller.shopLng.value != 0.0) {
                      return Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF4CAF50),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Location set: ${controller.shopLat.value.toStringAsFixed(6)}, ${controller.shopLng.value.toStringAsFixed(6)}",
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ------------------ OPTIONAL INFORMATION ------------------
            Divider(color: Colors.grey[300], thickness: 1.5),
            const SizedBox(height: 24),

            _sectionHeader("Optional Information", icon: Icons.add_circle_outline),
            _buildCard(
              child: Column(
                children: [
                  _socialField(Icons.call, "WhatsApp Number",
                      controller.whatsappController),
                  _socialField(Icons.facebook, "Facebook Profile",
                      controller.facebookController),
                  _socialField(Icons.camera_alt, "Instagram Profile",
                      controller.instagramController),
                  _socialField(Icons.language, "Website URL",
                      controller.websiteController),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ------------------ SUBMIT BUTTON ------------------
            Obx(() => Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: controller.isLoading.value
                    ? null
                    : const LinearGradient(
                  colors: [Color(0xFF089385), Color(0xFF06756A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: controller.isLoading.value
                    ? null
                    : [
                  BoxShadow(
                    color: const Color(0xFF089385).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.addMerchant(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isLoading.value
                      ? Colors.grey[300]
                      : Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.grey[600],
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_business, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "Register Merchant & Send Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ------------------ HELPER: BUILD CARD ------------------
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

