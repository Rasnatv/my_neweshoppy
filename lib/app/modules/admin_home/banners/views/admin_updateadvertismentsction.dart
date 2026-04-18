
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../controller/admin_updateadvertismnetcontroller.dart';

class AdminEditAdvertisementPage extends StatefulWidget {
  final String adId;

  const AdminEditAdvertisementPage({super.key, required this.adId});

  @override
  State<AdminEditAdvertisementPage> createState() =>
      _AdminEditAdvertisementPageState();
}

class _AdminEditAdvertisementPageState
    extends State<AdminEditAdvertisementPage> {
  static const _kPrimary = AppColors.kPrimary;

  final AdminupdateAdvertisementController controller =
  Get.put(AdminupdateAdvertisementController());

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      controller.fetchSingleAdvertisement(widget.adId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isFetchingAd.value) {
          return _buildShimmerLoader();
        }
        return _buildBody(context);
      }),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: const Text(
        "Edit Advertisement",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      actions: [
        Obx(() => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: _kPrimary.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: controller.isFetchingAd.value
                ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: _kPrimary,
                strokeWidth: 2,
              ),
            )
                : Icon(Icons.refresh_rounded, color: _kPrimary, size: 20),
            onPressed: controller.isFetchingAd.value
                ? null
                : () => controller.fetchSingleAdvertisement(widget.adId),
          ),
        )),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEEFF3)),
      ),
    );
  }

  // ── Body ──
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetaCard(),
          const SizedBox(height: 24),

          _buildCard(
            children: [
              _sectionHeader(
                icon: Icons.title_rounded,
                label: "Advertisement Title",
                badge: "Editable",
                badgeColor: const Color(0xFF2D9CDB),
              ),
              const SizedBox(height: 14),
              _buildTitleField(),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            children: [
              _sectionHeader(
                icon: Icons.image_rounded,
                label: "Banner Image",
                badge: "Editable",
                badgeColor: const Color(0xFF2D9CDB),
              ),
              const SizedBox(height: 14),
              _buildBannerSection(context),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            children: [
              _sectionHeader(
                icon: Icons.public_rounded,
                label: "Region Info",
                badge: "Editable",
                badgeColor: const Color(0xFF2D9CDB),
              ),
              const SizedBox(height: 14),
              _buildRegionDropdowns(),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            backgroundColor: const Color(0xFFFAFAFB),
            children: [
              _sectionHeader(
                icon: Icons.lock_outline_rounded,
                label: "Locked Information",
                badge: "Read Only",
                badgeColor: const Color(0xFF9E9E9E),
              ),
              const SizedBox(height: 14),
              _buildLockedFields(),
            ],
          ),

          const SizedBox(height: 28),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // ── Reusable card wrapper ──
  Widget _buildCard({
    required List<Widget> children,
    Color? backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
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
        children: children,
      ),
    );
  }

  // ── Meta card ──
  Widget _buildMetaCard() {
    return Obx(() => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _kPrimary,
            _kPrimary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.campaign_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ad ID: ${widget.adId}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "By: ${controller.editCreatedByType.value.isNotEmpty ? controller.editCreatedByType.value : '—'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Editing",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // ── Region dropdowns ──
  Widget _buildRegionDropdowns() {
    return Obx(() => Column(
      children: [
        _buildDropdownField(
          label: 'State',
          icon: Icons.map_outlined,
          value: controller.selectedEditState.value,
          items: controller.statesList,
          isLoading: controller.isLoadingStates.value,
          onChanged: (v) => controller.selectedEditState.value = v,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'District',
          icon: Icons.location_city_outlined,
          value: controller.selectedEditDistrict.value,
          items: controller.districtsList,
          isLoading: controller.isLoadingDistricts.value,
          onChanged: (v) => controller.selectedEditDistrict.value = v,
        ),
        if (controller.showMainLocationDropdown) ...[
          const SizedBox(height: 12),
          _buildDropdownField(
            label: 'Main Location',
            icon: Icons.place_outlined,
            value: controller.selectedEditArea.value,
            items: controller.areasList,
            isLoading: controller.isLoadingAreas.value,
            onChanged: (v) => controller.selectedEditArea.value = v,
          ),
        ],
      ],
    ));
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required bool isLoading,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value?.isNotEmpty == true ? value : null,
      icon: isLoading
          ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF9E9EA7)),
      items: items
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e,
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF1A1A2E))),
      ))
          .toList(),
      onChanged: isLoading ? null : onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        const TextStyle(color: Color(0xFF9E9EA7), fontSize: 13),
        prefixIcon: Icon(icon, color: _kPrimary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF9F9FB),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _kPrimary, width: 1.5),
        ),
      ),
    );
  }

  // ── Title field ──
  Widget _buildTitleField() {
    return Obx(() => TextField(
      controller: controller.editAdName,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1A1A2E),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: "Enter advertisement title",
        hintStyle:
        const TextStyle(color: Color(0xFFBDBDC7), fontSize: 14),
        prefixIcon:
        Icon(Icons.edit_outlined, color: _kPrimary, size: 20),
        errorText: controller.editIsTitleEmpty.value ? "Title is required" : null,
        filled: true,
        fillColor: const Color(0xFFF9F9FB),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _kPrimary, width: 1.5),
        ),
      ),
    ));
  }

  // ── Banner section ──
  Widget _buildBannerSection(BuildContext context) {
    return Obx(() {
      final file = controller.editBannerImage.value;
      final url = controller.editNetworkBannerUrl.value;
      final hasImage = file != null || url.isNotEmpty;

      return GestureDetector(
        onTap: controller.pickEditBannerImage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 190,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasImage ? _kPrimary.withOpacity(0.4) : const Color(0xFFDDDDE8),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: file != null
                ? Stack(
              fit: StackFit.expand,
              children: [
                Image.file(file, fit: BoxFit.cover),
                _buildImageOverlay(),
              ],
            )
                : url.isNotEmpty
                ? Stack(
              fit: StackFit.expand,
              children: [
                Image.network(url, fit: BoxFit.cover),
                _buildImageOverlay(),
              ],
            )
                : _buildEmptyBanner(),
          ),
        ),
      );
    });
  }

  Widget _buildImageOverlay() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_rounded, color: Colors.white, size: 13),
            SizedBox(width: 5),
            Text("Change",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBanner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _kPrimary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_photo_alternate_outlined,
              color: _kPrimary, size: 28),
        ),
        const SizedBox(height: 10),
        const Text(
          "Tap to upload banner image",
          style: TextStyle(
            color: Color(0xFF9E9EA7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "JPG, PNG supported",
          style: TextStyle(color: Color(0xFFBDBDC7), fontSize: 11),
        ),
      ],
    );
  }

  // ── Locked fields ──
  Widget _buildLockedFields() {
    return Obx(() => Column(
      children: [
        _buildLockedTile(
          icon: Icons.calendar_today_outlined,
          label: "Posted On",
          value: controller.editCreatedAt.value.isNotEmpty
              ? controller.editCreatedAt.value
              : '—',
        ),
      ],
    ));
  }

  Widget _buildLockedTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFBDBDC7), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF9E9EA7),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: Color(0xFF555566),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.lock_outline_rounded,
              color: Color(0xFFCCCCD6), size: 15),
        ],
      ),
    );
  }

  // ── Save button ──
  Widget _buildSaveButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isEditLoading.value
            ? null
            : controller.updateAdvertisement,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimary,
          disabledBackgroundColor: _kPrimary.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: controller.isEditLoading.value
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.5),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Save Changes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // ── Section header ──
  Widget _sectionHeader({
    required IconData icon,
    required String label,
    required String badge,
    required Color badgeColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: badgeColor, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.25)),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  // ── Shimmer loader ──
  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          4,
              (i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _shimmerBox(height: i == 1 ? 190 : 90),
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}