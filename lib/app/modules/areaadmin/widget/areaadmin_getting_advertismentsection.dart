
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../data/models/area_admin_advertismentgetmodel.dart';
import '../controller/areaadmin_getting_advertismentcontroller.dart';
import '../view/area_adminhome.dart';
import '../view/areaadmin_updateadvertismentpage.dart';

class HomeAdvertisementWidget extends StatelessWidget {
  HomeAdvertisementWidget({super.key});

  final controller = Get.put(AreaAdminAdvertisementgetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF4F6CF7),
            ),
          ),
        );
      }

      if (controller.latestAds.isEmpty) {
        return const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.latestAds.length,
            itemBuilder: (context, index) {
              final ad = controller.latestAds[index];
              return AdCard(
                ad: ad,
                onEdit: () => Get.to(() => AreaAdminUpdateAdvertisementPage(adId: ad.id))
                    ?.then((result) {
                  if (result == true) controller.fetchAdvertisements();
                  Get.offAll(AreaAdminhomepage());
                }),
                onDelete: () {
                  _confirmDelete(context, ad);
                },
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      );
    });
  }

  void _confirmDelete(
      BuildContext context,
      AreaAdmingetAdvertisementModel advertisement,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Advertisement'),
        content: Text(
          'Are you sure you want to delete "${advertisement.advertisement}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // ✅ Correct delete call
              controller.deleteAdvertisement(advertisement.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }}
  class AdCard extends StatefulWidget {
  final dynamic ad;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdCard({
    super.key,
    required this.ad,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<AdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnim = _animController;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _animController.reverse(),
        onTapUp: (_) => _animController.forward(),
        onTapCancel: () => _animController.forward(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F6CF7).withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner Image ──────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18)),
                child: Stack(
                  children: [
                    Image.network(
                      widget.ad.bannerImage,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: const Color(0xFFF0F2FF),
                        child: const Center(
                          child: Icon(Icons.broken_image_outlined,
                              color: Color(0xFFB0BAF4), size: 40),
                        ),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 160,
                          color: const Color(0xFFF7F8FF),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF4F6CF7),
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Location badge on image
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 13, color: Color(0xFF4F6CF7)),
                            const SizedBox(width: 4),
                            Text(
                              widget.ad.mainLocation.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF4F6CF7),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content + Actions ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ad.advertisement,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xFF1A1D2E),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 11,
                                color: Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(widget.ad.createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ── Action Buttons ───────────────────────────
                    Row(
                      children: [
                        _ActionButton(
                          icon: Icons.edit_rounded,
                          color: const Color(0xFF4F6CF7),
                          bgColor: const Color(0xFFEEF1FF),
                          tooltip: 'Edit',
                          onTap: widget.onEdit,
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: Icons.delete_rounded,
                          color: const Color(0xFFFF5C5C),
                          bgColor: const Color(0xFFFFEEEE),
                          tooltip: 'Delete',
                          onTap: widget.onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _pressed
                ? widget.color.withOpacity(0.15)
                : widget.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(widget.icon, size: 18, color: widget.color),
        ),
      ),
    );
  }
}