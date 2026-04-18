
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/homedatamodel.dart';
import '../controller/homedatacontroller.dart';

class UpcomingEventsSection extends StatelessWidget {
  UpcomingEventsSection({super.key});

  final HomeDataController controller = Get.find<HomeDataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.events.isEmpty) {
        return _buildLoader(context);
      }
      if (controller.events.isEmpty) {
        return _buildEmpty();
      }
      return SizedBox(
        height: 255,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _EventCard(event: event),
            );
          },
        ),
      );
    });
  }

  Widget _buildLoader(BuildContext context) {
    return SizedBox(
      height: 255,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      height: 255,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 42, color: Colors.grey[350]),
            const SizedBox(height: 10),
            Text(
              "Select a location to see events",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap the location bar above to get started",
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Event Card ────────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final HomeEventModel event;

  const _EventCard({required this.event});

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

  /// Builds "6:53 PM - 6:53 PM" or just "6:53 PM" if end time missing
  String _buildTimePart() {
    final hasStart = event.startTime.isNotEmpty;
    final hasEnd = event.endTime.isNotEmpty;
    if (hasStart && hasEnd) return '${event.startTime} - ${event.endTime}';
    if (hasStart) return event.startTime;
    return '';
  }

  /// Date label only (no time)
  String get _dateLabel {
    if (event.startDate.isEmpty) return '';
    if (_isSingleDay) return _formatDate(event.startDate);
    return '${_formatDate(event.startDate)}  -  ${_formatDate(event.endDate)}';
  }

  String _locationLabel(HomeEventModel e) {
    if (e.mainLocation.isNotEmpty && e.district.isNotEmpty) {
      return '${e.mainLocation}, ${e.district}';
    }
    if (e.mainLocation.isNotEmpty) return e.mainLocation;
    return e.district;
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dateLabel;
    final timePart = _buildTimePart();

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner Image ─────────────────────────────────────────────
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.bannerImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.event_rounded,
                            size: 40, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  // "Event" badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: Colors.white, size: 11),
                          SizedBox(width: 4),
                          Text(
                            "Event",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Info Section ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event name
                Text(
                  event.eventName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),

                // ── Date row ─────────────────────────────────────────
                if (dateLabel.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 12,
                        color: Colors.purple.shade400,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dateLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.purple.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // ── Time row (always shown if available) ─────────────
                if (timePart.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: Colors.orange.shade400,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          timePart,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // ── Location row ──────────────────────────────────────
                if (event.district.isNotEmpty ||
                    event.mainLocation.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _locationLabel(event),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}