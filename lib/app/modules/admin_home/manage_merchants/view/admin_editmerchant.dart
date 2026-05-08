import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../merchantlogin/view/merchantmap.dart';
import '../controller/admin_merchantdetailedcontroller.dart';
// adjust path as needed

class AdminMerchantEditPage extends StatelessWidget {
  final int merchantId;
  final AdminMerchantDetailController controller;

  AdminMerchantEditPage({
    Key? key,
    required this.merchantId,
    required this.controller,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Merchant',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // ── Store Image ────────────────────────────────────────────
            _sectionHeader('Store Image', Icons.store),
            _buildImagePicker(),
            const SizedBox(height: 24),

            // ── Basic Info ─────────────────────────────────────────────
            _sectionHeader('Basic Information', Icons.info_outline),
            _card(Column(children: [
              _field(controller.editOwnerNameController, 'Owner Name *',
                  Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter owner name'
                      : null),
              _field(controller.editShopNameController, 'Shop Name *',
                  Icons.storefront_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter shop name'
                      : null),
              _field(controller.editEmailController, 'Email *',
                  Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter email';
                    if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
                    return null;
                  }),
              _field(controller.editPhone1Controller, 'Phone Number *',
                  Icons.phone_outlined,
                  keyboardType: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter phone number';
                    if (v.trim().length != 10) return 'Must be exactly 10 digits';
                    return null;
                  }),
              _field(controller.editPhone2Controller, 'Alternate Phone (Optional)',
                  Icons.phone_android_outlined,
                  keyboardType: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty && v.trim().length != 10) {
                      return 'Must be exactly 10 digits';
                    }
                    return null;
                  }),
            ])),
            const SizedBox(height: 24),

            // ── Address ────────────────────────────────────────────────
            _sectionHeader('Address Details', Icons.location_on_outlined),
            _card(Column(children: [
              // State
              Obx(() {
                if (controller.isLoadingStates.value) return _loader('Loading states...');
                if (controller.states.isEmpty) return const SizedBox();
                return Column(children: [
                  DropdownButtonFormField<String>(
                    value: controller.editSelectedState.value.isEmpty
                        ? null
                        : controller.editSelectedState.value,
                    decoration: _inputStyle('State *', Icons.flag_outlined),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    items: controller.states
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        controller.editSelectedState.value = v;
                        controller.editSelectedDistrict.value = '';
                        controller.editSelectedLocation.value = '';
                        controller.fetchDistricts(v);
                      }
                    },
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please select state' : null,
                  ),
                  const SizedBox(height: 16),
                ]);
              }),

              // District
              Obx(() {
                if (controller.editSelectedState.value.isEmpty) return const SizedBox();
                if (controller.isLoadingDistricts.value) return _loader('Loading districts...');
                if (controller.districts.isEmpty) return const SizedBox();
                return Column(children: [
                  DropdownButtonFormField<String>(
                    value: controller.editSelectedDistrict.value.isEmpty
                        ? null
                        : controller.editSelectedDistrict.value,
                    decoration: _inputStyle('District *', Icons.location_city_outlined),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Color(0xFF1A1A1A)),
                    items: controller.districts
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        controller.editSelectedDistrict.value = v;
                        controller.editSelectedLocation.value = '';
                        controller.fetchLocations(
                            controller.editSelectedState.value, v);
                      }
                    },
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please select district' : null,
                  ),
                  const SizedBox(height: 16),
                ]);
              }),

              // Location
              Obx(() {
                if (controller.editSelectedDistrict.value.isEmpty) return const SizedBox();
                if (controller.isLoadingLocations.value) return _loader('Loading locations...');
                if (controller.locations.isEmpty) return const SizedBox();
                return DropdownButtonFormField<String>(
                  value: controller.editSelectedLocation.value.isEmpty
                      ? null
                      : controller.editSelectedLocation.value,
                  decoration: _inputStyle('Main Location *', Icons.place_outlined),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Color(0xFF1A1A1A)),
                  items: controller.locations
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) controller.editSelectedLocation.value = v;
                  },
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please select location' : null,
                );
              }),
            ])),
            const SizedBox(height: 24),

            // ── GPS Location ───────────────────────────────────────────
            _sectionHeader('Shop Location', Icons.my_location),
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isGettingCurrentLocation.value
                    ? null
                    : controller.getCurrentLocation,
                icon: controller.isGettingCurrentLocation.value
                    ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.my_location, size: 20),
                label: Text(controller.isGettingCurrentLocation.value
                    ? 'Getting Location...'
                    : 'Use Current Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF089385),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: Divider(color: Colors.grey[400])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w600)),
                ),
                Expanded(child: Divider(color: Colors.grey[400])),
              ]),
              const SizedBox(height: 16),
              Obx(() => InkWell(
                onTap: () async {
                  final result = await Get.to(() => ShopMapPicker(
                    initialLat: controller.editShopLat.value,
                    initialLng: controller.editShopLng.value,
                    initialAddress: controller.editPickedLocation.value,
                  ));
                  if (result != null) {
                    controller.updateEditLocation(
                        result['lat'], result['lng'], result['address']);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.editShopLat.value != 0.0
                          ? const Color(0xFF089385)
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF089385).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.map_outlined,
                          size: 24, color: Color(0xFF089385)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Pick Location on Map',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(controller.editPickedLocation.value,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
                  ]),
                ),
              )),
              Obx(() {
                if (controller.editShopLat.value == 0.0) return const SizedBox();
                return Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.check_circle,
                        color: Color(0xFF4CAF50), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location set: '
                            '${controller.editShopLat.value.toStringAsFixed(6)}, '
                            '${controller.editShopLng.value.toStringAsFixed(6)}',
                        style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
                );
              }),
            ])),
            const SizedBox(height: 24),

            // ── Optional ───────────────────────────────────────────────
            _sectionHeader('Optional Information', Icons.add_circle_outline),
            _card(Column(children: [
              _field(controller.editWhatsappController, 'WhatsApp Number',
                  Icons.chat_outlined,
                  keyboardType: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]),
              _field(controller.editFacebookController, 'Facebook Profile URL',
                  Icons.facebook,
                  keyboardType: TextInputType.url,
                  validator: (v) => _urlValidator(v, 'Facebook')),
              _field(controller.editInstagramController, 'Instagram Profile URL',
                  Icons.camera_alt_outlined,
                  keyboardType: TextInputType.url,
                  validator: (v) => _urlValidator(v, 'Instagram')),
              _field(controller.editWebsiteController, 'Website URL',
                  Icons.language,
                  keyboardType: TextInputType.url,
                  validator: (v) => _urlValidator(v, 'Website')),
            ])),
            const SizedBox(height: 32),

            // ── Save Button ────────────────────────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: controller.isUpdating.value
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    controller.updateMerchant(merchantId);
                  }
                },
                icon: controller.isUpdating.value
                    ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_outlined, size: 20),
                label: Text(
                  controller.isUpdating.value ? 'Saving...' : 'Save Changes',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Image Picker ──────────────────────────────────────────────────────────
  Widget _buildImagePicker() {
    return Obx(() {
      final img = controller.editStoreImage.value;
      final url = controller.merchant.value?.storeImage ?? '';
      return GestureDetector(
        onTap: controller.pickEditImage,
        child: Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (img != null || url.isNotEmpty)
                  ? AppColors.kPrimary
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: img != null
              ? _imageStack(Image.file(img, fit: BoxFit.cover,
              width: double.infinity, height: double.infinity))
              : url.isNotEmpty
              ? _imageStack(Image.network(url, fit: BoxFit.cover,
              width: double.infinity, height: double.infinity),
              showLabel: true)
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_photo_alternate,
                size: 40, color: AppColors.kPrimary),
            const SizedBox(height: 10),
            const Text('Tap to upload store image',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ]),
        ),
      );
    });
  }

  Widget _imageStack(Widget image, {bool showLabel = false}) {
    return Stack(children: [
      ClipRRect(borderRadius: BorderRadius.circular(14), child: image),
      Positioned(
        top: 10, right: 10,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 18,
          child: Icon(Icons.edit, color: AppColors.kPrimary, size: 18),
        ),
      ),
      if (showLabel)
        Positioned(
          bottom: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(8)),
            child: const Text('Tap to change image',
                style: TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ),
    ]);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.kPrimary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A))),
      ]),
    );
  }

  Widget _card(Widget child) => Container(
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
            offset: const Offset(0, 3))
      ],
    ),
    child: child,
  );

  Widget _field(
      TextEditingController ctrl,
      String label,
      IconData icon, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? formatters,
        String? Function(String?)? validator,
      }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: ctrl,
          style: const TextStyle(color: Color(0xFF1A1A1A)),
          decoration: _inputStyle(label, icon),
          keyboardType: keyboardType,
          inputFormatters: formatters,
          validator: validator,
        ),
      );

  InputDecoration _inputStyle(String label, IconData icon) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
    prefixIcon: Icon(icon, color: const Color(0xFF089385), size: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF089385), width: 2),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );

  Widget _loader(String msg) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(children: [
      SizedBox(
        width: 16, height: 16,
        child: CircularProgressIndicator(
            strokeWidth: 2, color: AppColors.kPrimary),
      ),
      const SizedBox(width: 10),
      Text(msg, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
    ]),
  );

  String? _urlValidator(String? v, String name) {
    if (v == null || v.trim().isEmpty) return null;
    final reg = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );
    if (!reg.hasMatch(v.trim())) return 'Enter a valid $name URL (must start with https://)';
    return null;
  }
}