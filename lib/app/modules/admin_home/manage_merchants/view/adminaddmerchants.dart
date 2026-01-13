

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../merchantlogin/view/merchantmap.dart';
import '../controller/adminadd_merchantcontroller.dart';

class AdminAddMerchantPage extends StatelessWidget {
  AdminAddMerchantPage({super.key});

  final AdminAddMerchantController controller = Get.put(AdminAddMerchantController());
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
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF64B5F6), size: 22),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[800]!),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
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
                color: const Color(0xFF64B5F6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF64B5F6), size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF64B5F6).withOpacity(0.1),
            const Color(0xFF42A5F5).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF64B5F6).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF64B5F6).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline,
              color: Color(0xFF64B5F6),
              size: 24,
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
                    color: Color(0xFF64B5F6),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Login credentials will be automatically sent to the merchant's email after registration",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    height: 1.3,
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
        style: const TextStyle(color: Colors.white),
        decoration: inputStyle(label, icon),
      ),
    );
  }

  // ------------------ ENHANCED LOADING INDICATOR ------------------
  Widget _loadingIndicator(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF64B5F6),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey[400]),
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
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF64B5F6)),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Add New Merchant",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[800],
            height: 1,
          ),
        ),
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
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: img == null ? Colors.grey[800]! : const Color(0xFF64B5F6),
                      width: 2,
                    ),
                  ),
                  child: img == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF64B5F6).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Color(0xFF64B5F6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Tap to upload store image",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
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

            TextFormField(
              controller: controller.ownerNameController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Owner Name *", Icons.person_outline),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: controller.shopNameController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Shop Name *", Icons.storefront_outlined),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: controller.emailController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle(
                "Email *",
                Icons.email_outlined,
                helperText: "Credentials will be sent to this email",
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // TextFormField(
            //   controller: controller.passwordController,
            //   style: const TextStyle(color: Colors.white),
            //   decoration: inputStyle(
            //     "Password *",
            //     Icons.lock_outline,
            //     helperText: "This password will be sent via email",
            //   ),
            //   obscureText: true,
            //   textInputAction: TextInputAction.next,
            // ),
            // const SizedBox(height: 16),

            TextFormField(
              controller: controller.phoneNo1Controller,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Phone Number *", Icons.phone_outlined),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: controller.phoneNo2Controller,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Alternate Phone (Optional)", Icons.phone_android_outlined),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 32),

            // ------------------ ADDRESS SECTION ------------------
            _sectionHeader("Address Details", icon: Icons.location_on_outlined),

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

              return DropdownButtonFormField<String>(
                value: controller.selectedState.value.isEmpty
                    ? null
                    : controller.selectedState.value,
                decoration: inputStyle("State *", Icons.flag_outlined),
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
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
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 12),
                      Text(
                        "No districts available",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: controller.selectedDistrict.value.isEmpty
                        ? null
                        : controller.selectedDistrict.value,
                    decoration: inputStyle("District *", Icons.location_city_outlined),
                    dropdownColor: const Color(0xFF1E1E1E),
                    style: const TextStyle(color: Colors.white),
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
                        controller.fetchLocations(controller.selectedState.value, v);
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
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 12),
                      Text(
                        "No locations available",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: controller.selectedLocation.value.isEmpty
                        ? null
                        : controller.selectedLocation.value,
                    decoration: inputStyle("Main Location *", Icons.place_outlined),
                    dropdownColor: const Color(0xFF1E1E1E),
                    style: const TextStyle(color: Colors.white),
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
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),

            // ------------------ LOCATION PICKER SECTION ------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E1E1E),
                    const Color(0xFF2A2A2A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF64B5F6).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF64B5F6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Shop Location *",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  )),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[700])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[700])),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Map Picker
                  Obx(() => InkWell(
                    onTap: pickShopLocation,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.shopLat.value != 0.0
                              ? const Color(0xFF64B5F6)
                              : Colors.grey[800]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF64B5F6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.map_outlined,
                              size: 24,
                              color: Color(0xFF64B5F6),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  controller.pickedLocation.value,
                                  style: TextStyle(
                                    color: Colors.grey[400],
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
                            color: Colors.grey[600],
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
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF4CAF50),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Location set: ${controller.shopLat.value.toStringAsFixed(6)}, ${controller.shopLng.value.toStringAsFixed(6)}",
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
            Divider(color: Colors.grey[800], thickness: 1),
            const SizedBox(height: 24),

            _sectionHeader("Optional Information", icon: Icons.add_circle_outline),

            _socialField(Icons.call, "WhatsApp Number", controller.whatsappController),
            _socialField(Icons.facebook, "Facebook Profile", controller.facebookController),
            _socialField(Icons.camera_alt, "Instagram Profile", controller.instagramController),
            _socialField(Icons.language, "Website URL", controller.websiteController),

            const SizedBox(height: 32),

            // ------------------ SUBMIT BUTTON ------------------
            Obx(() => Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: controller.isLoading.value
                    ? null
                    : const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: controller.isLoading.value
                    ? null
                    : [
                  BoxShadow(
                    color: const Color(0xFF64B5F6).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.addMerchant(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isLoading.value
                      ? Colors.grey[800]
                      : Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_business, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Register Merchant & Send Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
}