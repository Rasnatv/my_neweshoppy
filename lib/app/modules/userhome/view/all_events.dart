import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_eventcontroller.dart';

class AllEventsPage extends StatelessWidget {
  AllEventsPage({super.key});

  final UserEventController controller =
  Get.put(UserEventController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Events"),
        centerTitle: true,
      ),
      body: Obx(() {
        // 🔄 Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ❌ Empty
        if (controller.events.isEmpty) {
          return Center(
            child: Text(
              "No events available",
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        // ✅ GridView
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.events.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards per row
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72, // adjust for height
          ),
          itemBuilder: (context, index) {
            final event = controller.events[index];

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
                  // 🔳 Image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(
                          event.bannerImage,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: Colors.grey[200],
                            child: const Icon(Icons.event),
                          ),
                        ),
                      ),

                      // 📅 Badge
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Event",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 📄 Details
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          event.eventName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Date
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 12),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${event.startDate} - ${event.endDate}",
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Time
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              "${event.startTime} - ${event.endTime}",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
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
          },
        );
      }),
    );
  }
}