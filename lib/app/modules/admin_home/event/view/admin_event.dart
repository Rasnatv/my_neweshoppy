//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../common/style/app_colors.dart';
// import '../../../../common/style/app_text_style.dart';
// import '../../../merchant_home/views/merchant_eventupdatepage.dart';
// import '../../controller/admin_addeventcontroller.dart';
// import '../../controller/admin_eventgetcontroller.dart';
// import 'admin_addevent.dart';
// import 'admin_updateevent.dart';
//
// class AdminEventPage extends StatelessWidget {
//   AdminEventPage({super.key});
//
//   final AdminEventGetController controller =
//   Get.put(AdminEventGetController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f6fa),
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimary,
//         title: Text(
//           "All Events",
//           style: AppTextStyle.rTextNunitoWhite17w700,
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(30),
//               onTap: () async {
//                 final result = await Get.to(() => AdminAddEventPage());
//                 if (result == true) {
//                   controller.fetchEvents();
//                 }
//               },
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.add, color: AppColors.kPrimary, size: 20),
//                     const SizedBox(width: 6),
//                     Text(
//                       "Add Event",
//                       style: TextStyle(
//                         color: AppColors.kPrimary,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.events.isEmpty) {
//           return const Center(child: Text("No events found"));
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: controller.events.map((event) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: _eventCard(
//                   event: event,
//                   title: event['event_name'] ?? '',
//                   startDate: event['start_date'] ?? '',
//                   endDate: event['end_date'] ?? '',
//                   time: _getEventTime(event),
//                   imageUrl: event['banner_image'] ?? '',
//                   location: event['event_location'] ?? '',
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _eventCard({
//     required Map event,
//     required String title,
//     required String startDate,
//     required String endDate,
//     required String time,
//     required String imageUrl,
//     required String location,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             spreadRadius: 2,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Banner Image ──────────────────────────────────────
//           ClipRRect(
//             borderRadius:
//             const BorderRadius.vertical(top: Radius.circular(14)),
//             child: imageUrl.isNotEmpty
//                 ? Image.network(
//               imageUrl,
//               height: 160,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => _imageFallback(),
//             )
//                 : _imageFallback(),
//           ),
//
//           // ── Event Details ─────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title.isEmpty ? "Untitled Event" : title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.calendar_today,
//                         size: 16, color: Colors.grey),
//                     const SizedBox(width: 6),
//                     Text("$startDate → $endDate"),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     const Icon(Icons.access_time,
//                         size: 16, color: Colors.grey),
//                     const SizedBox(width: 6),
//                     Text(time.isEmpty ? "--" : time),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on,
//                         size: 16, color: Colors.grey),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         location.isEmpty ? "Location not available" : location,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // ── Divider ───────────────────────────────────────────
//           const Divider(height: 1, thickness: 1, color: Color(0xffeeeeee)),
//
//           // ── Update & Delete Buttons ───────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Row(
//               children: [
//                 // UPDATE button
//                 Expanded(
//                   child: TextButton.icon(
//                     onPressed: () async {
//                       final result = await Get.to(
//                             () => AdminEventUpdatePage(),
//                         arguments: {'event_id': event['id']},
//                       );
//                       if (result == true) {
//                         controller.fetchEvents(); // refresh list
//                       }
//                     },
//                     icon: Icon(Icons.edit_outlined,
//                         size: 18, color: AppColors.kPrimary),
//                     label: Text(
//                       "Update",
//                       style: TextStyle(
//                         color: AppColors.kPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: TextButton.styleFrom(
//                       backgroundColor: AppColors.kPrimary.withOpacity(0.08),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 // DELETE button
//                 Expanded(
//                   child: TextButton.icon(
//                     onPressed: () => _confirmDelete(event),
//                     icon: const Icon(Icons.delete_outline,
//                         size: 18, color: Colors.red),
//                     label: const Text(
//                       "Delete",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.red.withOpacity(0.08),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Shows a confirmation dialog before deleting
//   void _confirmDelete(Map event) {
//     Get.defaultDialog(
//       title: "Delete Event",
//       titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//       middleText:
//       "Are you sure you want to delete \"${event['event_name'] ?? 'this event'}\"?",
//       middleTextStyle: const TextStyle(fontSize: 14, color: Colors.black54),
//       barrierDismissible: true,
//       radius: 12,
//       confirmTextColor: Colors.white,
//       cancelTextColor: Colors.black54,
//       buttonColor: Colors.red,
//       textConfirm: "Delete",
//       textCancel: "Cancel",
//       onConfirm: () {
//       },
//     );
//   }
//
//   Widget _imageFallback() {
//     return Container(
//       height: 160,
//       color: Colors.grey,
//       child: const Icon(Icons.event, size: 50, color: Colors.white),
//     );
//   }
//
//   String _getEventTime(Map event) {
//     return event['start_time'] ??
//         event['event_time'] ??
//         event['from_time'] ??
//         event['time'] ??
//         '';
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/admin_addeventcontroller.dart';
import '../../controller/admin_eventgetcontroller.dart';
import 'admin_addevent.dart';
import 'admin_updateevent.dart';

class AdminEventPage extends StatelessWidget {
  AdminEventPage({super.key});

  final AdminEventGetController controller =
  Get.put(AdminEventGetController());

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
                  event: event,
                  title: event['event_name'] ?? '',
                  startDate: event['start_date'] ?? '',
                  endDate: event['end_date'] ?? '',
                  startTime: _getStartTime(event),  // ← start time
                  endTime: _getEndTime(event),        // ← end time
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
    required Map event,
    required String title,
    required String startDate,
    required String endDate,
    required String startTime,  // ← separate
    required String endTime,    // ← separate
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
          // ── Banner Image ──────────────────────────────────────
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

          // ── Event Details ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title.isEmpty ? "Untitled Event" : title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                // Date range
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text("$startDate → $endDate"),
                  ],
                ),
                const SizedBox(height: 6),

                // ── Time row: start → end ─────────────────────
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      (startTime.isEmpty && endTime.isEmpty)
                          ? "--"
                          : startTime.isEmpty
                          ? endTime
                          : endTime.isEmpty
                          ? startTime
                          : "$startTime → $endTime", // ← both shown
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location.isEmpty ? "Location not available" : location,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────────
          const Divider(height: 1, thickness: 1, color: Color(0xffeeeeee)),

          // ── Update & Delete Buttons ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // UPDATE button
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final result = await Get.to(
                            () => AdminEventUpdatePage(),
                        arguments: {'event_id': event['id']},
                      );
                      if (result == true) {
                        controller.fetchEvents();
                      }
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
                      backgroundColor: AppColors.kPrimary.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // DELETE button
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
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  /// Shows a confirmation dialog before deleting
  void _confirmDelete(Map event) {
    Get.defaultDialog(
      title: "Delete Event",
      titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      middleText:
      "Are you sure you want to delete \"${event['event_name'] ?? 'this event'}\"?",
      middleTextStyle: const TextStyle(fontSize: 14, color: Colors.black54),
      barrierDismissible: true,
      radius: 12,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black54,
      buttonColor: Colors.red,
      textConfirm: "Delete",
      textCancel: "Cancel",
      onConfirm: () {
        Get.back();
        //controller.deleteEvent(event['id']);
      },
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 160,
      color: Colors.grey,
      child: const Icon(Icons.event, size: 50, color: Colors.white),
    );
  }

  // ── Returns start time from event map ──────────────────────────────────────
  String _getStartTime(Map event) {
    return event['start_time'] ??
        event['from_time'] ??
        event['time'] ??
        '';
  }

  // ── Returns end time from event map ────────────────────────────────────────
  String _getEndTime(Map event) {
    return event['end_time'] ??
        event['to_time'] ??
        '';
  }
}