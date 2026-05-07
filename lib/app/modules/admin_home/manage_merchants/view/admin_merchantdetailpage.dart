

import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../merchantlogin/view/merchantmap.dart';
import '../controller/admin_merchantdetailedcontroller.dart';

class AdminMerchantDetailPageUI extends StatelessWidget {
  final int merchantId;

  AdminMerchantDetailPageUI({super.key, required this.merchantId});

  final controller = Get.put(AdminMerchantDetailController());

  @override
  Widget build(BuildContext context) {
    controller.fetchMerchantDetail(merchantId);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Merchant Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          backgroundColor: AppColors.kPrimary,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.kPrimary),
                  const SizedBox(height: 16),
                  Text(
                    "Loading merchant details...",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          final m = controller.merchant.value;
          if (m == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No merchant data available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(m),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ── Action Buttons Row ───────────────────────────────
                      _buildActionRow(context),
                      const SizedBox(height: 16),

                      _buildInfoCard(
                        icon: Icons.store_rounded,
                        title: "Merchant Information",
                        children: [
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            label: "Merchant ID",
                            value: "#${m.id}",
                          ),
                          _buildInfoRow(
                            icon: Icons.storefront,
                            label: "Shop Name",
                            value: m.shopName,
                          ),
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: "Owner Name",
                            value: m.ownerName,
                          ),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: "Email",
                            value: m.email,
                            isLink: true,
                          ),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: "Primary Phone",
                            value: m.phone1,
                            isLink: true,
                          ),
                          if (m.phone2.isNotEmpty)
                            _buildInfoRow(
                              icon: Icons.phone_android_outlined,
                              label: "Secondary Phone",
                              value: m.phone2,
                              isLink: true,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        icon: Icons.location_on_rounded,
                        title: "Location Details",
                        children: [
                          _buildInfoRow(
                            icon: Icons.public,
                            label: "State",
                            value: m.state,
                          ),
                          _buildInfoRow(
                            icon: Icons.location_city,
                            label: "District",
                            value: m.district,
                          ),
                          _buildInfoRow(
                            icon: Icons.place_outlined,
                            label: "Location",
                            value: m.mainLocation,
                          ),
                          _buildCoordinatesRow(
                            latitude: m.latitude,
                            longitude: m.longitude,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        icon: Icons.share_rounded,
                        title: "Social Media & Web",
                        children: [
                          if (m.whatsapp.isNotEmpty)
                            _buildSocialRow(
                              icon: Icons.chat,
                              label: "WhatsApp",
                              value: m.whatsapp,
                              color: const Color(0xFF25D366),
                            ),
                          if (m.facebook.isNotEmpty)
                            _buildSocialRow(
                              icon: Icons.facebook,
                              label: "Facebook",
                              value: m.facebook,
                              color: const Color(0xFF1877F2),
                            ),
                          if (m.instagram.isNotEmpty)
                            _buildSocialRow(
                              icon: Icons.camera_alt,
                              label: "Instagram",
                              value: m.instagram,
                              color: const Color(0xFFE4405F),
                            ),
                          if (m.website.isNotEmpty)
                            _buildSocialRow(
                              icon: Icons.language,
                              label: "Website",
                              value: m.website,
                              color: Colors.blue,
                            ),
                          if (m.whatsapp.isEmpty &&
                              m.facebook.isEmpty &&
                              m.instagram.isEmpty &&
                              m.website.isEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "No social media information available",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Action Buttons Row ─────────────────────────────────────────────────────
  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showEditBottomSheet(context),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              "Edit Merchant",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.kPrimary,
              side: BorderSide(color: AppColors.kPrimary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmDialog(context),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text(
              "Delete",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[600],
              side: BorderSide(color: Colors.red[300]!, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // ── Edit Bottom Sheet ──────────────────────────────────────────────────────
  void _showEditBottomSheet(BuildContext context) {
    controller.initEditControllers();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.93,
        minChildSize: 0.5,
        maxChildSize: 0.97,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F7FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Handle ────────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // ── Sheet AppBar ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                        AppColors.kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.edit_outlined,
                          color: AppColors.kPrimary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Edit Merchant",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              // ── Form Content ──────────────────────────────────────────
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // ── Store Image ──────────────────────────────────
                      _editSectionHeader(
                          "Store Image", Icons.store),
                      _buildEditImagePicker(),
                      const SizedBox(height: 24),

                      // ── Basic Info ───────────────────────────────────
                      _editSectionHeader(
                          "Basic Information", Icons.info_outline),
                      _editCard(
                        child: Column(
                          children: [
                            _editField(
                              controller
                                  .editOwnerNameController,
                              "Owner Name *",
                              Icons.person_outline,
                              validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Please enter owner name'
                                  : null,
                            ),
                            _editField(
                              controller.editShopNameController,
                              "Shop Name *",
                              Icons.storefront_outlined,
                              validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Please enter shop name'
                                  : null,
                            ),
                            _editField(
                              controller.editEmailController,
                              "Email *",
                              Icons.email_outlined,
                              keyboardType:
                              TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Please enter email';
                                if (!GetUtils.isEmail(v.trim()))
                                  return 'Enter a valid email';
                                return null;
                              },
                            ),
                            _editField(
                              controller.editPhone1Controller,
                              "Phone Number *",
                              Icons.phone_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    10),
                              ],
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Please enter phone number';
                                if (v.trim().length != 10)
                                  return 'Must be exactly 10 digits';
                                return null;
                              },
                            ),
                            _editField(
                              controller.editPhone2Controller,
                              "Alternate Phone (Optional)",
                              Icons.phone_android_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    10),
                              ],
                              validator: (v) {
                                if (v != null &&
                                    v.trim().isNotEmpty &&
                                    v.trim().length != 10) {
                                  return 'Must be exactly 10 digits';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Address ──────────────────────────────────────
                      _editSectionHeader(
                          "Address Details",
                          Icons.location_on_outlined),
                      _editCard(
                        child: Column(
                          children: [
                            // State dropdown
                            Obx(() {
                              if (controller
                                  .isLoadingStates.value) {
                                return _miniLoader(
                                    "Loading states...");
                              }
                              if (controller.states.isEmpty) {
                                return const SizedBox();
                              }
                              return Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: controller
                                        .editSelectedState
                                        .value
                                        .isEmpty
                                        ? null
                                        : controller
                                        .editSelectedState
                                        .value,
                                    decoration: _editInputStyle(
                                        "State *",
                                        Icons.flag_outlined),
                                    dropdownColor: Colors.white,
                                    style: const TextStyle(
                                        color: Color(0xFF1A1A1A)),
                                    items: controller.states
                                        .map((s) =>
                                        DropdownMenuItem(
                                            value: s,
                                            child: Text(s)))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        controller.editSelectedState
                                            .value = v;
                                        controller
                                            .editSelectedDistrict
                                            .value = '';
                                        controller
                                            .editSelectedLocation
                                            .value = '';
                                        controller
                                            .fetchDistricts(v);
                                      }
                                    },
                                    validator: (v) =>
                                    (v == null || v.isEmpty)
                                        ? 'Please select state'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),

                            // District dropdown
                            Obx(() {
                              if (controller
                                  .editSelectedState.value.isEmpty) {
                                return const SizedBox();
                              }
                              if (controller
                                  .isLoadingDistricts.value) {
                                return _miniLoader(
                                    "Loading districts...");
                              }
                              if (controller.districts.isEmpty) {
                                return const SizedBox();
                              }
                              return Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: controller
                                        .editSelectedDistrict
                                        .value
                                        .isEmpty
                                        ? null
                                        : controller
                                        .editSelectedDistrict
                                        .value,
                                    decoration: _editInputStyle(
                                        "District *",
                                        Icons
                                            .location_city_outlined),
                                    dropdownColor: Colors.white,
                                    style: const TextStyle(
                                        color: Color(0xFF1A1A1A)),
                                    items: controller.districts
                                        .map((d) =>
                                        DropdownMenuItem(
                                            value: d,
                                            child: Text(d)))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        controller
                                            .editSelectedDistrict
                                            .value = v;
                                        controller
                                            .editSelectedLocation
                                            .value = '';
                                        controller.fetchLocations(
                                            controller
                                                .editSelectedState
                                                .value,
                                            v);
                                      }
                                    },
                                    validator: (v) =>
                                    (v == null || v.isEmpty)
                                        ? 'Please select district'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),

                            // Location dropdown
                            Obx(() {
                              if (controller
                                  .editSelectedDistrict
                                  .value
                                  .isEmpty) {
                                return const SizedBox();
                              }
                              if (controller
                                  .isLoadingLocations.value) {
                                return _miniLoader(
                                    "Loading locations...");
                              }
                              if (controller.locations.isEmpty) {
                                return const SizedBox();
                              }
                              return DropdownButtonFormField<
                                  String>(
                                value: controller
                                    .editSelectedLocation
                                    .value
                                    .isEmpty
                                    ? null
                                    : controller
                                    .editSelectedLocation.value,
                                decoration: _editInputStyle(
                                    "Main Location *",
                                    Icons.place_outlined),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                    color: Color(0xFF1A1A1A)),
                                items: controller.locations
                                    .map((l) => DropdownMenuItem(
                                    value: l, child: Text(l)))
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    controller.editSelectedLocation
                                        .value = v;
                                  }
                                },
                                validator: (v) =>
                                (v == null || v.isEmpty)
                                    ? 'Please select location'
                                    : null,
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── GPS Location ─────────────────────────────────
                      _editSectionHeader(
                          "Shop Location", Icons.location_on_outlined),
                      _editCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Current Location Button
                            Obx(() => ElevatedButton.icon(
                              onPressed: controller
                                  .isGettingCurrentLocation.value
                                  ? null
                                  : () =>
                                  controller.getCurrentLocation(),
                              icon: controller
                                  .isGettingCurrentLocation.value
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(Icons.my_location,
                                  size: 20),
                              label: Text(
                                controller.isGettingCurrentLocation
                                    .value
                                    ? "Getting Location..."
                                    : "Use Current Location",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF089385),
                                foregroundColor: Colors.white,
                                minimumSize:
                                const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            )),
                            const SizedBox(height: 20),

                            // OR divider
                            Row(
                              children: [
                                Expanded(
                                    child:
                                    Divider(color: Colors.grey[400])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child:
                                    Divider(color: Colors.grey[400])),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Map Picker tile
                            Obx(() => InkWell(
                              onTap: () async {
                                final result = await Get.to(
                                      () => ShopMapPicker(
                                    initialLat: controller
                                        .editShopLat.value,
                                    initialLng: controller
                                        .editShopLng.value,
                                    initialAddress: controller
                                        .editPickedLocation.value,
                                  ),
                                );
                                if (result != null) {
                                  controller.updateEditLocation(
                                    result["lat"],
                                    result["lng"],
                                    result["address"],
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                    color: controller
                                        .editShopLat.value !=
                                        0.0
                                        ? const Color(0xFF089385)
                                        : Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF089385)
                                            .withOpacity(0.1),
                                        borderRadius:
                                        BorderRadius.circular(10),
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Pick Location on Map",
                                            style: TextStyle(
                                              color: Color(0xFF1A1A1A),
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            controller.editPickedLocation
                                                .value,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow:
                                            TextOverflow.ellipsis,
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

                            // Coordinate badge
                            Obx(() {
                              if (controller.editShopLat.value != 0.0 &&
                                  controller.editShopLng.value != 0.0) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50)
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFF4CAF50)
                                          .withOpacity(0.3),
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
                                          "Location set: "
                                              "${controller.editShopLat.value.toStringAsFixed(6)}, "
                                              "${controller.editShopLng.value.toStringAsFixed(6)}",
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
                      const SizedBox(height: 24),

                      // ── Optional Info ────────────────────────────────
                      _editSectionHeader("Optional Information",
                          Icons.add_circle_outline),
                      _editCard(
                        child: Column(
                          children: [
                            _editField(
                              controller.editWhatsappController,
                              "WhatsApp Number",
                              Icons.chat_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    10),
                              ],
                            ),
                            _editField(
                              controller.editFacebookController,
                              "Facebook Profile URL",
                              Icons.facebook,
                              keyboardType: TextInputType.url,
                              validator: (v) =>
                                  _urlValidator(v, 'Facebook'),
                            ),
                            _editField(
                              controller.editInstagramController,
                              "Instagram Profile URL",
                              Icons.camera_alt_outlined,
                              keyboardType: TextInputType.url,
                              validator: (v) =>
                                  _urlValidator(v, 'Instagram'),
                            ),
                            _editField(
                              controller.editWebsiteController,
                              "Website URL",
                              Icons.language,
                              keyboardType: TextInputType.url,
                              validator: (v) =>
                                  _urlValidator(v, 'Website'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Save Button ──────────────────────────────────
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed:
                          controller.isUpdating.value
                              ? null
                              : () {
                            if (formKey.currentState!
                                .validate()) {
                              controller
                                  .updateMerchant(
                                  merchantId);
                            }
                          },
                          icon: controller.isUpdating.value
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Icon(Icons.save_outlined,
                              size: 20),
                          label: Text(
                            controller.isUpdating.value
                                ? "Saving..."
                                : "Save Changes",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.kPrimary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                            Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      )),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Delete Confirmation Dialog ─────────────────────────────────────────────
  void _showDeleteConfirmDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_forever_rounded,
                    color: Colors.red[600], size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                "Delete Merchant?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "This action cannot be undone. The merchant and all associated data will be permanently removed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed:
                      controller.isDeleting.value
                          ? null
                          : () => controller
                          .deleteMerchant(merchantId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        elevation: 0,
                      ),
                      child: controller.isDeleting.value
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Delete",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit Image Picker ──────────────────────────────────────────────────────
  Widget _buildEditImagePicker() {
    return Obx(() {
      final img = controller.editStoreImage.value;
      final existingUrl = controller.merchant.value?.storeImage ?? '';

      return GestureDetector(
        onTap: () => controller.pickEditImage(),
        child: Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (img != null || existingUrl.isNotEmpty)
                  ? AppColors.kPrimary
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: img != null
              ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.edit,
                      color: AppColors.kPrimary, size: 18),
                ),
              ),
            ],
          )
              : existingUrl.isNotEmpty
              ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(existingUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.edit,
                      color: AppColors.kPrimary, size: 18),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Tap to change image",
                    style: TextStyle(
                        color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate,
                  size: 40, color: AppColors.kPrimary),
              const SizedBox(height: 10),
              const Text("Tap to upload store image",
                  style: TextStyle(
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _editSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.kPrimary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _editField(
      TextEditingController textController,
      String label,
      IconData icon, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: textController,
        style: const TextStyle(color: Color(0xFF1A1A1A)),
        decoration: _editInputStyle(label, icon),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  InputDecoration _editInputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
      prefixIcon:
      Icon(icon, color: const Color(0xFF089385), size: 20),
      enabledBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.grey[300]!, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Color(0xFF089385), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _miniLoader(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.kPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Text(message,
              style: TextStyle(
                  color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  String? _urlValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Enter a valid $fieldName URL (must start with https://)';
    }
    return null;
  }

  // ── Existing Detail Widgets (unchanged) ───────────────────────────────────
  Widget _buildHeader(dynamic merchant) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Hero(
            tag: 'merchant_${merchant.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  merchant.storeImage,
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.kPrimary.withOpacity(0.1),
                          AppColors.kPrimary.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Icon(Icons.store_rounded,
                        size: 60, color: AppColors.kPrimary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            merchant.shopName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.05),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.kPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    final displayValue = value.isEmpty ? "Not provided" : value;
    final isEmptyValue = value.isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 20,
              color: isEmptyValue ? Colors.grey[400] : Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 15,
                    color: isEmptyValue
                        ? Colors.grey[400]
                        : (isLink
                        ? Colors.blue[700]
                        : const Color(0xFF1A1A1A)),
                    fontWeight: FontWeight.w500,
                    decoration: isLink && !isEmptyValue
                        ? TextDecoration.underline
                        : null,
                    fontStyle:
                    isEmptyValue ? FontStyle.italic : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildCoordinatesRow({
    required String latitude,
    required String longitude,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.map_outlined, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Coordinates",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$latitude, $longitude",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.my_location,
                color: AppColors.kPrimary, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}