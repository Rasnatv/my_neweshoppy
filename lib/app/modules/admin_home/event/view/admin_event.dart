

import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../widgets/delete_widget.dart';
import '../../controller/admin_eventgetcontroller.dart';
import 'admin_addevent.dart';
import 'admin_updateevent.dart';

class AdminEventPage extends StatelessWidget {
  AdminEventPage({super.key});

  final AdminEventGetController controller =
  Get.put(AdminEventGetController());

  final List<Map<String, String>> _filters = const [
    {'key': 'all', 'label': 'All'},
    {'key': 'admin', 'label': 'Admin'},
    {'key': 'district_admin', 'label': 'District'},
    {'key': 'area_admin', 'label': 'Area'},
    {'key': 'merchant', 'label': 'Merchant'},
  ];

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: const Color(0xfff2f6fa),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.kPrimary,
        title: Text("All Events", style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                final result = await Get.to(() => AdminAddEventPage());
                if (result == true) controller.fetchEvents();
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: AppColors.kPrimary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "Add Event",
                      style: TextStyle(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredEvents.isEmpty) {
                return const Center(child: Text("No events found"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = controller.filteredEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _eventCard(event),
                  );
                },
              );
            }),
          ),
        ],
      ),
    ));
  }

  // ── Filter Bar ────────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final isSelected = controller.selectedFilter.value == f['key'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.applyFilter(f['key']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.kPrimary
                        : const Color(0xfff2f6fa),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.kPrimary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    f['label']!,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      )),
    );
  }

  // ── Event Card ────────────────────────────────────────────────────────────
  Widget _eventCard(Map event) {
    final title = event['event_name'] ?? '';
    final startDate = event['start_date'] ?? '';
    final endDate = event['end_date'] ?? '';
    final imageUrl = event['banner_image'] ?? '';
    final location = event['event_location'] ?? '';
    final creatorType = controller.getCreatorType(event);
    final areaInfo = controller.getAreaInfo(event);

    // FIX: Convert raw API time strings (e.g. "14:46") to 12-hour display
    // format (e.g. "2:46 PM") using the controller helper.
    final startTime = controller.formatDisplayTime(
        event['start_time'] ?? event['from_time'] ?? '');
    final endTime = controller.formatDisplayTime(
        event['end_time'] ?? event['to_time'] ?? '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner Image ──────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(),
                )
                    : _imageFallback(),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _postedByBadge(creatorType),
              ),
            ],
          ),

          // ── Event Details ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? "Untitled Event" : title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined,
                          size: 15, color: Colors.deepPurple),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          areaInfo,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                _infoRow(
                  icon: Icons.location_on,
                  iconColor: Colors.redAccent,
                  label: "Venue",
                  value: location.isEmpty ? "Not available" : location,
                ),
                const SizedBox(height: 6),

                _infoRow(
                  icon: Icons.calendar_today,
                  iconColor: Colors.teal,
                  label: "Date",
                  value: "$startDate → $endDate",
                ),
                const SizedBox(height: 6),

                // Time row — now always shows 12-hour format e.g. "2:46 PM"
                _infoRow(
                  icon: Icons.access_time,
                  iconColor: Colors.orange,
                  label: "Time",
                  value: (startTime == '--' && endTime == '--')
                      ? "--"
                      : "$startTime → $endTime",
                ),
                const SizedBox(height: 10),

                _postedByRow(event),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xffeeeeee)),

          // ── Update & Delete Buttons ───────────────────────────
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final result = await Get.to(
                            () => AdminEventUpdatePage(),
                        arguments: {'event_id': event['id']},
                      );
                      if (result == true) controller.fetchEvents();
                    },
                    icon: Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.kPrimary),
                    label: Text(
                      "Update",
                      style: TextStyle(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                      AppColors.kPrimary.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _confirmDelete(event),
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Row Helper ───────────────────────────────────────────────────────
  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ── Posted By Badge (on image) ────────────────────────────────────────────
  Widget _postedByBadge(String creatorType) {
    final config = _badgeConfig(creatorType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config['color'] as Color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config['icon'] as IconData, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            config['label'] as String,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ── Posted By Row (in card details) ──────────────────────────────────────
  Widget _postedByRow(Map event) {
    final creatorType = controller.getCreatorType(event);
    final config = _badgeConfig(creatorType);
    final creatorId = event['created_by_id'] ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: (config['color'] as Color).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (config['color'] as Color).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(config['icon'] as IconData,
              size: 16, color: config['color'] as Color),
          const SizedBox(width: 8),
          Text(
            "Posted by: ",
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
          Text(
            "${config['label']}  •  ID #$creatorId",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: config['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Badge config per creator type ────────────────────────────────────────
  Map<String, dynamic> _badgeConfig(String type) {
    switch (type) {
      case 'admin':
        return {
          'label': 'Admin',
          'color': Colors.indigo,
          'icon': Icons.admin_panel_settings,
        };
      case 'district_admin':
        return {
          'label': 'District Admin',
          'color': Colors.teal,
          'icon': Icons.location_city,
        };
      case 'area_admin':
        return {
          'label': 'Area Admin',
          'color': Colors.deepPurple,
          'icon': Icons.map,
        };
      case 'merchant':
        return {
          'label': 'Merchant',
          'color': Colors.orange.shade700,
          'icon': Icons.store,
        };
      default:
        return {
          'label': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.person,
        };
    }
  }

  void _confirmDelete(Map event) {
    DeleteConfirmDialog.show(
      context: Get.context!,
      title: "Delete Event",
      message: "Are you sure you want to delete \"${event['event_name'] ?? 'this event'}\"?",
      onConfirm: () {
        controller.deleteEvent(int.parse(event['id'].toString()));
      },
    );
  }
  Widget _imageFallback() {
    return Container(
      height: 160,
      color: Colors.grey.shade300,
      child: const Icon(Icons.event, size: 50, color: Colors.white),
    );
  }
}