
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../widgets/delete_widget.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../controller/advertisment_deletemerchantcontroller.dart';
import '../controller/merchant_advertismentlistcontroller.dart';

import 'addadvertisment.dart';
import 'merchnat_updateadvertismentpage.dart';

class MyAdvertisements extends StatelessWidget {
  MyAdvertisements({super.key});

  final MerchantAdvertisementGetController controller =
  Get.put(MerchantAdvertisementGetController());
  final DeleteAdvertisementController deleteCtrl =
  Get.put(DeleteAdvertisementController());

  static const Color _teal          = Color(0xFF00897B);
  static const Color _bg            = Color(0xFFF5F6FA);
  static const Color _card          = Colors.white;
  static const Color _textPrimary   = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _border        = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child:NetworkAwareWrapper(
        child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.kPrimary,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "My Advertisements",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: () async {
                  final result =
                  await Get.to(() => MerchantAddAdvertisementPage());
                  if (result == true) controller.fetchAdvertisements();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.18),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.add_rounded, size: 17, color: Colors.white),
                label: const Text(
                  "Add New",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          // ── Loading ──
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                      color: _teal, strokeWidth: 2.5),
                  const SizedBox(height: 14),
                  Text(
                    "Loading advertisements…",
                    style: TextStyle(fontSize: 13, color: _textSecondary),
                  ),
                ],
              ),
            );
          }

          // ── Empty State ──
          if (controller.ads.isEmpty) {
            return _buildEmptyState();
          }

          // ── List ──
          return RefreshIndicator(
            color: _teal,
            backgroundColor: Colors.white,
            onRefresh: controller.fetchAdvertisements,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: controller.ads.length,
              itemBuilder: (context, index) {
                final ad = controller.ads[index];
                return _buildAdCard(context, ad, index);
              },
            ),
          );
        }),
      ),
    ));
  }

  // ── EMPTY STATE ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.campaign_outlined,
                  size: 40, color: _teal.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            const Text(
              "No Advertisements Yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start promoting your business by\ncreating your first advertisement.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result =
                  await Get.to(() => MerchantAddAdvertisementPage());
                  if (result == true) controller.fetchAdvertisements();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  "Create Advertisement",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AD CARD ───────────────────────────────────────────────────────────────
  Widget _buildAdCard(
      BuildContext context, Map<String, dynamic> ad, int index) {
    final String? district    = ad["district"];
    final String? mainLocation = ad["main_location"];

    // Decide which location badge to show
    final bool hasDistrict = district != null && district.trim().isNotEmpty;
    final bool hasArea     = mainLocation != null && mainLocation.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + Overlays ─────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(13)),
                child: Image.network(
                  ad["image"],
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 170,
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(13)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined,
                            size: 36, color: _textSecondary),
                        const SizedBox(height: 6),
                        Text("Image unavailable",
                            style: TextStyle(
                                fontSize: 12, color: _textSecondary)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Obx(() {
                  final isDeleting = deleteCtrl.deletingIds.contains(ad['id']);
                  return GestureDetector(
                    onTap: isDeleting
                        ? null
                        : () => DeleteConfirmDialog.show(
                      context: Get.context!,
                      title: 'Delete Advertisement?',
                      message: '"${ad["title"]}" will be permanently removed and cannot be recovered.',
                      onConfirm: () => deleteCtrl.deleteAdvertisement(
                          ad["id"], () => controller.fetchAdvertisements()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: isDeleting
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                          : const Icon(Icons.delete_outline_rounded,
                          size: 16, color: Colors.red),
                    ),
                  );
                }),
              ),

              // ── Edit Button ───────────────────────────────────
              Positioned(
                top: 10,
                right: 60,
                child: GestureDetector(
                  onTap: () => Get.to(
                        () => const UpdateAdvertisementPage(),
                    arguments: {'advertisement_id': ad['id']},
                  )?.then((_) => controller.fetchAdvertisements()),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.edit_note,
                        size: 16, color: Colors.red),
                  ),
                ),
              ),

              // ── Active Status Badge (top-left) ────────────────
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Active",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),

          // ── Title + Location Row ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ad["title"] ?? "Untitled",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: _textSecondary),
                  ],
                ),

                // ── District / Area chip below title ─────────
                if (hasDistrict || hasArea) ...[
                  const SizedBox(height: 8),
                  _locationChip(
                    isDistrict: hasDistrict,
                    label: hasDistrict ? district! : mainLocation!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ── Location Chip (below title) ───────────────────────────────────────────
  Widget _locationChip({required bool isDistrict, required String label}) {
    final Color color =
    isDistrict ? const Color(0xFF1565C0) : const Color(0xFF6A1B9A);
    final IconData icon =
    isDistrict ? Icons.location_city_outlined : Icons.place_outlined;
    final String typeLabel = isDistrict ? "District" : "Area";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            "$typeLabel: $label",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

}