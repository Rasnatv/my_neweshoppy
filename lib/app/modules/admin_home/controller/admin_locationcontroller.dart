//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/models/locationmodel.dart';
//
// class LocationController extends GetxController {
//   final box = GetStorage();
//   final String apiUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/location/add";
//
//   RxList<StateItem> stateList = <StateItem>[].obs;
//   RxString selectedState = "".obs;
//   RxString selectedDistrict = "".obs;
//   RxList<String> tempLocations = <String>[].obs;
//   var isLoading = false.obs;
//
//   // Add location to temporary list
//   void addTempLocation(String name) {
//     if (name.trim().isNotEmpty) {
//       tempLocations.add(name.trim());
//     }
//   }
//
//   String get authToken => box.read('auth_token') ?? '';
//
//   Map<String, String> get authHeader => {
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $authToken',
//     'Content-Type': 'application/json',
//   };
//
//   // SAVE All locations under existing state/district if present
//   Future<void> saveAll() async {
//     if (selectedState.value.isEmpty ||
//         selectedDistrict.value.isEmpty ||
//         tempLocations.isEmpty) {
//       Get.snackbar("Error", "State, District & Locations are required");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       for (var loc in tempLocations) {
//         // Call API
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: authHeader,
//           body: jsonEncode({
//             "state": selectedState.value,
//             "district": selectedDistrict.value,
//             "location": loc,
//           }),
//         );
//
//         if (response.statusCode == 200) {
//           final body = jsonDecode(response.body);
//           if (body['status'] == 1) {
//             // Update local stateList
//             _updateLocalState(loc);
//             Get.snackbar(
//               "Success",
//               "${loc} added successfully",
//               backgroundColor: Colors.green,
//               colorText: Colors.white,
//             );
//           } else {
//             Get.snackbar(
//               "Error",
//               body['message'] ?? "Failed to add ${loc}",
//               backgroundColor: Colors.red,
//               colorText: Colors.white,
//             );
//           }
//         } else if (response.statusCode == 401) {
//           Get.snackbar(
//             "Error",
//             "Session expired. Please login again.",
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         } else {
//           Get.snackbar(
//             "Error",
//             "Server error: ${response.statusCode}",
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         }
//       }
//
//       tempLocations.clear();
//       update();
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _updateLocalState(String loc) {
//     // Check if state exists
//     StateItem? existingState = stateList.firstWhereOrNull(
//           (s) => s.state == selectedState.value,
//     );
//
//     if (existingState == null) {
//       // Create new state
//       stateList.add(
//         StateItem(
//           state: selectedState.value,
//           districts: [
//             DistrictItem(
//               district: selectedDistrict.value,
//               locations: [LocationItem(location: loc)],
//             )
//           ],
//         ),
//       );
//     } else {
//       // State exists → check district
//       DistrictItem? existingDistrict = existingState.districts
//           .firstWhereOrNull((d) => d.district == selectedDistrict.value);
//
//       if (existingDistrict == null) {
//         // District doesn't exist → add new district
//         existingState.districts.add(
//           DistrictItem(
//             district: selectedDistrict.value,
//             locations: [LocationItem(location: loc)],
//           ),
//         );
//       } else {
//         // District exists → add new location if not duplicate
//         bool exists = existingDistrict.locations
//             .any((item) => item.location == loc);
//
//         if (!exists) {
//           existingDistrict.locations.add(LocationItem(location: loc));
//         }
//       }
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/locationmodel.dart';

class LocationController extends GetxController {
  final box = GetStorage();

  // APIs
  final String addApiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/location/add";

  final String listApiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/location/list";

  // Data
  RxList<StateItem> stateList = <StateItem>[].obs;
  RxList<String> tempLocations = <String>[].obs;

  RxString selectedState = "".obs;
  RxString selectedDistrict = "".obs;

  RxBool isLoading = false.obs;

  // Auth
  String get authToken => box.read('auth_token') ?? '';

  Map<String, String> get authHeader => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  // ================= ADD TEMP LOCATION =================
  void addTempLocation(String name) {
    final value = name.trim();
    if (value.isEmpty) return;
    if (!tempLocations.contains(value)) {
      tempLocations.add(value);
    }
  }

  // ================= SAVE ALL =================
  Future<void> saveAll() async {
    if (selectedState.value.isEmpty ||
        selectedDistrict.value.isEmpty ||
        tempLocations.isEmpty) {
      Get.snackbar("Error", "State, District & Locations are required");
      return;
    }

    isLoading.value = true;

    try {
      for (final loc in tempLocations) {
        final response = await http.post(
          Uri.parse(addApiUrl),
          headers: authHeader,
          body: jsonEncode({
            "state": selectedState.value,
            "district": selectedDistrict.value,
            "location": loc,
          }),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);

          if (body['status'] == 1) {
            _updateLocalState(loc);
          }
        } else if (response.statusCode == 401) {
          Get.snackbar("Session Expired", "Please login again");
          break;
        }
      }

      tempLocations.clear();
      Get.snackbar("Success", "Locations added successfully");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FETCH LOCATIONS =================
  Future<void> fetchLocations() async {
    isLoading.value = true;
    stateList.clear();

    try {
      final response = await http.get(
        Uri.parse(listApiUrl),
        headers: authHeader,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1) {
          final Map<String, dynamic> data = body['data'];

          data.forEach((stateName, districtMap) {
            List<DistrictItem> districts = [];

            (districtMap as Map<String, dynamic>)
                .forEach((districtName, locations) {
              List<LocationItem> locationItems =
              (locations as List).toSet().map((loc) {
                return LocationItem(location: loc.toString());
              }).toList();

              districts.add(
                DistrictItem(
                  district: districtName,
                  locations: locationItems,
                ),
              );
            });

            stateList.add(
              StateItem(
                state: stateName,
                districts: districts,
              ),
            );
          });
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Session Expired", "Please login again");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load locations");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOCAL UPDATE =================
  void _updateLocalState(String loc) {
    StateItem? state = stateList.firstWhereOrNull(
          (s) => s.state == selectedState.value,
    );

    if (state == null) {
      stateList.add(
        StateItem(
          state: selectedState.value,
          districts: [
            DistrictItem(
              district: selectedDistrict.value,
              locations: [LocationItem(location: loc)],
            ),
          ],
        ),
      );
      return;
    }

    DistrictItem? district = state.districts.firstWhereOrNull(
          (d) => d.district == selectedDistrict.value,
    );

    if (district == null) {
      state.districts.add(
        DistrictItem(
          district: selectedDistrict.value,
          locations: [LocationItem(location: loc)],
        ),
      );
      return;
    }

    if (!district.locations.any((l) => l.location == loc)) {
      district.locations.add(LocationItem(location: loc));
    }
  }
}
