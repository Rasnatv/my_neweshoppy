import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/homedatamodel.dart';
import '../controller/homedatacontroller.dart';

class AllEventsPage extends StatelessWidget {
  AllEventsPage({super.key});

  final HomeDataController controller = Get.find<HomeDataController>();

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color:Colors.white),
        backgroundColor: AppColors.kPrimary,
        title: const Text("All Events", style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),),

      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy_rounded, size: 52, color: Colors.grey[350]),
                const SizedBox(height: 12),
                Text(
                  "No events available",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.events.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.86,
          ),
          itemBuilder: (context, index) {
            final event = controller.events[index];
            return _EventGridCard(event: event);
          },
        );
      }),
    ));
  }
}

// ── Grid Card ─────────────────────────────────────────────────────────────────

class _EventGridCard extends StatelessWidget {
  final HomeEventModel event;

  const _EventGridCard({required this.event});

  bool get _isSingleDay =>
      event.startDate.isNotEmpty &&
          event.endDate.isNotEmpty &&
          event.startDate == event.endDate;

  /// Formats "2026-04-12" → "12-04-2026"
  String _formatDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      return '$day-$month-${d.year}';
    } catch (_) {
      return raw;
    }
  }

  /// Single day → "12-04-2026"   Multi-day → "12-04-2026  -  29-04-2026"
  String get _dateLabel {
    if (event.startDate.isEmpty) return '';
    if (_isSingleDay) return _formatDate(event.startDate);
    return '${_formatDate(event.startDate)}  -  ${_formatDate(event.endDate)}';
  }

  /// Both times → "6:53 PM - 6:53 PM"   Only start → "6:53 PM"
  String get _timeLabel {
    final hasStart = event.startTime.isNotEmpty;
    final hasEnd = event.endTime.isNotEmpty;
    if (hasStart && hasEnd) return '${event.startTime} - ${event.endTime}';
    if (hasStart) return event.startTime;
    return '';
  }

  /// Location from mainLocation + district
  String get _locationLabel {
    if (event.mainLocation.isNotEmpty && event.district.isNotEmpty) {
      return '${event.mainLocation}, ${event.district}';
    }
    if (event.mainLocation.isNotEmpty) return event.mainLocation;
    return event.district;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner Image ───────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  event.bannerImage,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 110,
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 110,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.event_rounded,
                          size: 36, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              // "Event" badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: Colors.white, size: 10),
                      SizedBox(width: 3),
                      Text(
                        "Event",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Details ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event name
                Text(
                  event.eventName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                // Date row
                if (_dateLabel.isNotEmpty) ...[
                  _InfoRow(
                    icon: Icons.date_range_rounded,
                    label: _dateLabel,
                    color: Colors.purple.shade400,
                  ),
                  const SizedBox(height: 3),
                ],

                // Time row
                if (_timeLabel.isNotEmpty) ...[
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    label: _timeLabel,
                    color: Colors.orange.shade400,
                  ),
                  const SizedBox(height: 3),
                ],

                // Location row
                if (_locationLabel.isNotEmpty)
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    label: _locationLabel,
                    color: Colors.grey.shade500,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable icon + text row ──────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}