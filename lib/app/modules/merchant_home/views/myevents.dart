
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/delete_widget.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../controller/merchant_eventdeletecontroller.dart';
import '../controller/merchant_myeventcontroller.dart';
import 'addevents.dart';
import 'merchant_eventupdatepage.dart';

class _T {
  // Page
  static const Color pageBg        = Color(0xFFF7F8FA);

  // Card
  static const Color cardBg        = Color(0xFFFFFFFF);
  static const Color cardBorder    = Color(0xFFEAECF0);
  static const double cardRadius   = 20;

  // Text
  static const Color textPrimary   = Color(0xFF1D2939);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted     = Color(0xFF9CA3AF);

  // Meta tag (date / time)
  static const Color tagBg         = Color(0xFFF9FAFB);
  static const Color tagBorder     = Color(0xFFEAECF0);
  static const Color tagText       = Color(0xFF374151);
  static const Color tagIcon       = Color(0xFF6B7280);

  // Divider
  static const Color divider       = Color(0xFFF2F4F7);

  // District icon box
  static const Color districtBoxBg = Color(0xFFEFF6FF);
  static const Color districtIcon  = Color(0xFF2563EB);
  static const Color districtName  = Color(0xFF1D2939);
  static const Color districtLabel = Color(0xFF9CA3AF);

  // Action buttons on image
  static const Color actionBg      = Color(0x66000000);
  static const Color actionBorder  = Color(0x33FFFFFF);
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────
class MerchantEventsPage extends StatelessWidget {
  MerchantEventsPage({super.key});

  final MyEventsController controller = Get.put(MyEventsController());
  final DeleteEventController ctrl    = Get.put(DeleteEventController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: _T.pageBg,

        // ── AppBar — unchanged ─────────────────────────────────────
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.kPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "My Events",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: TextButton.icon(
                onPressed: () => Get.to(() => AddEventPage())
                    ?.then((_) => controller.fetchEvents()),
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                label: const Text(
                  "Add Event",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5).withOpacity(0.10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: const Color(0xF0FFFFFF).withOpacity(0.3), width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Obx(() {
          if (controller.isLoading.value) return _buildLoading();
          if (controller.events.isEmpty)  return _buildEmpty();

          return RefreshIndicator(
            onRefresh: () async => controller.fetchEvents(),
            color: _T.districtIcon,
            backgroundColor: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                return _EventCard(
                  event: controller.events[index],
                  index: index,
                  ctrl: ctrl,
                  onRefresh: controller.fetchEvents,
                );
              },
            ),
          );
        }),
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────────────────
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _T.cardBorder),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: _T.districtIcon,
                strokeWidth: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Loading events...",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _T.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _T.cardBorder),
              ),
              child: const Icon(Icons.event_note_outlined, size: 40, color: _T.textMuted),
            ),
            const SizedBox(height: 20),
            const Text(
              "No events yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _T.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create your first event to start\nengaging with your customers.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _T.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => Get.to(() => AddEventPage())
                  ?.then((_) => controller.fetchEvents()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                decoration: BoxDecoration(
                  color: _T.textPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 7),
                    Text(
                      "Create Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Event Card
// ─────────────────────────────────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  final dynamic event;
  final int index;
  final DeleteEventController ctrl;
  final VoidCallback onRefresh;

  const _EventCard({
    required this.event,
    required this.index,
    required this.ctrl,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(_T.cardRadius),
        border: Border.all(color: _T.cardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          _buildBody(),
        ],
      ),
    );
  }

  // ── Banner ─────────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(_T.cardRadius)),
          child: CachedNetworkImage(
            imageUrl: event.bannerImage,
            width: double.infinity,
            height: 185,
            fit: BoxFit.cover,
            placeholder: (_, __) => _imgPlaceholder(loading: true),
            errorWidget:  (_, __, ___) => _imgPlaceholder(loading: false),
            fadeInDuration: const Duration(milliseconds: 300),
            memCacheWidth: 800,
            memCacheHeight: 400,
          ),
        ),

        // Gradient veil
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(_T.cardRadius)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.55, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.22),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.70),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Event badge — top left
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
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

        // Actions — top right
        Positioned(
          top: 12,
          right: 12,
          child: Row(
            children: [
              // Edit
              GestureDetector(
                onTap: () => Get.to(
                      () => EventUpdatePage(),
                  arguments: {'event_id': event.id},
                )?.then((_) => onRefresh()),
                child: _ImageActionBtn(icon: Icons.edit_outlined),
              ),
              const SizedBox(width: 8),
              // Delete
              _DeleteBtn(event: event, ctrl: ctrl, onRefresh: onRefresh),
            ],
          ),
        ),

        // Title — bottom left
        Positioned(
          bottom: 14,
          left: 14,
          right: 14,
          child: Text(
            event.eventName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date + Time tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaTag(icon: Icons.calendar_today_outlined,
                  label: event.startDate == event.endDate
                      ? event.startDate
                      : "${event.startDate} – ${event.endDate}"),
              _MetaTag(icon: Icons.access_time_rounded, label: event.time),
            ],
          ),

          const SizedBox(height: 14),

          // Divider
          const Divider(height: 1, thickness: 1, color: _T.divider),

          const SizedBox(height: 12),

          // Location section
          _LocationSection(
            eventLocation: event.location,
            displayLocation: event.displayLocation,
          ),
        ],
      ),
    );
  }

  // ── Image placeholder ───────────────────────────────────────────────────
  Widget _imgPlaceholder({required bool loading}) {
    return Container(
      height: 185,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(_T.cardRadius)),
      ),
      child: Center(
        child: loading
            ? const CircularProgressIndicator(color: _T.districtIcon, strokeWidth: 2.5)
            : const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, size: 36, color: _T.textMuted),
            SizedBox(height: 8),
            Text("Image unavailable",
                style: TextStyle(fontSize: 12, color: _T.textMuted, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Location Section — two side-by-side highlighted boxes
// ─────────────────────────────────────────────────────────────────────────────
class _LocationSection extends StatelessWidget {
  final String eventLocation;
  final String displayLocation;

  const _LocationSection({
    required this.eventLocation,
    required this.displayLocation,
  });

  @override
  Widget build(BuildContext context) {
    final bool showDistrict =
        displayLocation.isNotEmpty && displayLocation != eventLocation;

    if (eventLocation.isEmpty && !showDistrict) {
      return const Row(
        children: [
          Icon(Icons.location_off_outlined, size: 14, color: Color(0xFF9CA3AF)),
          SizedBox(width: 6),
          Text("Location not set",
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Event Location box — neutral grey ─────────────────────
        if (eventLocation.isNotEmpty)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAECF0), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9CA3AF)),
                      SizedBox(width: 4),
                      Text(
                        "EVENT LOCATION",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    eventLocation,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

        if (eventLocation.isNotEmpty && showDistrict) const SizedBox(width: 8),

        // ── Area / District box — blue highlight ──────────────────
        if (showDistrict)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF2563EB)),
                      SizedBox(width: 4),
                      Text(
                        "AREA / DISTRICT",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    displayLocation,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E40AF),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Small date / time tag below the banner
class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _T.tagBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _T.tagBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _T.tagIcon),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _T.tagText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Semi-transparent icon button sitting on the banner image
class _ImageActionBtn extends StatelessWidget {
  final IconData icon;
  final bool isLoading;

  const _ImageActionBtn({required this.icon, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _T.actionBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _T.actionBorder, width: 1),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : Icon(icon, color: Colors.white, size: 17),
      ),
    );
  }
}

/// Delete button with reactive loading state
class _DeleteBtn extends StatelessWidget {
  final dynamic event;
  final DeleteEventController ctrl;
  final VoidCallback onRefresh;

  const _DeleteBtn({required this.event, required this.ctrl, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDeleting = ctrl.deletingIds.contains(event.id);
      return GestureDetector(
        onTap: isDeleting
            ? null
            : () => DeleteConfirmDialog.show(
          context: Get.context!,
          title: 'Delete Event',
          message: '"${event.eventName}" will be permanently removed.',
          onConfirm: () => ctrl.deleteEvent(event.id, onRefresh),
        ),
        child: _ImageActionBtn(
          icon: Icons.delete_outline_rounded,
          isLoading: isDeleting,
        ),
      );
    });
  }
}