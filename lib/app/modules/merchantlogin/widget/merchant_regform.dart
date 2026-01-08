
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/merchantreg_controller.dart';
import '../view/merchantmap.dart';

class MerchantRegform extends StatelessWidget {
  MerchantRegform({super.key});

  final MerchantRegController controller = Get.put(MerchantRegController());
  final ImagePicker picker = ImagePicker();

  // ------------------ PICK STORE IMAGE ------------------
  Future pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      controller.setStoreImage(File(picked.path));
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

  // ------------------ INPUT STYLE ------------------
  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.10),
    );
  }

  // ------------------ SOCIAL / OPTIONAL FIELDS ------------------
  Widget _socialField(
      IconData icon, String label, TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: textController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle(label, icon),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ------------------ STORE IMAGE ------------------
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Store Image *",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: pickImage,
            child: Obx(() {
              File? img = controller.storeImage.value;
              return Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white54),
                ),
                child: img == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo,
                        size: 35, color: Colors.white),
                    SizedBox(height: 6),
                    Text("Tap to upload store image",
                        style: TextStyle(color: Colors.white70)),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(img,
                      fit: BoxFit.cover, width: double.infinity),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // ------------------ BASIC DETAILS ------------------
          TextFormField(
            controller: controller.ownerNameController,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle("Owner Name *", Icons.person),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.shopNameController,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle("Shop Name *", Icons.storefront),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.emailController,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle("Email *", Icons.email),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.passwordController,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle("Password *", Icons.lock),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.phoneNo1Controller,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle("Phone Number *", Icons.phone),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.phoneNo2Controller,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle("Alternate Phone Number (Optional)", Icons.phone),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // ------------------ DROPDOWN: STATE ------------------
          Obx(() {
            if (controller.isLoadingStates.value) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Loading states...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            if (controller.states.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Failed to load states. Please refresh.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () => controller.fetchStates(),
                    ),
                  ],
                ),
              );
            }

            return DropdownButtonFormField<String>(
              value: controller.selectedState.value.isEmpty
                  ? null
                  : controller.selectedState.value,
              decoration: inputStyle("State *", Icons.flag_outlined),
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white),
              items: controller.states
                  .map((s) => DropdownMenuItem(
                value: s,
                child:
                Text(s, style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  controller.selectedState.value = v;
                  controller.selectedDistrict.value = "";
                  controller.selectedLocation.value = "";
                  // Fetch districts for the selected state
                  controller.fetchDistricts(v);
                }
              },
            );
          }),
          const SizedBox(height: 12),

          // ------------------ DROPDOWN: DISTRICT ------------------
          Obx(() {
            if (controller.selectedState.value.isEmpty) {
              return const SizedBox();
            }

            if (controller.isLoadingDistricts.value) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Loading districts...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            if (controller.districts.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Text(
                  "No districts available for this state",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return DropdownButtonFormField<String>(
              value: controller.selectedDistrict.value.isEmpty
                  ? null
                  : controller.selectedDistrict.value,
              decoration: inputStyle("District *", Icons.location_city),
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white),
              items: controller.districts
                  .map((d) => DropdownMenuItem(
                value: d,
                child:
                Text(d, style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  controller.selectedDistrict.value = v;
                  controller.selectedLocation.value = "";
                  // Fetch locations for the selected state and district
                  controller.fetchLocations(controller.selectedState.value, v);
                }
              },
            );
          }),
          const SizedBox(height: 12),

          // ------------------ DROPDOWN: MAIN LOCATION ------------------
          Obx(() {
            if (controller.selectedDistrict.value.isEmpty) {
              return const SizedBox();
            }

            if (controller.isLoadingLocations.value) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Loading locations...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            if (controller.locations.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Text(
                  "No locations available for this district",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return DropdownButtonFormField<String>(
              value: controller.selectedLocation.value.isEmpty
                  ? null
                  : controller.selectedLocation.value,
              decoration: inputStyle("Main Location *", Icons.place),
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white),
              items: controller.locations
                  .map((l) => DropdownMenuItem(
                value: l,
                child:
                Text(l, style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  controller.selectedLocation.value = v;
                }
              },
            );
          }),
          const SizedBox(height: 20),

          // ------------------ LOCATION SECTION ------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white38),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Shop Location *",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),

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
                      : const Icon(Icons.my_location, color: Colors.white),
                  label: Text(
                    controller.isGettingCurrentLocation.value
                        ? "Getting Location..."
                        : "Use Current Location",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),

                const SizedBox(height: 12),

                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white38)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white38)),
                  ],
                ),

                const SizedBox(height: 12),

                // Map Picker
                Obx(() => InkWell(
                  onTap: pickShopLocation,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.map,
                            size: 28,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pick Location on Map",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.pickedLocation.value,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                )),

                // Display coordinates if location is set
                Obx(() {
                  if (controller.shopLat.value != 0.0 &&
                      controller.shopLng.value != 0.0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Coordinates: ${controller.shopLat.value.toStringAsFixed(6)}, ${controller.shopLng.value.toStringAsFixed(6)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ------------------ OPTIONAL FIELDS HEADER ------------------
          const Divider(color: Colors.white38),
          const SizedBox(height: 12),
          const Text(
            "Optional Information",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          // ------------------ OPTIONAL FIELDS ------------------
          _socialField(
              Icons.phone, "WhatsApp Number (Optional)", controller.whatsappController),
          _socialField(
              Icons.facebook, "Facebook Link (Optional)", controller.facebookController),
          _socialField(Icons.camera_alt, "Instagram Link (Optional)",
              controller.instagramController),
          _socialField(
              Icons.public, "Website Link (Optional)", controller.websiteController),

          const SizedBox(height: 30),

          // ------------------ REGISTER BUTTON ------------------
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                controller.registerMerchant();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "Register",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}