
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/admin_eventgetcontroller.dart';
import 'admin_addevent.dart';

class AdminEventPage extends StatelessWidget {
  AdminEventPage({super.key});

  final AdminEventGetController controller =
  Get.put(AdminEventGetController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f6fa),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "All Events",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                final result = await Get.to(() => AdminAddEventPage());
                if (result == true) {
                  controller.fetchEvents();
                }
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
                    Icon(Icons.add,
                        color: AppColors.kPrimary, size: 20),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.events.isEmpty) {
          return const Center(child: Text("No events found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: controller.events.map((event) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _eventCard(
                  title: event['event_name'] ?? '',
                  startDate: event['start_date'] ?? '',
                  endDate: event['end_date'] ?? '',
                  time: _getEventTime(event),
                  imageUrl: event['banner_image'] ?? '',
                  location: event['event_location'] ?? '',
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _eventCard({
    required String title,
    required String startDate,
    required String endDate,
    required String time,
    required String imageUrl,
    required String location,
  }) {
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
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(14)),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _imageFallback(),
            )
                : _imageFallback(),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? "Untitled Event" : title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text("$startDate → $endDate"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(time.isEmpty ? "--" : time),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  location.isEmpty
                      ? "Location not available"
                      : location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 160,
      color: Colors.grey,
      child: const Icon(Icons.event,
          size: 50, color: Colors.white),
    );
  }

  String _getEventTime(Map event) {
    return event['start_time'] ??
        event['event_time'] ??
        event['from_time'] ??
        event['time'] ??
        '';
  }
}
