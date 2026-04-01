import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/add_advertismentcontroller.dart';

/// Navigate to this page like:
///   Get.to(
///     () => AdminEditAdvertisementPage(adId: ad['id']),
///     routeName: '/admin-edit-advertisement',
///   );
class AdminEditAdvertisementPage extends StatelessWidget {
  /// The advertisement ID passed from the list page.
  final String adId;

  const AdminEditAdvertisementPage({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    final AdminAdvertisementController controller =
    Get.find<AdminAdvertisementController>();

    // Fetch advertisement details as soon as page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSingleAdvertisement(adId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isFetchingAd.value) {
          return _buildShimmerLoader();
        }
        return _buildBody(context, controller);
      }),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar(AdminAdvertisementController controller) {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Edit Advertisement",
            style: AppTextStyle.rTextNunitoWhite17w700,
          ),
          Text(
            "ID: $adId",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        // Reload button
        Obx(() => IconButton(
          icon: controller.isFetchingAd.value
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          )
              : const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: controller.isFetchingAd.value
              ? null
              : () => controller.fetchSingleAdvertisement(adId),
        )),
        const SizedBox(width: 4),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  // ── Shimmer / Loading placeholder ──
  Widget _buildShimmerLoader() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _shimmerBox(height: 54),
        const SizedBox(height: 16),
        _shimmerBox(height: 20, width: 120),
        const SizedBox(height: 8),
        _shimmerBox(height: 52),
        const SizedBox(height: 20),
        _shimmerBox(height: 20, width: 120),
        const SizedBox(height: 8),
        _shimmerBox(height: 180),
        const SizedBox(height: 20),
        _shimmerBox(height: 20, width: 160),
        const SizedBox(height: 8),
        _shimmerBox(height: 52),
        _shimmerBox(height: 52),
        _shimmerBox(height: 52),
      ],
    );
  }

  Widget _shimmerBox({double height = 48, double? width}) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ── Main body ──
  Widget _buildBody(
      BuildContext context, AdminAdvertisementController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Meta info card ──
          _buildMetaCard(controller),
          const SizedBox(height: 20),

          // ── Editable: Title ──
          _sectionHeader(
            icon: Icons.edit_rounded,
            label: "Advertisement Title",
            color: AppColors.kPrimary,
            badge: "Editable",
            badgeColor: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 8),
          _buildTitleField(controller),
          const SizedBox(height: 22),

          // ── Editable: Banner image ──
          _sectionHeader(
            icon: Icons.image_rounded,
            label: "Banner Image",
            color: AppColors.kPrimary,
            badge: "Editable",
            badgeColor: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 8),
          _buildBannerSection(context, controller),
          const SizedBox(height: 24),

          // ── Locked fields ──
          _sectionHeader(
            icon: Icons.lock_rounded,
            label: "Locked Information",
            color: const Color(0xFF78909C),
            badge: "Read Only",
            badgeColor: const Color(0xFF546E7A),
          ),
          const SizedBox(height: 10),
          _buildLockedFields(controller),
          const SizedBox(height: 30),

          // ── Save button ──
          _buildSaveButton(controller),
        ],
      ),
    );
  }

  // ── Meta info card (type + posted by) ──
  Widget _buildMetaCard(AdminAdvertisementController controller) {
    return Obx(() {
      final type = controller.editCreatedByType.value;
      final typeColor = _typeColor(type);
      final typeLabel = _typeLabel(type);

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: typeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: typeColor.withOpacity(0.25), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_typeIcon(type), color: typeColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Ad #$adId",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: typeColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _pill(typeLabel, typeColor),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    controller.editCreatedAt.value.isNotEmpty
                        ? "Posted: ${_formatDate(controller.editCreatedAt.value)}"
                        : "Loading details...",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Section header with badge ──
  Widget _sectionHeader({
    required IconData icon,
    required String label,
    required Color color,
    String? badge,
    Color? badgeColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.2,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          _pill(badge, badgeColor ?? color),
        ],
      ],
    );
  }

  // ── Title field (editable) ──
  Widget _buildTitleField(AdminAdvertisementController controller) {
    return Obx(() => TextField(
      controller: controller.editAdName,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: "Enter advertisement title...",
        hintStyle:
        TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: const Icon(Icons.campaign_rounded,
            color: AppColors.kPrimary, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: controller.editIsTitleEmpty.value
                ? Colors.red.shade400
                : Colors.grey.shade200,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.kPrimary, width: 1.8),
        ),
        errorText: controller.editIsTitleEmpty.value
            ? "Title is required"
            : null,
      ),
      onChanged: (_) {
        if (controller.editIsTitleEmpty.value) {
          controller.editIsTitleEmpty.value = false;
        }
      },
    ));
  }

  // ── Banner image section (editable) ──
  Widget _buildBannerSection(
      BuildContext context, AdminAdvertisementController controller) {
    return Obx(() {
      final localFile = controller.editBannerImage.value;
      final networkUrl = controller.editNetworkBannerUrl.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview
          GestureDetector(
            onTap: controller.pickEditBannerImage,
            child: Container(
              height: 185,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
              ),
              clipBehavior: Clip.hardEdge,
              child: localFile != null
                  ? _localImagePreview(localFile, controller)
                  : networkUrl.isNotEmpty
                  ? _networkImagePreview(networkUrl)
                  : _imagePlaceholder(),
            ),
          ),
          const SizedBox(height: 10),

          // Buttons row
          Row(
            children: [
              Expanded(
                child: _outlineBtn(
                  icon: Icons.photo_library_rounded,
                  label: localFile != null ? "Change Again" : "Change Image",
                  color: AppColors.kPrimary,
                  onTap: controller.pickEditBannerImage,
                ),
              ),
              if (localFile != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _outlineBtn(
                    icon: Icons.undo_rounded,
                    label: "Revert",
                    color: Colors.orange.shade700,
                    onTap: controller.removeEditBannerImage,
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    });
  }

  Widget _localImagePreview(
      File file, AdminAdvertisementController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(file, fit: BoxFit.cover),
        // Dark overlay
        Container(color: Colors.black26),
        // "New" badge
        const Positioned(
          top: 10,
          left: 10,
          child: _NewImageBadge(),
        ),
        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: controller.removeEditBannerImage,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child:
              const Icon(Icons.close_rounded, color: Colors.white, size: 14),
            ),
          ),
        ),
        const Center(
          child: Icon(Icons.check_circle_rounded,
              color: Colors.white70, size: 36),
        ),
      ],
    );
  }

  Widget _networkImagePreview(String url) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Container(
            color: Colors.grey.shade100,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorBuilder: (_, __, ___) => _imagePlaceholder(),
        ),
        // Tap-to-edit overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Icon(Icons.photo_camera_rounded, color: Colors.white70, size: 22),
              SizedBox(height: 4),
              Text(
                "Tap to replace image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_rounded,
            size: 42, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          "Tap to select image",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Locked fields section ──
  Widget _buildLockedFields(AdminAdvertisementController controller) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          // Main location
          _lockedFieldTile(
            icon: Icons.location_on_rounded,
            label: "Main Location",
            value: controller.editMainLocation.value.isNotEmpty
                ? controller.editMainLocation.value
                : "—",
            iconColor: const Color(0xFF6A1B9A),
            isFirst: true,
          ),
          _divider(),

          // District
          _lockedFieldTile(
            icon: Icons.map_rounded,
            label: "District",
            value: controller.editDistrict.value.isNotEmpty
                ? controller.editDistrict.value
                : "—",
            iconColor: const Color(0xFF00695C),
          ),
          _divider(),

          // Event location
          _lockedFieldTile(
            icon: Icons.event_available_rounded,
            label: "Event Location",
            value: controller.editEventLocation.value.isNotEmpty
                ? controller.editEventLocation.value
                : "—",
            iconColor: const Color(0xFFBF360C),
          ),
          _divider(),

          // Created by
          _lockedFieldTile(
            icon: Icons.person_rounded,
            label: "Posted By",
            value:
            "${_typeLabel(controller.editCreatedByType.value)} (ID: ${controller.editCreatedById.value})",
            iconColor: _typeColor(controller.editCreatedByType.value),
          ),
          _divider(),

          // Posted on
          _lockedFieldTile(
            icon: Icons.access_time_rounded,
            label: "Posted On",
            value: controller.editCreatedAt.value.isNotEmpty
                ? _formatDate(controller.editCreatedAt.value)
                : "—",
            iconColor: Colors.blueGrey,
            isLast: true,
          ),
        ],
      ),
    ));
  }

  Widget _lockedFieldTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(14) : Radius.zero,
          bottom: isLast ? const Radius.circular(14) : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Lock icon
          Icon(Icons.lock_outline_rounded, size: 14, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey.shade100,
    indent: 14,
    endIndent: 14,
  );

  // ── Save button ──
  Widget _buildSaveButton(AdminAdvertisementController controller) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: controller.isEditLoading.value
            ? null
            : controller.updateAdvertisement,
        icon: controller.isEditLoading.value
            ? const SizedBox(
          width: 19,
          height: 19,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.2),
        )
            : const Icon(Icons.save_rounded, color: Colors.white, size: 20),
        label: Text(
          controller.isEditLoading.value
              ? "Saving Changes..."
              : "Save Changes",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimary,
          disabledBackgroundColor: AppColors.kPrimary.withOpacity(0.55),
          elevation: 3,
          shadowColor: AppColors.kPrimary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ));
  }

  // ─────────────────────────────────────────────
  //  Helpers
  // ─────────────────────────────────────────────
  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _outlineBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'district_admin':
        return Icons.location_city_rounded;
      case 'area_admin':
        return Icons.holiday_village_rounded;
      case 'merchant':
        return Icons.storefront_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'admin':
        return const Color(0xFF1565C0);
      case 'district_admin':
        return const Color(0xFF2E7D32);
      case 'area_admin':
        return const Color(0xFF6A1B9A);
      case 'merchant':
        return const Color(0xFFE65100);
      default:
        return Colors.grey.shade600;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'admin':
        return 'Admin';
      case 'district_admin':
        return 'District Admin';
      case 'area_admin':
        return 'Area Admin';
      case 'merchant':
        return 'Merchant';
      default:
        return type.isEmpty ? '—' : type;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}, "
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }
}

// Separate const widget to avoid closure issues in Stack
class _NewImageBadge extends StatelessWidget {
  const _NewImageBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            "New image",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}