// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/userlocation_model.dart';
//
// class UserDistrictController extends GetxController {
//   final box = GetStorage();
//
//   final String apiUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchants/location-wise";
//
//   var isLoading = false.obs;
//
//   var allLocations = <UserLocationModel>[].obs;
//   var states = <String>[].obs;
//   var districts = <String>[].obs;
//   var mainLocations = <String>[].obs;
//
//   var selectedState = ''.obs;
//   var selectedDistrict = ''.obs;
//   var selectedMainLocation = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchLocations();
//   }
//
//   Future<void> fetchLocations() async {
//     try {
//       isLoading.value = true;
//
//       final token = box.read("auth_token");
//
//       if (token == null) {
//         Get.snackbar("Error", "Token not found. Login again.");
//         return;
//       }
//
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final List data = decoded['data'];
//
//         allLocations.value =
//             data.map((e) => UserLocationModel.fromJson(e)).toList();
//
//         states.value = allLocations
//             .map((e) => e.state.trim())
//             .toSet()
//             .toList();
//       } else {
//         Get.snackbar("Error", "Failed to fetch locations");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void onStateSelected(String value) {
//     selectedState.value = value;
//     selectedDistrict.value = '';
//     selectedMainLocation.value = '';
//
//     districts.value = allLocations
//         .where((e) => e.state == value)
//         .map((e) => e.district)
//         .toSet()
//         .toList();
//
//     mainLocations.clear();
//   }
//
//   void onDistrictSelected(String value) {
//     selectedDistrict.value = value;
//     selectedMainLocation.value = '';
//
//     mainLocations.value = allLocations
//         .where((e) =>
//     e.state == selectedState.value &&
//         e.district == value)
//         .map((e) => e.mainLocation)
//         .toSet()
//         .toList();
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/userlocation_model.dart';


class UserDistrictController extends GetxController {
  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchants/location-wise";

  var isLoading = false.obs;

  var allLocations = <UserLocationModel>[].obs;
  var states = <String>[].obs;
  var districts = <String>[].obs;
  var mainLocations = <String>[].obs;

  var selectedState = ''.obs;
  var selectedDistrict = ''.obs;
  var selectedMainLocation = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Load saved location (if exists)
    selectedState.value = box.read("state") ?? '';
    selectedDistrict.value = box.read("district") ?? '';
    selectedMainLocation.value = box.read("main_location") ?? '';

    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;

      final token = box.read("auth_token"); // Use auth token if needed

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List data = decoded['data'];

        allLocations.value =
            data.map((e) => UserLocationModel.fromJson(e)).toList();

        states.value =
            allLocations.map((e) => e.state.trim()).toSet().toList();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onStateSelected(String value) {
    selectedState.value = value;
    selectedDistrict.value = '';
    selectedMainLocation.value = '';

    districts.value = allLocations
        .where((e) => e.state == value)
        .map((e) => e.district)
        .toSet()
        .toList();

    mainLocations.clear();
  }

  void onDistrictSelected(String value) {
    selectedDistrict.value = value;
    selectedMainLocation.value = '';

    mainLocations.value = allLocations
        .where((e) =>
    e.state == selectedState.value && e.district == value)
        .map((e) => e.mainLocation)
        .toSet()
        .toList();
  }

  void saveLocation() {
    if (selectedState.value.isEmpty ||
        selectedDistrict.value.isEmpty ||
        selectedMainLocation.value.isEmpty) {
      Get.snackbar("Error", "Please select full location");
      return;
    }

    box.write("state", selectedState.value);
    box.write("district", selectedDistrict.value);
    box.write("main_location", selectedMainLocation.value);

    Get.snackbar("Success", "Location saved successfully");
    // ... your code
    Get.back();
  }
}
