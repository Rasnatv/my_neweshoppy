

import 'dart:io';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../merchantlogin/view/merchantmap.dart';
import '../controller/merchantsetting_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Design Tokens
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  // ── Teal – AppBar & Save button ONLY ────────────────────────────────────
  static const teal           = Color(0xFF0A6E5C);

  // ── Surface / Background ─────────────────────────────────────────────────
  static const surface        = Colors.white;
  static const bg             = Color(0xFFF0F4F3);
  static const border         = Color(0xFFDDE5E3);
  static const divider        = Color(0xFFF1F5F4);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary    = Color(0xFF111827);
  static const textSecond     = Color(0xFF6B7280);
  static const textMuted      = Color(0xFF9CA3AF);

  // ── Status ────────────────────────────────────────────────────────────────
  static const success        = Color(0xFF059669);
  static const successBg      = Color(0xFFECFDF5);

  // ── Locked row ───────────────────────────────────────────────────────────
  static const locked         = Color(0xFFF8FAFB);
  static const lockedBorder   = Color(0xFFE5E7EB);
  static const lockedText     = Color(0xFF9CA3AF);

  // ── Focus accent (left-bar, chevron, edit icon) ───────────────────────
  static const focusAccent    = Color(0xFF6366F1);   // indigo
  static const focusBg        = Color(0xFFFAFAFF);

  // ── Per-icon professional palettes ───────────────────────────────────────
  // Owner Name  – indigo
  static const ownerIcon      = Color(0xFF6366F1);
  static const ownerIconBg    = Color(0xFFEEF2FF);

  // Shop Name – violet
  static const shopIcon       = Color(0xFF8B5CF6);
  static const shopIconBg     = Color(0xFFF5F3FF);

  // Phone – amber
  static const phoneIcon      = Color(0xFFD97706);
  static const phoneIconBg    = Color(0xFFFFFBEB);

  // State – blue
  static const stateIcon      = Color(0xFF2563EB);
  static const stateIconBg    = Color(0xFFEFF6FF);

  // District – cyan
  static const districtIcon   = Color(0xFF0891B2);
  static const districtIconBg = Color(0xFFECFEFF);

  // Location pin – rose
  static const pinIcon        = Color(0xFFE11D48);
  static const pinIconBg      = Color(0xFFFFF1F2);

  // GPS button – blue
  static const gpsBtnFg       = Color(0xFF2563EB);
  static const gpsBtnBg       = Color(0xFFEFF6FF);

  // Map pin button – violet
  static const mapBtnFg       = Color(0xFF8B5CF6);
  static const mapBtnBg       = Color(0xFFF5F3FF);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Page
// ─────────────────────────────────────────────────────────────────────────────
class MerchantSettingPage extends StatelessWidget {
  final MerchantUpdateController controller =
  Get.put(MerchantUpdateController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        appBar: _appBar(),
        body: Obx(() => controller.isLoading.value
            ? _loadingView()
            : _body()),
      ),
    );
  }

  // ── AppBar (teal) ─────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: AppColors.kPrimary,   // teal
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
      "Edit Profile",
      style: TextStyle(
        color: Colors.white, fontSize: 17,
        fontWeight: FontWeight.w600, letterSpacing: 0.2,
      ),
    ),
    actions: [
      Obx(() => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          child: GestureDetector(
            onTap: controller.isUpdating.value
                ? null : () => controller.updateMerchant(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: controller.isUpdating.value
                    ? Colors.white.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: controller.isUpdating.value
                  ? const SizedBox(
                width: 14, height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.kPrimary,
                ),
              )
                  : const Text(
                "Save",
                style: TextStyle(
                  color: AppColors.kPrimary, fontSize: 13,
                  fontWeight: FontWeight.w700, letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      )),
    ],
  );

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _loadingView() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(color: AppColors.kPrimary, strokeWidth: 2.5),
        SizedBox(height: 18),
        Text(
          "Loading profile…",
          style: TextStyle(color: _C.textMuted, fontSize: 14),
        ),
      ],
    ),
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  Widget _body() => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel("Basic Details"),
              const SizedBox(height: 12),
              _basicDetailsGroup(),

              const SizedBox(height: 28),
              _sectionLabel("Location"),
              const SizedBox(height: 12),
              _locationDropdowns(),
              const SizedBox(height: 10),
              _locationCard(),

              const SizedBox(height: 28),
              _sectionLabel("Social Links"),
              const SizedBox(height: 12),
              _socialFields(),

              const SizedBox(height: 36),
              _saveButton(),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Only you can see your account details",
                  style: TextStyle(fontSize: 11, color: _C.textMuted),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Profile Header ────────────────────────────────────────────────────────
  Widget _profileHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teal banner
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 90,
                color: AppColors.kPrimary,
                child: CustomPaint(
                  size: const Size(double.infinity, 90),
                  painter: _BannerPatternPainter(),
                ),
              ),
              Positioned(
                bottom: -34,
                left: 20,
                child: _avatarWidget(),
              ),
            ],
          ),
          // Name & shop
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 18),
            child: GetBuilder<MerchantUpdateController>(
              builder: (c) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.ownerCtrl.text.isNotEmpty ? c.ownerCtrl.text : "Your Name",
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: _C.textPrimary, letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _chip(
                        icon: Icons.storefront_outlined,
                        label: c.shopCtrl.text.isNotEmpty
                            ? c.shopCtrl.text : "Shop Name",
                        color: _C.shopIcon,
                        bgColor: _C.shopIconBg,
                      ),
                      const SizedBox(width: 8),
                      _activeDot(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarWidget() {
    return GetBuilder<MerchantUpdateController>(
      builder: (c) => GestureDetector(
        onTap: () => controller.pickImage(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                color: _C.shopIconBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10, offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: c.pickedImage != null
                  ? Image.file(c.pickedImage!, fit: BoxFit.cover)
                  : c.networkImage.isNotEmpty
                  ? Image.network(c.networkImage, fit: BoxFit.cover)
                  : const Icon(Icons.storefront_outlined,
                  size: 32, color: _C.shopIcon),
            ),
            Positioned(
              bottom: -3, right: -3,
              child: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,         // teal camera badge
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimary.withOpacity(0.3),
                      blurRadius: 4, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeDot() => Row(
    children: [
      Container(
        width: 6, height: 6,
        decoration: const BoxDecoration(color: _C.success, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      const Text(
        "Active",
        style: TextStyle(fontSize: 11, color: _C.success, fontWeight: FontWeight.w500),
      ),
    ],
  );

  // ── Section Label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Row(
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: _C.textMuted, letterSpacing: 0.9,
        ),
      ),
      const SizedBox(width: 10),
      const Expanded(child: Divider(color: _C.border, thickness: 1, height: 1)),
    ],
  );

  // ── Basic Details Group ───────────────────────────────────────────────────
  Widget _basicDetailsGroup() {
    return _CardGroup(
      children: [
        _EditableRow(
          label: "Owner Name",
          ctrl: controller.ownerCtrl,
          iconWidget: _iconBox(Icons.person_outline, _C.ownerIcon, _C.ownerIconBg),
          keyboardType: TextInputType.name,
        ),
        _EditableRow(
          label: "Shop Name",
          ctrl: controller.shopCtrl,
          iconWidget: _iconBox(Icons.storefront_outlined, _C.shopIcon, _C.shopIconBg),
          keyboardType: TextInputType.text,
        ),
        // Email – read-only
        _LockedRow(
          label: "Email Address",
          ctrl: controller.emailCtrl,
          iconWidget: _iconBox(
            Icons.email_outlined, _C.textMuted, const Color(0xFFF3F4F6),
          ),
        ),
        _EditableRow(
          label: "Phone Number 1",
          ctrl: controller.phone1Ctrl,
          iconWidget: _iconBox(Icons.phone_outlined, _C.phoneIcon, _C.phoneIconBg),
          keyboardType: TextInputType.phone,
        ),
        _EditableRow(
          label: "Phone Number 2",
          ctrl: controller.phone2Ctrl,
          iconWidget: _iconBox(Icons.phone_outlined, _C.phoneIcon, _C.phoneIconBg),
          keyboardType: TextInputType.phone,
          isLast: true,
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }

  // ── Location Dropdowns ────────────────────────────────────────────────────
  Widget _locationDropdowns() {
    return _CardGroup(
      children: [
        Obx(() => _DropdownRow(
          label: "State",
          value: controller.selectedState.value.isEmpty
              ? null : controller.selectedState.value,
          items: controller.states,
          onChanged: (v) {
            if (v != null) {
              controller.selectedState.value = v;
              controller.fetchDistricts(v);
            }
          },
          iconWidget: _iconBox(Icons.flag_outlined, _C.stateIcon, _C.stateIconBg),
          isLoading: controller.isLoadingStates.value,
        )),
        Obx(() {
          if (controller.selectedState.value.isEmpty) return const SizedBox();
          return _DropdownRow(
            label: "District",
            value: controller.selectedDistrict.value.isEmpty
                ? null : controller.selectedDistrict.value,
            items: controller.districts,
            onChanged: (v) {
              if (v != null) {
                controller.selectedDistrict.value = v;
                controller.fetchLocations(
                    controller.selectedState.value, v);
              }
            },
            iconWidget: _iconBox(
              Icons.location_city_outlined,
              _C.districtIcon, _C.districtIconBg,
            ),
            isLoading: controller.isLoadingDistricts.value,
          );
        }),
        Obx(() {
          if (controller.selectedDistrict.value.isEmpty) return const SizedBox();
          return _DropdownRow(
            label: "Main Location",
            value: controller.selectedLocation.value.isEmpty
                ? null : controller.selectedLocation.value,
            items: controller.locations,
            onChanged: (v) {
              if (v != null) controller.selectedLocation.value = v;
            },
            iconWidget: _iconBox(
              Icons.place_outlined, _C.pinIcon, _C.pinIconBg,
            ),
            isLoading: controller.isLoadingLocations.value,
            isLast: true,
          );
        }),
      ],
    );
  }

  // ── Location Card ─────────────────────────────────────────────────────────
  Widget _locationCard() {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              _MapPreview(),
              Positioned(
                top: 10, right: 10,
                child: GestureDetector(
                  onTap: _pickShopLocation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6, offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit_outlined, size: 12, color: _C.mapBtnFg),
                        SizedBox(width: 4),
                        Text(
                          "Change",
                          style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600,
                            color: _C.mapBtnFg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(() {
                  final hasLoc = controller.latitude.value != 0.0;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: hasLoc ? _C.successBg : _C.pinIconBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          hasLoc
                              ? Icons.check_circle_outline
                              : Icons.location_on_outlined,
                          size: 16,
                          color: hasLoc ? _C.success : _C.pinIcon,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SHOP ADDRESS",
                              style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600,
                                color: _C.textMuted, letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              controller.pickedLocation.value.isNotEmpty
                                  ? controller.pickedLocation.value
                                  : "No location selected yet",
                              style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: controller.pickedLocation.value
                                    .isNotEmpty
                                    ? _C.textPrimary
                                    : _C.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  if (controller.latitude.value == 0.0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        _coordChip("LAT",
                            controller.latitude.value.toStringAsFixed(6)),
                        const SizedBox(width: 8),
                        _coordChip("LNG",
                            controller.longitude.value.toStringAsFixed(6)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _locBtn(
                        label: controller.isGettingCurrentLocation.value
                            ? "Detecting…" : "Use GPS",
                        icon: Icons.my_location,
                        fgColor: _C.gpsBtnFg,
                        bgColor: _C.gpsBtnBg,
                        isPrimary: false,
                        isLoading: controller.isGettingCurrentLocation.value,
                        onTap: controller.isGettingCurrentLocation.value
                            ? null
                            : controller.getCurrentLocation,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _locBtn(
                        label: "Pin on Map",
                        icon: Icons.map_outlined,
                        fgColor: Colors.white,
                        bgColor: _C.mapBtnFg,
                        isPrimary: true,
                        onTap: _pickShopLocation,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coordChip(String axis, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFB),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: _C.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$axis  ",
          style: const TextStyle(
            fontSize: 9, fontWeight: FontWeight.w800,
            color: _C.stateIcon, letterSpacing: 0.4,
          ),
        ),
        Text(
          val,
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500,
            color: _C.textSecond,
          ),
        ),
      ],
    ),
  );

  /// [isPrimary] = solid fill button; otherwise outline/tinted
  Widget _locBtn({
    required String label,
    required IconData icon,
    required Color fgColor,
    required Color bgColor,
    required bool isPrimary,
    bool isLoading = false,
    VoidCallback? onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: isPrimary
            ? null
            : Border.all(color: fgColor.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 13, height: 13,
              child: CircularProgressIndicator(
                strokeWidth: 2, color: fgColor,
              ),
            )
          else
            Icon(icon, size: 14, color: fgColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: fgColor,
            ),
          ),
        ],
      ),
    ),
  );

  // ── Social Fields ─────────────────────────────────────────────────────────
  Widget _socialFields() {
    return _CardGroup(
      children: [
        _SocialRow(
          label: "WhatsApp",
          ctrl: controller.whatsappCtrl,
          hint: "+91 9876543210",
          iconPainter: _WhatsAppPainter(),
          iconBg: const Color(0xFFDCFCE7),
          keyboardType: TextInputType.phone,
        ),
        _SocialRow(
          label: "Facebook",
          ctrl: controller.facebookCtrl,
          hint: "facebook.com/yourpage",
          iconPainter: _FacebookPainter(),
          iconBg: const Color(0xFFEFF6FF),
          keyboardType: TextInputType.url,
        ),
        _SocialRow(
          label: "Instagram",
          ctrl: controller.instagramCtrl,
          hint: "instagram.com/yourhandle",
          iconPainter: _InstagramPainter(),
          iconBg: const Color(0xFFFDF2F8),
          keyboardType: TextInputType.url,
        ),
        _SocialRow(
          label: "Website",
          ctrl: controller.websiteCtrl,
          hint: "https://yourwebsite.com",
          iconPainter: _WebsitePainter(),
          iconBg: const Color(0xFFF0FDF4),
          keyboardType: TextInputType.url,
          isLast: true,
        ),
      ],
    );
  }

  // ── Save Button (teal) ────────────────────────────────────────────────────
  Widget _saveButton() => Obx(() => SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: controller.isUpdating.value
          ? null : () => controller.updateMerchant(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kPrimary,   // teal
        disabledBackgroundColor: _C.textMuted,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: controller.isUpdating.value
          ? const SizedBox(
        width: 20, height: 20,
        child: CircularProgressIndicator(
          color: Colors.white, strokeWidth: 2.5,
        ),
      )
          : const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "Save Changes",
            style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: Colors.white, letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    ),
  ));

  Future<void> _pickShopLocation() async {
    final result = await Get.to(() => ShopMapPicker(
      initialLat: controller.latitude.value,
      initialLng: controller.longitude.value,
      initialAddress: controller.pickedLocation.value,
    ));
    if (result != null) {
      controller.updateLocation(
          result["lat"], result["lng"], result["address"]);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CardGroup extends StatelessWidget {
  final List<Widget> children;
  const _CardGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _EditableRow extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final Widget iconWidget;
  final TextInputType keyboardType;
  final bool isLast;

  const _EditableRow({
    required this.label,
    required this.ctrl,
    required this.iconWidget,
    this.keyboardType = TextInputType.text,
    this.isLast = false,
  });

  @override
  State<_EditableRow> createState() => _EditableRowState();
}

class _EditableRowState extends State<_EditableRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: _focused ? _C.focusBg : _C.surface,
            child: Row(
              children: [
                // Indigo left accent bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3, height: 58,
                  decoration: BoxDecoration(
                    color: _focused ? _C.focusAccent : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13, right: 12),
                  child: AnimatedScale(
                    scale: _focused ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 160),
                    child: _focused
                        ? Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: _C.focusAccent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.edit, size: 15, color: Colors.white,
                      ),
                    )
                        : widget.iconWidget,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.ctrl,
                    keyboardType: widget.keyboardType,
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: _C.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      labelStyle: const TextStyle(
                        fontSize: 11, color: _C.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: _focused ? _C.focusAccent : _C.border,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isLast)
          const Divider(
              height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

class _LockedRow extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final Widget iconWidget;

  const _LockedRow({
    required this.label,
    required this.ctrl,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: _C.locked,
          child: Row(
            children: [
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(
                    left: 13, right: 12, top: 14, bottom: 14),
                child: iconWidget,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11, color: _C.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      ctrl.text.isNotEmpty ? ctrl.text : "—",
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: _C.lockedText,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _C.lockedBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          size: 10, color: _C.textMuted),
                      SizedBox(width: 3),
                      Text(
                        "Locked",
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600,
                          color: _C.textMuted, letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
            height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

class _SocialRow extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final CustomPainter iconPainter;
  final Color iconBg;
  final TextInputType keyboardType;
  final bool isLast;

  const _SocialRow({
    required this.label,
    required this.ctrl,
    required this.hint,
    required this.iconPainter,
    required this.iconBg,
    this.keyboardType = TextInputType.url,
    this.isLast = false,
  });

  @override
  State<_SocialRow> createState() => _SocialRowState();
}

class _SocialRowState extends State<_SocialRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: _focused ? _C.focusBg : _C.surface,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3, height: 60,
                  decoration: BoxDecoration(
                    color: _focused ? _C.focusAccent : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13, right: 12),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      // keep brand bg; just slightly brighten on focus
                      color: _focused
                          ? widget.iconBg.withOpacity(0.7)
                          : widget.iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomPaint(painter: widget.iconPainter),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.ctrl,
                    keyboardType: widget.keyboardType,
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: _C.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      hintText: widget.hint,
                      labelStyle: const TextStyle(
                        fontSize: 11, color: _C.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 12, color: _C.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: _focused ? _C.focusAccent : _C.border,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isLast)
          const Divider(
              height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Widget iconWidget;
  final bool isLoading;
  final bool isLast;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.iconWidget,
    this.isLoading = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            const SizedBox(
              width: 14, height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: _C.stateIcon),
            ),
            const SizedBox(width: 12),
            Text(
              "Loading $label…",
              style: const TextStyle(fontSize: 13, color: _C.textMuted),
            ),
          ],
        ),
      );
    }
    if (items.isEmpty) return const SizedBox();
    return Column(
      children: [
        Container(
          color: _C.surface,
          child: Row(
            children: [
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 12),
                child: iconWidget,
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: value,
                  style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500,
                    color: _C.textPrimary,
                  ),
                  dropdownColor: _C.surface,
                  icon: const Icon(Icons.unfold_more_rounded,
                      size: 16, color: _C.textMuted),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(
                      fontSize: 11, color: _C.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Map Decorative Widget
// ─────────────────────────────────────────────────────────────────────────────
class _MapPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFCDE8E2), Color(0xFFB0D9D0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(double.infinity, 128),
            painter: _MapGridPainter(),
          ),
          CustomPaint(
            size: const Size(double.infinity, 128),
            painter: _RoadPainter(),
          ),
          Center(
            child: Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.pinIcon.withOpacity(0.06),
                border: Border.all(
                  color: _C.pinIcon.withOpacity(0.2), width: 1.5,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _C.pinIcon,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: _C.pinIcon.withOpacity(0.4),
                        blurRadius: 8, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: const Icon(
                      Icons.location_on, color: Colors.white, size: 17,
                    ),
                  ),
                ),
                Container(
                  width: 10, height: 4,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF0A6E5C).withOpacity(0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 26) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 26) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r1 = Paint()
      ..color = Colors.white.withOpacity(0.65)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.52)
        ..cubicTo(
          size.width * 0.25, size.height * 0.42,
          size.width * 0.75, size.height * 0.60,
          size.width, size.height * 0.50,
        ),
      r1,
    );
    final r2 = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.38, 0)
        ..cubicTo(
          size.width * 0.39, size.height * 0.5,
          size.width * 0.39, size.height * 0.5,
          size.width * 0.40, size.height,
        ),
      r2,
    );
  }
  @override bool shouldRepaint(_) => false;
}

class _BannerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 5; i++) {
      final r = 30.0 + i * 22;
      canvas.drawCircle(
          Offset(size.width * 0.85, size.height * 0.3), r, p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Brand Icon Painters  (unchanged – each uses its own brand color)
// ─────────────────────────────────────────────────────────────────────────────

class _WhatsAppPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.fill;
    final s = size.width / 24;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(12 * s, 12 * s), width: 20 * s, height: 20 * s,
      ),
      paint,
    );
    final wp = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(16.75 * s, 14.39 * s)
      ..cubicTo(16.50 * s, 14.27 * s, 15.26 * s, 13.67 * s, 15.04 * s, 13.59 * s)
      ..cubicTo(14.82 * s, 13.51 * s, 14.66 * s, 13.47 * s, 14.50 * s, 13.72 * s)
      ..cubicTo(14.34 * s, 13.97 * s, 13.86 * s, 14.53 * s, 13.72 * s, 14.70 * s)
      ..cubicTo(13.58 * s, 14.87 * s, 13.44 * s, 14.89 * s, 13.19 * s, 14.77 * s)
      ..cubicTo(12.94 * s, 14.65 * s, 12.13 * s, 14.38 * s, 11.17 * s, 13.53 * s)
      ..cubicTo(10.42 * s, 12.86 * s, 9.92 * s, 12.03 * s, 9.78 * s, 11.78 * s)
      ..cubicTo(9.64 * s, 11.53 * s, 9.77 * s, 11.40 * s, 9.89 * s, 11.28 * s)
      ..cubicTo(10.00 * s, 11.17 * s, 10.14 * s, 10.99 * s, 10.26 * s, 10.85 * s)
      ..cubicTo(10.38 * s, 10.71 * s, 10.42 * s, 10.61 * s, 10.50 * s, 10.45 * s)
      ..cubicTo(10.58 * s, 10.29 * s, 10.54 * s, 10.15 * s, 10.48 * s, 10.03 * s)
      ..cubicTo(10.42 * s, 9.91 * s, 9.94 * s, 8.72 * s, 9.74 * s, 8.26 * s)
      ..cubicTo(9.55 * s, 7.81 * s, 9.35 * s, 7.87 * s, 9.20 * s, 7.86 * s)
      ..cubicTo(9.06 * s, 7.85 * s, 8.90 * s, 7.85 * s, 8.74 * s, 7.85 * s)
      ..cubicTo(8.58 * s, 7.85 * s, 8.31 * s, 7.91 * s, 8.09 * s, 8.16 * s)
      ..cubicTo(7.87 * s, 8.41 * s, 7.25 * s, 8.99 * s, 7.25 * s, 10.19 * s)
      ..cubicTo(7.25 * s, 11.39 * s, 8.11 * s, 12.55 * s, 8.23 * s, 12.71 * s)
      ..cubicTo(8.35 * s, 12.87 * s, 9.92 * s, 15.27 * s, 12.33 * s, 16.32 * s)
      ..cubicTo(13.02 * s, 16.62 * s, 13.56 * s, 16.78 * s, 13.99 * s, 16.90 * s)
      ..cubicTo(14.67 * s, 17.09 * s, 15.29 * s, 17.07 * s, 15.78 * s, 17.00 * s)
      ..cubicTo(16.33 * s, 16.92 * s, 17.50 * s, 16.39 * s, 17.72 * s, 15.81 * s)
      ..cubicTo(17.94 * s, 15.23 * s, 17.94 * s, 14.73 * s, 17.87 * s, 14.62 * s)
      ..cubicTo(17.80 * s, 14.51 * s, 17.00 * s, 14.51 * s, 16.75 * s, 14.39 * s)
      ..close();
    canvas.drawPath(path, wp);
  }
  @override bool shouldRepaint(_) => false;
}

class _FacebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.08, s * 0.08, s * 0.84, s * 0.84),
        Radius.circular(s * 0.22),
      ),
      Paint()..color = const Color(0xFF1877F2),
    );
    final f = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final p = Path()
      ..moveTo(s * 0.615, s * 0.25)
      ..lineTo(s * 0.52, s * 0.25)
      ..cubicTo(s * 0.47, s * 0.25, s * 0.46, s * 0.27, s * 0.46, s * 0.32)
      ..lineTo(s * 0.46, s * 0.40)
      ..lineTo(s * 0.62, s * 0.40)
      ..lineTo(s * 0.595, s * 0.525)
      ..lineTo(s * 0.46, s * 0.525)
      ..lineTo(s * 0.46, s * 0.80)
      ..lineTo(s * 0.34, s * 0.80)
      ..lineTo(s * 0.34, s * 0.525)
      ..lineTo(s * 0.26, s * 0.525)
      ..lineTo(s * 0.26, s * 0.40)
      ..lineTo(s * 0.34, s * 0.40)
      ..lineTo(s * 0.34, s * 0.31)
      ..cubicTo(s * 0.34, s * 0.19, s * 0.41, s * 0.13, s * 0.54, s * 0.13)
      ..lineTo(s * 0.615, s * 0.13)
      ..close();
    canvas.drawPath(p, f);
  }
  @override bool shouldRepaint(_) => false;
}

class _InstagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final rect = Rect.fromLTWH(s * 0.08, s * 0.08, s * 0.84, s * 0.84);
    final rrect =
    RRect.fromRectAndRadius(rect, Radius.circular(s * 0.22));
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFF9CE34), Color(0xFFEE2A7B), Color(0xFF6228D7)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ).createShader(rect),
    );
    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.065;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(s / 2, s / 2), width: s * 0.52, height: s * 0.52),
        Radius.circular(s * 0.14),
      ),
      white,
    );
    canvas.drawCircle(Offset(s / 2, s / 2), s * 0.155, white);
    canvas.drawCircle(
      Offset(s * 0.64, s * 0.36), s * 0.055,
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
  }
  @override bool shouldRepaint(_) => false;
}

class _WebsitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2, cy = s / 2, r = s * 0.34;
    canvas.drawCircle(
      Offset(cx, cy), s * 0.44,
      Paint()..color = const Color(0xFF059669)..style = PaintingStyle.fill,
    );
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.055;
    canvas.drawCircle(Offset(cx, cy), r, p);
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), p);
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), p);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: r * 0.9, height: r * 2),
      p,
    );
  }
  @override bool shouldRepaint(_) => false;
}