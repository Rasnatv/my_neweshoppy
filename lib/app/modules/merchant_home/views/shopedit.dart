
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../../merchantlogin/view/merchantmap.dart';
import '../controller/merchantsetting_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MerchantSettingPage extends StatelessWidget {
  final MerchantUpdateController controller =
  Get.put(MerchantUpdateController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child:NetworkAwareWrapper(
        child:  Scaffold(
        backgroundColor: AppColors.bg,
        appBar: _appBar(),
        body: Obx(() => controller.isLoading.value
            ? _loadingView()
            : _body()),
      ),
    ));
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: AppColors.kPrimary,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
      "Edit Profile",
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
    actions: [
      Obx(() => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          child: GestureDetector(
            onTap: controller.isUpdating.value
                ? null
                : () => controller.updateMerchant(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: controller.isUpdating.value
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: controller.isUpdating.value
                  ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.kPrimary,
                ),
              )
                  : const Text(
                "Save",
                style: TextStyle(
                  color: AppColors.kPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      )),
    ],
  );

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _loadingView() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
            color: AppColors.kPrimary, strokeWidth: 2.5),
        SizedBox(height: 18),
        Text(
          "Loading profile…",
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 18),
            child: GetBuilder<MerchantUpdateController>(
              builder: (c) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.ownerCtrl.text.isNotEmpty
                        ? c.ownerCtrl.text
                        : "Your Name",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      AppColorship(
                        icon: Icons.storefront_outlined,
                        label: c.shopCtrl.text.isNotEmpty
                            ? c.shopCtrl.text
                            : "Shop Name",
                        color: AppColors.shopIcon,
                        bgColor: AppColors.shopIconBg,
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
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.shopIconBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: c.pickedImage != null
                  ? Image.file(c.pickedImage!, fit: BoxFit.cover)
                  : c.networkImage.isNotEmpty
                  ? Image.network(c.networkImage, fit: BoxFit.cover)
                  : const Icon(Icons.storefront_outlined,
                  size: 32, color: AppColors.shopIcon),
            ),
            Positioned(
              bottom: -3,
              right: -3,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt,
                    color: Colors.white, size: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AppColorship({
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
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _activeDot() => Row(
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
            color: AppColors.success, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      const Text(
        "Active",
        style: TextStyle(
            fontSize: 11,
            color: AppColors.success,
            fontWeight: FontWeight.w600),
      ),
    ],
  );

  // ── Section Label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Row(
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.9,
        ),
      ),
      const SizedBox(width: 10),
      const Expanded(
          child:
          Divider(color: AppColors.border, thickness: 1, height: 1)),
    ],
  );

  // ── Basic Details Group ───────────────────────────────────────────────────
  Widget _basicDetailsGroup() {
    return AppColorsardGroup(
      children: [
        _EditableRow(
          label: "Owner Name",
          ctrl: controller.ownerCtrl,
          iconWidget: _iconBox(
              Icons.person_outline, AppColors.ownerIcon, AppColors.ownerIconBg),
          keyboardType: TextInputType.name,
        ),
        _EditableRow(
          label: "Shop Name",
          ctrl: controller.shopCtrl,
          iconWidget: _iconBox(
              Icons.storefront_outlined, AppColors.shopIcon, AppColors.shopIconBg),
          keyboardType: TextInputType.text,
        ),
        _LockedRow(
          label: "Email Address",
          ctrl: controller.emailCtrl,
          iconWidget: _iconBox(
            Icons.email_outlined,
            AppColors.textMuted,
            const Color(0xFFF3F4F6),
          ),
        ),
        _EditableRow(
          label: "Phone Number 1",
          ctrl: controller.phone1Ctrl,
          iconWidget: _iconBox(
              Icons.phone_outlined, AppColors.phoneIcon, AppColors.phoneIconBg),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        _EditableRow(
          label: "Phone Number 2",
          ctrl: controller.phone2Ctrl,
          iconWidget: _iconBox(
              Icons.phone_outlined, AppColors.phoneIcon, AppColors.phoneIconBg),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          isLast: true,
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }

  // ── Location Dropdowns ────────────────────────────────────────────────────
  Widget _locationDropdowns() {
    return AppColorsardGroup(
      children: [
        Obx(() => _DropdownRow(
          label: "State",
          value: controller.selectedState.value.isEmpty
              ? null
              : controller.selectedState.value,
          items: controller.states,
          onChanged: (v) {
            if (v != null) {
              controller.selectedState.value = v;
              controller.fetchDistricts(v);
            }
          },
          iconWidget: _iconBox(
              Icons.flag_outlined, AppColors.stateIcon, AppColors.stateIconBg),
          isLoading: controller.isLoadingStates.value,
        )),
        Obx(() {
          if (controller.selectedState.value.isEmpty) return const SizedBox();
          return _DropdownRow(
            label: "District",
            value: controller.selectedDistrict.value.isEmpty
                ? null
                : controller.selectedDistrict.value,
            items: controller.districts,
            onChanged: (v) {
              if (v != null) {
                controller.selectedDistrict.value = v;
                controller.fetchLocations(
                    controller.selectedState.value, v);
              }
            },
            iconWidget: _iconBox(
              Icons.location_on_outlined,
              AppColors.districtIcon,
              AppColors.districtIconBg,
            ),
            isLoading: controller.isLoadingDistricts.value,
          );
        }),
        Obx(() {
          if (controller.selectedDistrict.value.isEmpty) return const SizedBox();
          return _DropdownRow(
            label: "Main Location",
            value: controller.selectedLocation.value.isEmpty
                ? null
                : controller.selectedLocation.value,
            items: controller.locations,
            onChanged: (v) {
              if (v != null) controller.selectedLocation.value = v;
            },
            iconWidget: _iconBox(
              Icons.place_outlined,
              AppColors.pinIcon,
              AppColors.pinIconBg,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                top: 10,
                right: 10,
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
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 12, color: AppColors.mapBtnFg),
                        SizedBox(width: 4),
                        Text(
                          "Change",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mapBtnFg,
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
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: hasLoc
                              ? AppColors.successBg
                              : AppColors.pinIconBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          hasLoc
                              ? Icons.check_circle_outline_outlined
                              : Icons.location_on_outlined,
                          size: 16,
                          color: hasLoc ? AppColors.success : AppColors.pinIcon,
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
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              controller.pickedLocation.value.isNotEmpty
                                  ? controller.pickedLocation.value
                                  : "No location selected yet",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: controller.pickedLocation.value.isNotEmpty
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
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
                        AppColorsoordChip("LAT",
                            controller.latitude.value.toStringAsFixed(6)),
                        const SizedBox(width: 8),
                        AppColorsoordChip("LNG",
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
                            ? "Detecting…"
                            : "Use GPS",
                        icon: Icons.my_location,
                        fgColor: AppColors.gpsBtnFg,
                        bgColor: AppColors.gpsBtnBg,
                        isPrimary: false,
                        isLoading:
                        controller.isGettingCurrentLocation.value,
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
                        bgColor: AppColors.mapBtnFg,
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

  Widget AppColorsoordChip(String axis, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFB),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$axis  ",
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: AppColors.stateIcon,
            letterSpacing: 0.4,
          ),
        ),
        Text(
          val,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecond,
          ),
        ),
      ],
    ),
  );

  Widget _locBtn({
    required String label,
    required IconData icon,
    required Color fgColor,
    required Color bgColor,
    required bool isPrimary,
    bool isLoading = false,
    VoidCallback? onTap,
  }) =>
      GestureDetector(
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
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: fgColor),
                )
              else
                Icon(icon, size: 14, color: fgColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: fgColor),
              ),
            ],
          ),
        ),
      );

  // ── Social Fields ─────────────────────────────────────────────────────────
  Widget _socialFields() {
    return AppColorsardGroup(
      children: [
        _SocialRow(
          label: "WhatsApp",
          ctrl: controller.whatsappCtrl,
          hint: "9876543210  (optional)",
          svgAsset: "assets/images/icons/whatsapp.svg",
          iconColor: AppColors.whatsappColor,
          iconBg: AppColors.whatsappBg,
          keyboardType: TextInputType.phone,
          isUrlField: false,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        _SocialRow(
          label: "Facebook",
          ctrl: controller.facebookCtrl,
          hint: "https://facebook.com/yourpage  (optional)",
          svgAsset: "assets/images/icons/facebook-.svg",
          iconColor: AppColors.facebookColor,
          iconBg: AppColors.facebookBg,
          keyboardType: TextInputType.url,
          isUrlField: true,   // ✅ URL validation enabled
        ),
        _SocialRow(
          label: "Instagram",
          ctrl: controller.instagramCtrl,
          hint: "https://instagram.com/yourhandle  (optional)",
          svgAsset: "assets/images/icons/insta.svg",
          iconColor: AppColors.instagramColor,
          iconBg: AppColors.instagramBg,
          keyboardType: TextInputType.url,
          isUrlField: true,   // ✅ URL validation enabled
        ),
        _SocialRow(
          label: "Website",
          ctrl: controller.websiteCtrl,
          hint: "https://yourwebsite.com  (optional)",
          svgAsset: "assets/images/icons/web.svg",
          iconColor: AppColors.websiteColor,
          iconBg: AppColors.websiteBg,
          keyboardType: TextInputType.url,
          isUrlField: true,   // ✅ URL validation enabled
          isLast: true,
        ),
      ],
    );
  }

  // ── Save Button ───────────────────────────────────────────────────────────
  Widget _saveButton() => Obx(() => GestureDetector(
    onTap: controller.isUpdating.value
        ? null
        : () => controller.updateMerchant(),
    child: Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: controller.isUpdating.value
            ? AppColors.textMuted
            : AppColors.kPrimary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: controller.isUpdating.value
            ? []
            : [
          BoxShadow(
            color: AppColors.kPrimary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: controller.isUpdating.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.5),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Save Changes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
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
//  Card Group
// ─────────────────────────────────────────────────────────────────────────────
class AppColorsardGroup extends StatelessWidget {
  final List<Widget> children;
  const AppColorsardGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Editable Row
// ─────────────────────────────────────────────────────────────────────────────
class _EditableRow extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final Widget iconWidget;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isLast;

  const _EditableRow({
    required this.label,
    required this.ctrl,
    required this.iconWidget,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
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
            color: _focused ? AppColors.focusBg : AppColors.surface,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _focused
                        ? AppColors.focusAccent
                        : Colors.transparent,
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
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.focusAccent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.edit,
                          size: 15, color: Colors.white),
                    )
                        : widget.iconWidget,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.ctrl,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      labelStyle: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
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
                    color: _focused ? AppColors.focusAccent : AppColors.border,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isLast)
          const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
              indent: 62),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Locked Row
// ─────────────────────────────────────────────────────────────────────────────
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
          color: AppColors.locked,
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
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      ctrl.text.isNotEmpty ? ctrl.text : "—",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lockedText,
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
                    border: Border.all(color: AppColors.lockedBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          size: 10, color: AppColors.textMuted),
                      SizedBox(width: 3),
                      Text(
                        "Locked",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          letterSpacing: 0.2,
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
            height: 1,
            thickness: 1,
            color: AppColors.divider,
            indent: 62),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Social Row  (with live URL validation)
// ─────────────────────────────────────────────────────────────────────────────
class _SocialRow extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final String svgAsset;
  final Color iconColor;
  final Color iconBg;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isUrlField;   // ← true for Facebook / Instagram / Website
  final bool isLast;

  const _SocialRow({
    required this.label,
    required this.ctrl,
    required this.hint,
    required this.svgAsset,
    required this.iconColor,
    required this.iconBg,
    this.keyboardType = TextInputType.url,
    this.inputFormatters,
    this.isUrlField = false,
    this.isLast = false,
  });

  @override
  State<_SocialRow> createState() => _SocialRowState();
}

class _SocialRowState extends State<_SocialRow> {
  bool _focused = false;
  String? _errorText;

  // ── Validate URL (empty = OK because field is optional) ──────────────────
  bool _isValidUrl(String url) {
    if (url.trim().isEmpty) return true;
    final uri = Uri.tryParse(url.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  void _validate() {
    if (!widget.isUrlField) return;
    setState(() {
      _errorText = _isValidUrl(widget.ctrl.text)
          ? null
          : "Enter a valid URL starting with https://";
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (f) {
            setState(() => _focused = f);
            if (!f) _validate(); // validate when user leaves the field
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: hasError
                ? Colors.red.withOpacity(0.04)
                : _focused
                ? AppColors.focusBg
                : AppColors.surface,
            child: Row(
              children: [
                // ── Left accent bar ─────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3,
                  height: 60,
                  decoration: BoxDecoration(
                    color: hasError
                        ? Colors.red
                        : _focused
                        ? AppColors.focusAccent
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),

                // ── Icon ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 13, right: 12),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _focused
                          ? widget.iconBg.withOpacity(0.7)
                          : widget.iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      widget.svgAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // ── Text field ────────────────────────────────────────────
                Expanded(
                  child: TextField(
                    controller: widget.ctrl,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    onChanged: (val) {
                      // Clear error as soon as user starts typing again
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      hintText: widget.hint,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: hasError ? Colors.red : AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                // ── Trailing icon ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    hasError
                        ? Icons.error_outline_rounded
                        : Icons.chevron_right_rounded,
                    size: 15,
                    color: hasError
                        ? Colors.red
                        : _focused
                        ? AppColors.focusAccent
                        : AppColors.border,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Inline error message ──────────────────────────────────────────
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 62, bottom: 6, top: 2),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 11, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  _errorText!,
                  style: const TextStyle(fontSize: 11, color: Colors.red),
                ),
              ],
            ),
          ),

        if (!widget.isLast)
          const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
              indent: 62),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Dropdown Row
// ─────────────────────────────────────────────────────────────────────────────
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
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.stateIcon),
            ),
            const SizedBox(width: 12),
            Text(
              "Loading $label…",
              style:
              const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }
    if (items.isEmpty) return const SizedBox();
    return Column(
      children: [
        Container(
          color: AppColors.surface,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  dropdownColor: AppColors.surface,
                  icon: const Icon(Icons.unfold_more_rounded,
                      size: 16, color: AppColors.textMuted),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
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
              height: 1,
              thickness: 1,
              color: AppColors.divider,
              indent: 62),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Map Preview
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
              painter: _MapGridPainter()),
          CustomPaint(
              size: const Size(double.infinity, 128),
              painter: _RoadPainter()),
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pinIcon.withOpacity(0.06),
                border: Border.all(
                  color: AppColors.pinIcon.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.pinIcon,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pinIcon.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: const Icon(Icons.location_on,
                        color: Colors.white, size: 17),
                  ),
                ),
                Container(
                  width: 10,
                  height: 4,
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

  @override
  bool shouldRepaint(_) => false;
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

  @override
  bool shouldRepaint(_) => false;
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

  @override
  bool shouldRepaint(_) => false;
}