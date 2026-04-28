
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

  var allLocations = <UserLocationModel>[].obs;
  var states       = <String>[].obs;
  var districts    = <String>[].obs;
  var mainLocations = <String>[].obs;

  var selectedState        = ''.obs;
  var selectedDistrict     = ''.obs;
  var selectedMainLocation = ''.obs;

  /// True if at least state is picked
  bool get hasAnySelection =>
      selectedState.value.isNotEmpty ||
          selectedDistrict.value.isNotEmpty ||
          selectedMainLocation.value.isNotEmpty;

  /// True if at least state + district are picked (enough for events/categories)
  bool get hasPartialSelection =>
      selectedState.value.isNotEmpty && selectedDistrict.value.isNotEmpty;

  /// True only when all three are picked
  bool get hasFullSelection =>
      selectedState.value.isNotEmpty &&
          selectedDistrict.value.isNotEmpty &&
          selectedMainLocation.value.isNotEmpty;

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
    final token = box.read('auth_token');
    if (token == null) {
      clearSelected();
      return;
    }
    selectedState.value        = box.read('state_$token') ?? '';
    selectedDistrict.value     = box.read('district_$token') ?? '';
    selectedMainLocation.value = box.read('main_location_$token') ?? '';
  }

  // Future<void> fetchLocations() async {
  //   final token = box.read("auth_token");
  //
  //   try {
  //     final res = await http.get(
  //       Uri.parse(locationApi),
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //
  //     if (res.statusCode == 200) {
  //       final decoded = json.decode(res.body);
  //       final List data = decoded['data'] ?? [];
  //       allLocations.value =
  //           data.map((e) => UserLocationModel.fromJson(e)).toList();
  //       states.value =
  //           allLocations.map((e) => _cap(e.state)).toSet().toList();
  //     } else {
  //       allLocations.clear();
  //       states.clear();
  //       AppSnackbar.error(ApiErrorHandler.handleResponse(res));
  //     }
  //   } catch (e) {
  //     allLocations.clear();
  //     states.clear();
  //   }
  // }
  // userlocation_controller.dart  — updated fetchLocations()

  Future<void> fetchLocations() async {
    final token = box.read("auth_token");

    try {
      final res = await http.get(
        Uri.parse(locationApi),
        headers: {
          "Accept": "application/json",
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
        // handleResponse calls handleUnauthorized() automatically on 401
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      allLocations.clear();
      states.clear();

      // Returns "" for SocketException — skip snackbar in that case
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
    final token = box.read('auth_token');

    // 1. Persist whatever was selected
    box.write('state_$token',         selectedState.value);
    box.write('district_$token',      selectedDistrict.value);
    box.write('main_location_$token', selectedMainLocation.value);

    // 2. Need at least state + district to show anything
    if (!hasPartialSelection) return;

    // 3. Refresh events & banners (location is optional — backend filters)
    try {
      await Get.find<HomeDataController>().fetchHomeData(
        state:        selectedState.value,
        district:     selectedDistrict.value,
        mainLocation: selectedMainLocation.value, // '' when not chosen
      );
    } catch (_) {}

    // 4. Refresh categories (same partial logic)
    try {
      await Get.find<UserCategoryController>().fetchCategories(
        state:        selectedState.value,
        district:     selectedDistrict.value,
        mainLocation: selectedMainLocation.value, // '' when not chosen
      );
    } catch (_) {}
  }

  Future<void> skipLocation() async {
    clearSelected();

    final token = box.read('auth_token');
    if (token != null) {
      box.remove('state_$token');
      box.remove('district_$token');
      box.remove('main_location_$token');
    }

    try {
      Get.find<HomeDataController>().clearHomeData();
    } catch (_) {}

    try {
      Get.find<UserCategoryController>().categories.clear();
    } catch (_) {}
  }

  void clearSelected() {
    selectedState.value        = '';
    selectedDistrict.value     = '';
    selectedMainLocation.value = '';
    districts.clear();
    mainLocations.clear();
  }

  String _cap(String v) =>
      v.isEmpty ? v : v[0].toUpperCase() + v.substring(1).toLowerCase();
}