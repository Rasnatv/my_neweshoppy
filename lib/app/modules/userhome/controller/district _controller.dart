

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/userlocation_model.dart';
import 'usercategory_controller.dart';

class UserLocationController extends GetxController {
  final box = GetStorage();

  final String locationApi =
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
    _initFlow();
  }

  /// 🔥 MASTER INIT
  Future<void> _initFlow() async {
    isLoading.value = true;

    restoreLocation();
    await fetchLocations();

    // rebuild dropdowns if location exists
    if (selectedState.value.isNotEmpty) {
      districts.value = allLocations
          .where((e) =>
      e.state.toLowerCase() ==
          selectedState.value.toLowerCase())
          .map((e) => _cap(e.district))
          .toSet()
          .toList();
    }

    if (selectedDistrict.value.isNotEmpty) {
      mainLocations.value = allLocations
          .where((e) =>
      e.state.toLowerCase() ==
          selectedState.value.toLowerCase() &&
          e.district.toLowerCase() ==
              selectedDistrict.value.toLowerCase())
          .map((e) => _cap(e.mainLocation))
          .toSet()
          .toList();
    }

    isLoading.value = false;
  }

  /// 🔐 RESTORE LOCATION (TOKEN BASED)
  void restoreLocation() {
    final token = box.read('auth_token');

    if (token == null) {
      _clearSelected();
      return;
    }

    selectedState.value = box.read('state_$token') ?? '';
    selectedDistrict.value = box.read('district_$token') ?? '';
    selectedMainLocation.value =
        box.read('main_location_$token') ?? '';
  }

  /// 🌍 FETCH LOCATIONS
  Future<void> fetchLocations() async {
    final token = box.read("auth_token");
    if (token == null) return;

    final res = await http.get(
      Uri.parse(locationApi),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      final List data = json.decode(res.body)['data'];
      allLocations.value =
          data.map((e) => UserLocationModel.fromJson(e)).toList();

      states.value =
          allLocations.map((e) => _cap(e.state)).toSet().toList();
    }
  }
  void onStateSelected(String v) {
    selectedState.value = v;
    selectedDistrict.value = '';
    selectedMainLocation.value = '';

    districts.value = allLocations
        .where((e) => e.state.toLowerCase() == v.toLowerCase())
        .map((e) => _cap(e.district))
        .toSet()
        .toList();

    mainLocations.clear();
  }

  void onDistrictSelected(String v) {
    selectedDistrict.value = v;
    selectedMainLocation.value = '';

    mainLocations.value = allLocations
        .where((e) =>
    e.state.toLowerCase() ==
        selectedState.value.toLowerCase() &&
        e.district.toLowerCase() == v.toLowerCase())
        .map((e) => _cap(e.mainLocation))
        .toSet()
        .toList();
  }

  Future<void> saveLocation() async {
    final token = box.read('auth_token');
    if (token == null) return;

    box.write('state_$token', selectedState.value);
    box.write('district_$token', selectedDistrict.value);
    box.write('main_location_$token', selectedMainLocation.value);

    final categoryController = Get.find<UserCategoryController>();
    await categoryController.fetchCategories(
      state: selectedState.value,
      district: selectedDistrict.value,
      mainLocation: selectedMainLocation.value,
    );
  }

  void _clearSelected() {
    selectedState.value = '';
    selectedDistrict.value = '';
    selectedMainLocation.value = '';
  }

  String _cap(String v) =>
      v.isEmpty ? v : v[0].toUpperCase() + v.substring(1).toLowerCase();
}
