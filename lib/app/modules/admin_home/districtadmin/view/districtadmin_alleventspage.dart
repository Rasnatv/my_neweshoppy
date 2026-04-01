import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../common/style/app_colors.dart';
import '../../../../data/models/districtadmineventmodel.dart';
import '../controller/districtadmin_eventgettingcontroller.dart';
import '../widget/recent_eventwidget.dart';
import 'districtadmin_eventupdatepage.dart';


class DistrictAdminAllEventsPage extends StatelessWidget {
  DistrictAdminAllEventsPage({super.key});

  // Use Get.find — controller already registered from dashboard/recent widget
  final controller = Get.find<DistrictAdminGettingEventController>();

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

  // No created_at in district admin API — passthrough
  String _formatCreatedAt(String raw) => raw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'All Events',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchEvents,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ────────────────────────────────────────────────────────────
        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.redAccent, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: controller.fetchEvents,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Empty ────────────────────────────────────────────────────────────
        if (controller.allEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy_rounded,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'No Events Found',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Events you create will appear here.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // ── List ─────────────────────────────────────────────────────────────
        return RefreshIndicator(
          onRefresh: controller.fetchEvents,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: controller.allEvents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final event = controller.allEvents[index];
              return DistrictAdminEventCard(
                event: event,
                formatDate: _formatDate,
                formatCreatedAt: _formatCreatedAt,
                onDelete: () => _confirmDelete(context, event),
                onEdit:   () => _navigateToEdit(event),
              );
            },
          ),
        );
      }),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _confirmDelete(BuildContext context, DistrictAdminEventModel event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content:
        Text('Are you sure you want to delete "${event.eventName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteEvent(event.id);
            },
            child:
            const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(DistrictAdminEventModel event) {
    // TODO: Uncomment when update page is ready
    Get.to(() => DistrictAdminUpdateEventPage(eventId: event.id))
        ?.then((result) {
      if (result == true) controller.fetchEvents();
    });
  }
}
