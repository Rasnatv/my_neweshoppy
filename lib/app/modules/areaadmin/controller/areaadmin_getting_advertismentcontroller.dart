
import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/area_admin_advertismentgetmodel.dart';
//
// class AreaAdminAdvertisementgetController extends GetxController {
//   var isLoading = false.obs;
//   var advertisementList = <AreaAdmingetAdvertisementModel>[].obs;
//
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     fetchAdvertisements();
//     super.onInit();
//   }
//
//   Future<void> fetchAdvertisements() async {
//     try {
//       isLoading(true);
//
//       final token = box.read('auth_token');
//
//       final response = await http.get(
//         Uri.parse('https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisements'),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         final List list = data['data'];
//
//         advertisementList.value =
//             list.map((e) => AreaAdmingetAdvertisementModel.fromJson(e)).toList();
//
//         // 🔥 Sort latest first
//         advertisementList.sort(
//               (a, b) => b.createdAt.compareTo(a.createdAt),
//         );
//       } else {
//         Get.snackbar("Error", "Failed to fetch advertisements");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // ✅ ONLY latest 3
//   List<AreaAdmingetAdvertisementModel> get latestAds =>
//       advertisementList.take(3).toList();
// }class AdvertisementController extends GetxController {
//   var isLoading = false.obs;
//   var advertisementList = <AreaAdmingetAdvertisementModel>[].obs;
//
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     fetchAdvertisements();
//     super.onInit();
//   }
//
//   Future<void> fetchAdvertisements() async {
//     try {
//       isLoading(true);
//
//       final token = box.read('token');
//
//       final response = await http.get(
//         Uri.parse('https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisements'),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         final List list = data['data'];
//
//         advertisementList.value =
//             list.map((e) => AreaAdmingetAdvertisementModel.fromJson(e)).toList();
//
//         // 🔥 Sort latest first
//         advertisementList.sort(
//               (a, b) => b.createdAt.compareTo(a.createdAt),
//         );
//       } else {
//         Get.snackbar("Error", "Failed to fetch advertisements");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
//
//
//   Future<void> deleteAdvertisement(int adId) async {
//     try {
//       isLoading(true);
//
//       final token = box.read('auth_token'); // ✅ use same key as fetch
//
//       final response = await http.delete(
//         Uri.parse(
//             'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement/delete'),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "ad_id": adId,
//         }),
//       );
//
//       final data = json.decode(response.body);
//
//       if (response.statusCode == 200 && data['status'] == true) {
//         // ✅ remove from UI instantly
//         advertisementList.removeWhere((ad) => ad.id == adId);
//
//         Get.snackbar("Success", data['message']);
//       } else {
//         Get.snackbar("Error", data['message'] ?? "Delete failed");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // ✅ ONLY latest 3
//   List<AreaAdmingetAdvertisementModel> get latestAds =>
//       advertisementList.take(3).toList();
// }
import 'package:get/get_core/src/get_main.dart';

import '../../../data/models/area_admin_advertismentgetmodel.dart';

class AreaAdminAdvertisementgetController extends GetxController {
  var isLoading = false.obs;
  var advertisementList = <AreaAdmingetAdvertisementModel>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    fetchAdvertisements();
    super.onInit();
  }

  Future<void> fetchAdvertisements() async {
    try {
      isLoading(true);

      final token = box.read('auth_token');

      final response = await http.get(
        Uri.parse('https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisements'),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List list = data['data'];

        advertisementList.value =
            list.map((e) => AreaAdmingetAdvertisementModel.fromJson(e)).toList();

        advertisementList.sort(
              (a, b) => b.createdAt.compareTo(a.createdAt),
        );
      } else {
        Get.snackbar("Error", "Failed to fetch advertisements");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ✅ DELETE FIXED
  Future<void> deleteAdvertisement(int adId) async {
    try {
      isLoading(true);

      final token = box.read('auth_token');

      final response = await http.delete( // ✅ FIXED HERE
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement/delete'),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "ad_id": adId,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        advertisementList.removeWhere((ad) => ad.id == adId);

        Get.snackbar("Success", data['message']);
      } else {
        Get.snackbar("Error", data['message'] ?? "Delete failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  List<AreaAdmingetAdvertisementModel> get latestAds =>
      advertisementList.take(3).toList();
}