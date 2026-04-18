import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/locationmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';


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

  // ================= AUTH =================
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

    if (value.isEmpty) {
      AppSnackbar.warning("Location cannot be empty");
      return;
    }

    if (!tempLocations.contains(value)) {
      tempLocations.add(value);
    } else {
      AppSnackbar.warning("Location already added");
    }
  }

  // ================= SAVE ALL =================
  Future<void> saveAll() async {
    /// ✅ Validation
    if (selectedState.value.isEmpty ||
        selectedDistrict.value.isEmpty ||
        tempLocations.isEmpty) {
      AppSnackbar.warning("State, District & Locations are required");
      return;
    }

    /// ✅ Auth check
    if (authToken.isEmpty) {
      AppSnackbar.error("Session expired. Please login again");
      Get.offAllNamed('/login');
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

        /// ✅ Success
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);

          if (body['status'] == 1) {
            _updateLocalState(loc);
          } else {
            AppSnackbar.error(body['message'] ?? "Failed to add location");
          }
        } else {
          /// ✅ API Error Handler
          final errorMessage = ApiErrorHandler.handleResponse(response);
          AppSnackbar.error(errorMessage);

          /// Stop loop if unauthorized
          if (response.statusCode == 401) break;
        }
      }

      tempLocations.clear();
      AppSnackbar.success("Locations added successfully");
    } catch (e) {
      /// ✅ Exception Handling
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FETCH LOCATIONS =================
  Future<void> fetchLocations() async {
    /// ✅ Auth check
    if (authToken.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }

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
        } else {
          AppSnackbar.error(body['message'] ?? "Failed to load locations");
        }
      } else {
        /// ✅ API Error Handler
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      /// ✅ Exception Handling
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
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