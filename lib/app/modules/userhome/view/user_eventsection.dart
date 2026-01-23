import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_eventcontroller.dart';

class UpcomingEventsSection extends StatelessWidget {
  UpcomingEventsSection({super.key});

  final UserEventController controller =
  Get.put(UserEventController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.events.isEmpty) {
        return const SizedBox(
          height: 220,
          child: Center(child: Text("No events available")),
        );
      }

      return SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14)),
                      child: Image.network(
                        event.bannerImage,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.eventName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${event.startDate} - ${event.endDate}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event.time,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
