//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/models/area_admin_advertismentgetmodel.dart';
//
// class AreaAdminAdvertisementgetController extends GetxController {
//   var isLoading = false.obs;
//   var advertisementList = <AreaAdmingetAdvertisementModel>[].obs;
//
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAdvertisements();
//   }
//
//   Future<void> fetchAdvertisements() async {
//     try {
//       isLoading(true);
//
//       final String? token = box.read('auth_token');
//
//       if (token == null || token.isEmpty) {
//         Get.snackbar(
//           'Error', 'No auth token found. Please log in again.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       final response = await http.get(
//         Uri.parse(
//           'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisements',
//         ),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['data'] != null) {
//           final List list = data['data'];
//
//           final ads = list
//               .map((e) => AreaAdmingetAdvertisementModel.fromJson(e))
//               .toList();
//
//           // Sort latest first — safe because createdAt always has a fallback
//           ads.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//
//           advertisementList.value = ads;
//         } else {
//           advertisementList.clear();
//         }
//       } else if (response.statusCode == 401) {
//         Get.snackbar(
//           'Session Expired', 'Please log in again.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar('Error', 'Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> deleteAdvertisement(int adId) async {
//     // Optimistic removal
//     advertisementList.removeWhere((ad) => ad.id == adId);
//
//     try {
//       final String? token = box.read('auth_token');
//
//       if (token == null || token.isEmpty) {
//         Get.snackbar(
//           'Error', 'No auth token found.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         fetchAdvertisements(); // restore
//         return;
//       }
//
//       final response = await http.delete(
//         Uri.parse(
//           'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement/delete',
//         ),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"ad_id": adId}),
//       );
//
//       final data = json.decode(response.body);
//
//       if (response.statusCode == 200 && data['status'] == true) {
//         Get.snackbar(
//           'Success', data['message'] ?? 'Advertisement deleted.',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error', data['message'] ?? 'Delete failed.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         fetchAdvertisements(); // rollback
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       fetchAdvertisements(); // rollback
//     }
//   }
//
//   // Only show latest 3 on home
//   List<AreaAdmingetAdvertisementModel> get latestAds =>
//       advertisementList.take(3).toList();
// }
// lib/app/modules/area_admin/controller/areaadmin_getting_advertismentcontroller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/area_admin_advertismentgetmodel.dart';

class AreaAdminAdvertisementgetController extends GetxController {
  var isLoading = false.obs;
  var advertisementList = <AreaAdmingetAdvertisementModel>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  Future<void> fetchAdvertisements() async {
    try {
      isLoading(true);

      final String? token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'No auth token found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisements',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null) {
          final List list = data['data'];

          final ads = list
              .map((e) => AreaAdmingetAdvertisementModel.fromJson(e))
              .toList();

          // Sort by id descending — newest first (API has no created_at)
          ads.sort((a, b) => b.id.compareTo(a.id));

          advertisementList.value = ads;
        } else {
          advertisementList.clear();
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAdvertisement(int adId) async {
    // Optimistic removal
    advertisementList.removeWhere((ad) => ad.id == adId);

    try {
      final String? token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'No auth token found.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        fetchAdvertisements(); // restore
        return;
      }

      final response = await http.delete(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement/delete',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"ad_id": adId}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        Get.snackbar(
          'Success',
          data['message'] ?? 'Advertisement deleted.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Delete failed.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        fetchAdvertisements(); // rollback
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      fetchAdvertisements(); // rollback
    }
  }

  // Only latest 3 on home screen
  List<AreaAdmingetAdvertisementModel> get latestAds =>
      advertisementList.take(3).toList();
}