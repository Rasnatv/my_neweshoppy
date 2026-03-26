

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/areaadmin_eventsgetmodel.dart';
import '../controller/areaadmin_eventgettingcontroller.dart';
import '../controller/areaadmin_updateeventcontroller.dart';
import '../view/areaadmin_updateeventpage.dart';

class RecentEventsWidget extends StatelessWidget {
  RecentEventsWidget({super.key});

  final controller = Get.put(AreaadminGettingEventController());

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _formatCreatedAt(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$minute $period';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Error state
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

      // Empty state
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

      // Events list
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentEvents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) => EventCard(
          event: controller.recentEvents[index],
          formatDate: _formatDate,
          formatCreatedAt: _formatCreatedAt,
          onDelete: () => _confirmDelete(context, controller.recentEvents[index]),
          onEdit: () => _navigateToEdit(controller.recentEvents[index]),
        ),
      );
    });
  }


  void _confirmDelete(BuildContext context, AreaAdmingshowEventModel event) {
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteEvent(event.id); // ✅ call delete here
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(AreaAdmingshowEventModel event) {
    // TODO: Get.to(() => AreaAdminUpdateEventPage(eventId: event.id));
  }
}

// ── Card widget ───────────────────────────────────────────────────────────────

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.formatDate,
    required this.formatCreatedAt,
    required this.onDelete,
    required this.onEdit,
  });

  final AreaAdmingshowEventModel event;
  final String Function(String) formatDate;
  final String Function(String) formatCreatedAt;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  static const _indigo = Color(0xFF4F46E5);
  static const _indigoBg = Color(0xFFEEEDFE);
  static const _green = Color(0xFF059669);
  static const _red = Color(0xFFDC2626);
  static const _slate900 = Color(0xFF0F172A);
  static const _slate500 = Color(0xFF64748B);
  static const _slate400 = Color(0xFF94A3B8);
  static const _divider = Color(0xFFF1F5F9);

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
              offset: const Offset(0, 4)),
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1)),
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
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.image_not_supported_outlined,
                    size: 26, color: Color(0xFFCBD5E1)),
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
                      letterSpacing: -0.2),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: _indigoBg,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.place_rounded, size: 13, color: _indigo),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.mainLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _indigo),
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
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined,
                        size: 11, color: _slate400),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        'Posted ${formatCreatedAt(event.createdAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11,
                            color: _slate400,
                            fontWeight: FontWeight.w500),
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

  Widget _dividerLine() {
    return Container(
        height: 1,
        color: _divider,
        margin: const EdgeInsets.symmetric(horizontal: 14));
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
                    icon: Icons.play_arrow_rounded)),
            Container(
                width: 1,
                color: _divider,
                margin: const EdgeInsets.symmetric(horizontal: 14)),
            Expanded(
                child: _dateTimeBlock(
                    label: 'END',
                    date: formatDate(event.endDate),
                    time: event.endTime,
                    color: _red,
                    icon: Icons.stop_rounded)),
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
              color: color.withOpacity(0.10), shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.8)),
              const SizedBox(height: 2),
              Text(date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: _slate900)),
              const SizedBox(height: 1),
              Text(time,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Row(
        children: [
          Expanded(
              child: _actionButton(
                label: 'Delete',
                icon: Icons.delete_outline_rounded,
                color: Colors.red,
                onTap: onDelete, // ✅ wired up
              )),
          const SizedBox(width: 10),
          Expanded(
              child: _actionButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                color: Colors.indigo,
                onTap: ()=>Get.to(()=>AreaAdminUpdateEventPage(eventId:event.id.toString(),))
              )),
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
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }
}