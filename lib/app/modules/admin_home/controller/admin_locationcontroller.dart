

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

  final String addApiUrl  = "https://eshoppy.co.in/api/admin/location/add";
  final String listApiUrl = "https://eshoppy.co.in/api/admin/location/list";

  // ── Data ──────────────────────────────────────────
  /// Flat list of all districts across all states (used by the list page).
  RxList<DistrictItem> districtList  = <DistrictItem>[].obs;

  /// Full state → district tree (available if you need it elsewhere).
  RxList<StateItem>    stateList     = <StateItem>[].obs;

  RxList<String>       tempLocations = <String>[].obs;

  RxString selectedState    = "".obs;
  RxString selectedDistrict = "".obs;
  RxBool   isLoading        = false.obs;

  // ── Auth ──────────────────────────────────────────
  String get authToken => box.read('auth_token') ?? '';

  Map<String, String> get authHeader => {
    'Accept'       : 'application/json',
    'Authorization': 'Bearer $authToken',
    'Content-Type' : 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  // ── Add Temp Location ─────────────────────────────
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

  // ── Save All ──────────────────────────────────────
  Future<void> saveAll() async {
    if (selectedState.value.isEmpty ||
        selectedDistrict.value.isEmpty ||
        tempLocations.isEmpty) {
      AppSnackbar.warning("State, District & Locations are required");
      return;
    }

    if (authToken.isEmpty) {
      AppSnackbar.error("Session expired. Please login again");
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;

    try {
      for (final loc in List<String>.from(tempLocations)) {
        final response = await http.post(
          Uri.parse(addApiUrl),
          headers: authHeader,
          body: jsonEncode({
            // Keys match the API: state / district / location
            "state"   : selectedState.value,
            "district": selectedDistrict.value,
            "location": loc,
          }),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          if (body['status'] == 1) {
            // Use the server-normalised values from the response
            final data = body['data'] as Map<String, dynamic>? ?? {};
            _updateLocalDistrict(
              serverState   : data['state']    ?.toString() ?? selectedState.value,
              serverDistrict: data['district'] ?.toString() ?? selectedDistrict.value,
              serverLocation: data['location'] ?.toString() ?? loc,
            );
          } else {
            AppSnackbar.error(body['message'] ?? "Failed to add location");
          }
        } else {
          final errorMessage = ApiErrorHandler.handleResponse(response);
          AppSnackbar.error(errorMessage);
          if (response.statusCode == 401) break;
        }
      }

      tempLocations.clear();
      AppSnackbar.success("Locations added successfully");
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch Locations ───────────────────────────────
  /// Parses the new API shape:
  /// { "data": [ { "state": "kerala", "districts": [ { "district": "kannur",
  ///   "main_locations": ["caltex", ...] } ] } ] }
  Future<void> fetchLocations() async {
    if (authToken.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;
    districtList.clear();
    stateList.clear();

    try {
      final response = await http.get(
        Uri.parse(listApiUrl),
        headers: authHeader,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1) {
          final List<dynamic> data = body['data'] as List<dynamic>? ?? [];

          final Map<String, StateItem> mergedStates = {};

          for (final raw in data) {
            final item = StateItem.fromJson(raw as Map<String, dynamic>);
            final key  = item.state.toLowerCase().trim();

            if (mergedStates.containsKey(key)) {
              // Merge districts into the existing state entry
              final existing = mergedStates[key]!;
              final Map<String, DistrictItem> districtMap = {
                for (final d in existing.districts)
                  d.district.toLowerCase(): d,
              };
              for (final d in item.districts) {
                final dk = d.district.toLowerCase();
                districtMap[dk] = districtMap.containsKey(dk)
                    ? districtMap[dk]!.merge(d)
                    : d;
              }
              mergedStates[key] = StateItem(
                state    : existing.state,
                districts: districtMap.values.toList(),
              );
            } else {
              mergedStates[key] = item;
            }
          }

          stateList.addAll(mergedStates.values);

          // ── Flatten to districtList (used by list page) ──
          // Merge districts that share the same name across states.
          final Map<String, DistrictItem> flatDistricts = {};
          for (final state in mergedStates.values) {
            for (final district in state.districts) {
              final dk = district.district.toLowerCase();
              flatDistricts[dk] = flatDistricts.containsKey(dk)
                  ? flatDistricts[dk]!.merge(district)
                  : district;
            }
          }
          districtList.addAll(flatDistricts.values);

        } else {
          AppSnackbar.error(body['message'] ?? "Failed to load locations");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _updateLocalDistrict({
    required String serverState,
    required String serverDistrict,
    required String serverLocation,
  }) {
    final dk = serverDistrict.toLowerCase();

    final existing = districtList.firstWhereOrNull(
          (d) => d.district.toLowerCase() == dk,
    );

    if (existing == null) {
      districtList.add(DistrictItem(
        district : serverDistrict,
        locations: [LocationItem(location: serverLocation)],
      ));
    } else {
      if (!existing.locations.any(
            (l) => l.location.toLowerCase() == serverLocation.toLowerCase(),
      )) {
        existing.locations.add(LocationItem(location: serverLocation));
        districtList.refresh();
      }
    }

    // Also update stateList
    final sk = serverState.toLowerCase();
    final existingState = stateList.firstWhereOrNull(
          (s) => s.state.toLowerCase() == sk,
    );

    if (existingState == null) {
      stateList.add(StateItem(
        state    : serverState,
        districts: [
          DistrictItem(
            district : serverDistrict,
            locations: [LocationItem(location: serverLocation)],
          ),
        ],
      ));
    } else {
      final existingDist = existingState.districts.firstWhereOrNull(
            (d) => d.district.toLowerCase() == dk,
      );
      if (existingDist == null) {
        existingState.districts.add(DistrictItem(
          district : serverDistrict,
          locations: [LocationItem(location: serverLocation)],
        ));
      } else if (!existingDist.locations.any(
            (l) => l.location.toLowerCase() == serverLocation.toLowerCase(),
      )) {
        existingDist.locations.add(LocationItem(location: serverLocation));
      }
      stateList.refresh();
    }
  }
}