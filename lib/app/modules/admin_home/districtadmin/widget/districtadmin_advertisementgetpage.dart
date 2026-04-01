
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/districtadmin_advertismnetgetmodel.dart';
import '../controller/districtadminadvertismentgetcontroller.dart';

class DistrictAdminHomeAdvertisementWidget extends StatelessWidget {
  DistrictAdminHomeAdvertisementWidget({super.key});

  final controller = Get.put(DistrictAdminAdvertisementGetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.latestAds.isEmpty) {
        return const SizedBox();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: controller.latestAds.length,
        itemBuilder: (context, index) {
          final ad = controller.latestAds[index];

          return DistrictAdCard(
            ad: ad,
            onEdit: () async {
              final updated = await Get.toNamed(
                '/districtadminadvupdation',
                arguments: {'advertisement_id': ad.id}, // ✅ ad.id is already a String
              );
              if (updated == true) {
                controller.fetchAdvertisements();
              }
            },
            onDelete: () => _confirmDelete(context, ad),
          );
        },
      );
    });
  }

  void _confirmDelete(
      BuildContext context,
      DistrictAdminGetAdvertisementModel advertisement) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Advertisement'),
        content: Text('Delete "${advertisement.advertisement}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(() => TextButton(
          onPressed: controller.isDeleting.value
    ? null
        : () {
    Navigator.pop(context);
    controller.deleteAdvertisement(advertisement.id); // ✅ uncommented
    },
            child: controller.isDeleting.value
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          )),
        ],
      ),
    );
  }
}

class DistrictAdCard extends StatefulWidget {
  final DistrictAdminGetAdvertisementModel ad;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DistrictAdCard({
    super.key,
    required this.ad,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<DistrictAdCard> createState() => _DistrictAdCardState();
}

class _DistrictAdCardState extends State<DistrictAdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animController,
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// IMAGE
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  children: [
                    Image.network(
                      widget.ad.bannerImage,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    /// DISTRICT
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.ad.district.isEmpty
                              ? "ALL DISTRICTS"
                              : widget.ad.district.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    /// CREATED BY BADGE
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _buildCreatedByBadge(widget.ad.createdByType),
                    ),
                  ],
                ),
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.ad.advertisement,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (widget.ad.createdByType != "admin") ...[
                      _ActionButton(
                        icon: Icons.edit,
                        color: Colors.blue,
                        bgColor: Colors.blue.shade50,
                        tooltip: "Edit",
                        onTap: widget.onEdit,
                      ),
                      const SizedBox(width: 6),
                      _ActionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        bgColor: Colors.red.shade50,
                        tooltip: "Delete",
                        onTap: widget.onDelete,
                      ),
                    ]
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

/// BADGE
Widget _buildCreatedByBadge(String type) {
  Color bgColor;
  String label;
  IconData icon;

  switch (type) {
    case "admin":
      bgColor = Colors.black;
      label = "ADMIN";
      icon = Icons.verified;
      break;
    case "district_admin":
      bgColor = Colors.blue;
      label = "DISTRICT";
      icon = Icons.location_city;
      break;
    case "merchant":
      bgColor = Colors.green;
      label = "MERCHANT";
      icon = Icons.store;
      break;
    default:
      bgColor = Colors.grey;
      label = "UNKNOWN";
      icon = Icons.help_outline;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

/// ACTION BUTTON
class _ActionButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}