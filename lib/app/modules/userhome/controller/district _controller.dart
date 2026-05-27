
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/userlocation_model.dart';
import '../../../widgets/network_trihgiger.dart';
import '../../merchantlogin/widget/successwidget.dart';
import 'homedatacontroller.dart';
import 'usercategory_controller.dart';

class UserLocationController extends GetxController {
  final box = GetStorage();

  final String locationApi =
      "https://eshoppy.co.in/api/merchants/location-wise";

  var isLoading = false.obs;

  var allLocations  = <UserLocationModel>[].obs;
  var states        = <String>[].obs;
  var districts     = <String>[].obs;
  var mainLocations = <String>[].obs;

  var selectedState        = ''.obs;
  var selectedDistrict     = ''.obs;
  var selectedMainLocation = ''.obs;

  bool get hasAnySelection => selectedDistrict.value.isNotEmpty;

  bool get hasPartialSelection =>
      selectedState.value.isNotEmpty && selectedDistrict.value.isNotEmpty;

  bool get hasFullSelection =>
      selectedState.value.isNotEmpty &&
          selectedDistrict.value.isNotEmpty &&
          selectedMainLocation.value.isNotEmpty;

  // ── Storage key — guest uses 'guest', logged-in uses token ───────────────
  String get _storageKey => box.read('auth_token') ?? 'guest';

  @override
  void onInit() {
    super.onInit();
    _initFlow();
  }

  Future<void> refresh() async {
    allLocations.clear();
    states.clear();
    districts.clear();
    mainLocations.clear();
    await _initFlow();
  }

  Future<void> _initFlow() async {
    isLoading.value = true;
    restoreLocation();
    await fetchLocations();

    if (selectedState.value.isNotEmpty) {
      districts.value = allLocations
          .where((e) =>
      e.state.toLowerCase() == selectedState.value.toLowerCase())
          .map((e) => _cap(e.district))
          .toSet()
          .toList();
    }

    if (selectedDistrict.value.isNotEmpty) {
      mainLocations.value = allLocations
          .where((e) =>
      e.state.toLowerCase() == selectedState.value.toLowerCase() &&
          e.district.toLowerCase() ==
              selectedDistrict.value.toLowerCase())
          .map((e) => _cap(e.mainLocation))
          .toSet()
          .toList();
    }

    isLoading.value = false;
  }

  void restoreLocation() {
    // Guests may have previously selected a location — restore it
    selectedState.value        = box.read('state_$_storageKey') ?? '';
    selectedDistrict.value     = box.read('district_$_storageKey') ?? '';
    selectedMainLocation.value = box.read('main_location_$_storageKey') ?? '';
  }

  Future<void> fetchLocations() async {
    final token = box.read<String?>('auth_token');

    try {
      final res = await http.get(
        Uri.parse(locationApi),
        headers: {
          "Accept": "application/json",
          // Send token only when available — guests call without it
          if (token != null && token.isNotEmpty)
            "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final List data = decoded['data'] ?? [];
        allLocations.value =
            data.map((e) => UserLocationModel.fromJson(e)).toList();
        states.value =
            allLocations.map((e) => _cap(e.state)).toSet().toList();
      } else {
        allLocations.clear();
        states.clear();
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      allLocations.clear();
      states.clear();
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
    }
  }

  void onStateSelected(String v) {
    selectedState.value        = v;
    selectedDistrict.value     = '';
    selectedMainLocation.value = '';

    districts.value = allLocations
        .where((e) => e.state.toLowerCase() == v.toLowerCase())
        .map((e) => _cap(e.district))
        .toSet()
        .toList();

    mainLocations.clear();
  }

  void onDistrictSelected(String v) {
    selectedDistrict.value     = v;
    selectedMainLocation.value = '';

    mainLocations.value = allLocations
        .where((e) =>
    e.state.toLowerCase() == selectedState.value.toLowerCase() &&
        e.district.toLowerCase() == v.toLowerCase())
        .map((e) => _cap(e.mainLocation))
        .toSet()
        .toList();
  }

  Future<void> saveLocation() async {
    // Persist using guest key or token key
    box.write('state_$_storageKey',         selectedState.value);
    box.write('district_$_storageKey',      selectedDistrict.value);
    box.write('main_location_$_storageKey', selectedMainLocation.value);

    if (!hasPartialSelection) return;

    try {
      await Get.find<HomeDataController>().fetchHomeData(
        state:        selectedState.value,
        district:     selectedDistrict.value,
        mainLocation: selectedMainLocation.value,
      );
    } catch (_) {}

    try {
      await Get.find<UserCategoryController>().fetchCategories(
        state:        selectedState.value,
        district:     selectedDistrict.value,
        mainLocation: selectedMainLocation.value,
      );
    } catch (_) {}
  }

  void clearSelected() {
    selectedState.value        = '';
    selectedDistrict.value     = '';
    selectedMainLocation.value = '';
    districts.clear();
    mainLocations.clear();

    box.remove('state_$_storageKey');
    box.remove('district_$_storageKey');
    box.remove('main_location_$_storageKey');

    try {
      Get.find<HomeDataController>().clearHomeData();
    } catch (_) {}
  }

  String _cap(String v) =>
      v.isEmpty ? v : v[0].toUpperCase() + v.substring(1).toLowerCase();
}