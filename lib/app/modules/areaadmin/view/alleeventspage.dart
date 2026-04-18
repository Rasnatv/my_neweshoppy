import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/areaadmin_eventsgetmodel.dart';
import '../controller/areaadmin_eventgettingcontroller.dart';
import '../widget/eventwidget.dart';
import 'areaadmin_updateeventpage.dart';

class AreaAdminAllEventsPage extends StatelessWidget {
  AreaAdminAllEventsPage({super.key});

  // ✅ Use Get.find — controller already registered from the dashboard/home page
  final controller = Get.find<AreaadminGettingEventController>();

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.welcomecardclr,
        elevation: 0,
        title: const Text(
          'All Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
        ),
        actions: [
          // ✅ Pull-to-refresh button in AppBar
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
          onRefresh: controller.fetchEvents, // ✅ pull-to-refresh
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: controller.allEvents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final event = controller.allEvents[index];
              return EventCard(
                event: event,
                formatDate: _formatDate,
                formatCreatedAt: _formatCreatedAt,
                onDelete: () => _confirmDelete(context, event),
                onEdit: () => _navigateToEdit(event),
              );
            },
          ),
        );
      }),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

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
    Get.to(
          () => AreaAdminUpdateEventPage(eventId: event.id.toString()),
    )?.then((result) {
      if (result == true) {
        controller.fetchEvents(); // ✅ this updates allEvents → list refreshes
      }
    });
  }

}