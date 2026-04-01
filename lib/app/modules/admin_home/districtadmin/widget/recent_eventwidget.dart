

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/districtadmineventmodel.dart';
import '../controller/districtadmin_eventgettingcontroller.dart';
import '../view/districtadmin_eventupdatepage.dart';

class DistrictAdminRecentEventsWidget extends StatelessWidget {
  DistrictAdminRecentEventsWidget({super.key});

  final controller = Get.put(DistrictAdminGettingEventController());

  String _formatDate(String raw) {
    if (raw.isEmpty) return '—';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _formatCreatedAt(String raw) => raw;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.hasError.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: controller.fetchEvents,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.recentEvents.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No events found',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentEvents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) => DistrictAdminEventCard(
          event: controller.recentEvents[index],
          formatDate: _formatDate,
          formatCreatedAt: _formatCreatedAt,
          onDelete: () => _confirmDelete(context, controller.recentEvents[index]),
          // ✅ pass onEdit with refresh callback
          onEdit: () => _navigateToEdit(controller.recentEvents[index]),
        ),
      );
    });
  }

  // void _confirmDelete(BuildContext context, DistrictAdminEventModel event) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Delete Event'),
  //       content: Text('Are you sure you want to delete "${event.eventName}"?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             controller.deleteEvent(event.id);
  //           },
  //           child: const Text('Delete', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // // ✅ Navigate to update page, refresh list only when update succeeds
  void _confirmDelete(BuildContext context, DistrictAdminEventModel event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.eventName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(() => TextButton(
            onPressed: controller.isDeleting.value
                ? null // ✅ disable when deleting
                : () async {
              Navigator.pop(context);

              await controller.deleteEvent(event.id);

              // ✅ Refresh after delete
              controller.fetchEvents();
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
  void _navigateToEdit(DistrictAdminEventModel event) {
    Get.to(() => DistrictAdminUpdateEventPage(eventId: event.id))
        ?.then((result) {
      if (result == true) controller.fetchEvents();
    });
  }
}

// ─── Card Widget ─────────────────────────────────────────────────────────────

class DistrictAdminEventCard extends StatelessWidget {
  const DistrictAdminEventCard({
    super.key,
    required this.event,
    required this.formatDate,
    required this.formatCreatedAt,
    required this.onDelete,
    required this.onEdit,
  });

  final DistrictAdminEventModel event;
  final String Function(String) formatDate;
  final String Function(String) formatCreatedAt;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  static const _indigo   = Color(0xFF4F46E5);
  static const _indigoBg = Color(0xFFEEEDFE);
  static const _green    = Color(0xFF059669);
  static const _red      = Color(0xFFDC2626);
  static const _slate900 = Color(0xFF0F172A);
  static const _slate500 = Color(0xFF64748B);
  static const _slate400 = Color(0xFF94A3B8);
  static const _divider  = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          splashColor: _indigo.withOpacity(0.04),
          highlightColor: _indigo.withOpacity(0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topRow(),
              _dividerLine(),
              _dateTimeRow(),
              _dividerLine(),
              _actionRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topRow() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              event.bannerImage,
              width: 82,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 82,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 26,
                  color: Color(0xFFCBD5E1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _slate900,
                    height: 1.35,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _indigoBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined, size: 13, color: _indigo),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.district,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: _slate400),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        event.eventLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _slate500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.admin_panel_settings_outlined,
                          size: 11, color: Colors.teal.shade700),
                      const SizedBox(width: 3),
                      Text(
                        event.createdByType.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.teal.shade700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() {
    return Container(
      height: 1,
      color: _divider,
      margin: const EdgeInsets.symmetric(horizontal: 14),
    );
  }

  Widget _dateTimeRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _dateTimeBlock(
                label: 'START',
                date: formatDate(event.startDate),
                time: event.startTime,
                color: _green,
                icon: Icons.play_arrow_rounded,
              ),
            ),
            Container(
              width: 1,
              color: _divider,
              margin: const EdgeInsets.symmetric(horizontal: 14),
            ),
            Expanded(
              child: _dateTimeBlock(
                label: 'END',
                date: formatDate(event.endDate),
                time: event.endTime,
                color: _red,
                icon: Icons.stop_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeBlock({
    required String label,
    required String date,
    required String time,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: _slate900,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionRow() {
    final isAdminPost = !['district_admin', 'merchant'].contains(
      event.createdByType.toLowerCase(),
    );
    if (isAdminPost) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              label: 'Delete',
              icon: Icons.delete_outline_rounded,
              color: Colors.red,
              onTap: onDelete,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionButton(
              label: 'Edit',
              icon: Icons.edit_outlined,
              color: Colors.indigo,
              onTap: onEdit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 7),
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
}
