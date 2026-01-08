// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// class MerchantAdvertisementListController extends GetxController {
//   final ads = <Map<String, dynamic>>[].obs;
//   final isLoading = false.obs;
//
//   final box = GetStorage();
//   late String authToken;
//
//   @override
//   void onInit() {
//     super.onInit();
//     authToken = box.read("auth_token") ?? "";
//     fetchAdvertisements();
//   }
//
//   Future<void> fetchAdvertisements() async {
//     isLoading.value = true;
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/getadvertisement",
//         ),
//         headers: {
//           "Authorization": "Bearer $authToken",
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body["status"] == "1" || body["status"] == 1) {
//           ads.value = List<Map<String, dynamic>>.from(body["data"]);
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load advertisements");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MerchantAdvertisementGetController extends GetxController {
  final ads = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final GetStorage box = GetStorage();
  String authToken = "";

  @override
  void onInit() {
    super.onInit();

    /// 🔴 IMPORTANT: Read token AFTER storage is ready
    authToken = box.read("auth_token") ?? "";

    if (authToken.isEmpty) {
      Get.snackbar("Auth Error", "Token missing. Please login again.");
      return;
    }

    fetchAdvertisements();
  }

  /// 🔹 GET ADVERTISEMENTS
  Future<void> fetchAdvertisements() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/getadvertisement",
        ),
        headers: {
          "Authorization": "Bearer $authToken", // ✅ MUST
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (body["status"] == "1" || body["status"] == 1)) {
        ads.value = List<Map<String, dynamic>>.from(
          body["data"].map((e) => {
            "id": e["id"].toString(),
            "title": e["advertisement"],
            "image": e["banner_image"],
          }),
        );
      } else {
        Get.snackbar("Error", body["message"] ?? "Failed to load ads");
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch advertisements");
    } finally {
      isLoading.value = false;
    }
  }
}
