
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/merchant_eventdeletecontroller.dart';
import '../controller/merchant_myeventcontroller.dart';
import 'addevents.dart';
import 'merchant_eventupdatepage.dart';

class MerchantEventsPage extends StatelessWidget {
  MerchantEventsPage({super.key});

  final MyEventsController controller = Get.put(MyEventsController());
  final DeleteEventController ctrl = Get.put(DeleteEventController());

  static const List<Color> _accentColors = [
    Color(0xFF00BFA5),
    Color(0xFF7C4DFF),
    Color(0xFFFF6D00),
    Color(0xFF2979FF),
    Color(0xFFE91E63),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.kPrimary,
        title: Text("My Events", style: TextStyle(color: AppColors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: TextButton.icon(
              onPressed: () => Get.to(() => AddEventPage())
                  ?.then((_) => controller.fetchEvents()),
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              label: const Text(
                "Add Event",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5).withOpacity(0.10),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: const Color(0xF0FFFFFF).withOpacity(0.3),
                      width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Color(0xFF00BFA5), strokeWidth: 3),
                  SizedBox(height: 16),
                  Text("Loading your events...",
                      style: TextStyle(
                          color: Color(0xFF8A95A3),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        }

        if (controller.events.isEmpty) return _buildEmptyState();

        return RefreshIndicator(
          onRefresh: () async => controller.fetchEvents(),
          color: const Color(0xFF00BFA5),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: controller.events.length,
            itemBuilder: (context, index) {
              final event = controller.events[index];
              return _buildEventCard(event, index);
            },
          ),
        );
      }),
    );
  }

  // ── EVENT CARD (Ticket Style) ─────────────────────────────────────────
  Widget _buildEventCard(dynamic event, int index) {
    final Color accent = _accentColors[index % _accentColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner Image ──────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  event.bannerImage,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return _imagePlaceholder(isLoading: true);
                  },
                  errorBuilder: (ctx, _, __) =>
                      _imagePlaceholder(isLoading: false),
                ),
              ),
              // ── Gradient Overlay ──────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: _deleteButton(event),
              ),
              // ── Edit Button ───────────────────────────────────────
              Positioned(
                top: 12,
                right: 55,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => EventUpdatePage(),
                        arguments: {'event_id': event.id})
                        ?.then((_) => controller.fetchEvents());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: const Icon(Icons.edit_note,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
              // ── Event Number Badge (top-left) ─────────────────────
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "EVENT ${index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          _TicketDivider(color: accent),

          // ── Card Body ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Name
                Text(
                  event.eventName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B2A),
                    letterSpacing: 0.2,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Date & Time pills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoPill(
                      icon: Icons.calendar_today_rounded,
                      // AFTER
                      label: event.startDate == event.endDate
                          ? event.startDate
                          : "${event.startDate} – ${event.endDate}",
                      // label: "${event.startDate} – ${event.endDate}",
                      color: accent,
                    ),
                    _InfoPill(
                      icon: Icons.schedule_rounded,
                      label: event.time,
                      color: const Color(0xFF7C4DFF),
                    ),

                  ],
                ),
                const SizedBox(height: 12),

                // ── Location Section (two rows) ───────────────────
                _LocationSection(
                  eventLocation: event.location,
                   displayLocation: event.displayLocation,
                  accent: accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Delete Button ─────────────────────────────────────────────────────
  Widget _deleteButton(dynamic event) {
    return Obx(() {
      final isDeleting = ctrl.deletingIds.contains(event.id);
      return GestureDetector(
        onTap: isDeleting ? null : () => _showDeleteConfirmation(event),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(10),
            border:
            Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: isDeleting
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white),
          )
              : const Icon(Icons.delete_outline_rounded,
              color: Colors.white, size: 20),
        ),
      );
    });
  }

  // ── Image Placeholder ─────────────────────────────────────────────────
  Widget _imagePlaceholder({required bool isLoading}) {
    return Container(
      height: 190,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Color(0xFFECEFF4),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
            color: Color(0xFF00BFA5), strokeWidth: 2)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_rounded,
                size: 42, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text("Image unavailable",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height * 0.65,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFECEFF4),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(Icons.event_note_rounded,
                    size: 56, color: Color(0xFF90A4AE)),
              ),
              const SizedBox(height: 28),
              const Text("No Events Yet",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D1B2A))),
              const SizedBox(height: 10),
              Text(
                "Create your first event to start\nengaging with your customers.",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 15, color: Colors.grey[500], height: 1.6),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => AddEventPage())
                    ?.then((_) => controller.fetchEvents()),
                icon: const Icon(Icons.add_rounded, size: 22),
                label: const Text("Create Event",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.3)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B2A),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Delete Confirmation Dialog ────────────────────────────────────────
  void _showDeleteConfirmation(dynamic event) {
    Get.dialog(
      Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: 38),
              ),
              const SizedBox(height: 20),
              const Text("Delete Event?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D1B2A))),
              const SizedBox(height: 10),
              Text('"${event.eventName}" will be permanently removed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey[600], height: 1.5)),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(
                            color: Color(0xFFDDE1E7), width: 1.5),
                      ),
                      child: Text("Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final isDeleting = ctrl.deletingIds.contains(event.id);
                      return ElevatedButton(
                        onPressed: isDeleting
                            ? null
                            : () {
                          Get.back();
                          ctrl.deleteEvent(
                              event.id, () => controller.fetchEvents());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          disabledBackgroundColor: Colors.red[300],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: isDeleting
                            ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                            : const Text("Delete",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 15)),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Location Section (two separate highlighted rows) ──────────────────────
class _LocationSection extends StatelessWidget {
  final String eventLocation;   // raw event_location (venue/place)
   final String displayLocation; // district or main_location
  final Color accent;

  const _LocationSection({
    required this.eventLocation,
    required this.displayLocation,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show district row if it's the same as eventLocation (fallback case)
    final bool showDistrict =
        displayLocation.isNotEmpty && displayLocation != eventLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Row 1: Venue / event_location (grey, subtle) ───────────
        if (eventLocation.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.place_outlined,
                  size: 14, color: Color(0xFF90A4AE)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  eventLocation,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF90A4AE),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

        if (eventLocation.isNotEmpty && showDistrict)
          const SizedBox(height: 7),

        // ── Row 2: District / Area (highlighted pill badge) ────────
        if (showDistrict)
          Row(
            children: [
              // Divider dot between venue and district
              Container(
                width: 3,
                height: 3,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: accent.withOpacity(0.28), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, size: 12, color: accent),
                    const SizedBox(width: 4),
                    Text(
                      displayLocation,
                      style: TextStyle(
                        fontSize: 12,
                        color: accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // "District" label tag

            ],
          ),
      ],
    );
  }
}

// ── District Badge on image (bottom-left) ────────────────────────────────
class _DistrictBadge extends StatelessWidget {
  final String district;
  final Color color;

  const _DistrictBadge({required this.district, required this.color});

  @override
  Widget build(BuildContext context) {
    if (district.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            district,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Pill Widget ───────────────────────────────────────────────────────
class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ── Ticket Notch Divider ───────────────────────────────────────────────────
class _TicketDivider extends StatelessWidget {
  final Color color;
  const _TicketDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-12, 0),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                shape: BoxShape.circle,
                border:
                Border.all(color: const Color(0xFFECEFF4), width: 1),
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(color: color.withOpacity(0.25)),
            ),
          ),
          Transform.translate(
            offset: const Offset(12, 0),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                shape: BoxShape.circle,
                border:
                Border.all(color: const Color(0xFFECEFF4), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dashed Line Painter ────────────────────────────────────────────────────
class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}