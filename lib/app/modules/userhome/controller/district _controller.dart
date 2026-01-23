
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

  String get _userKey => box.read("user_id") ?? "guest";

  @override
  void onInit() {
    super.onInit();
    restoreLocation();
    fetchLocations();
  }

  void restoreLocation() {
    selectedState.value = box.read('state_$_userKey') ?? '';
    selectedDistrict.value = box.read('district_$_userKey') ?? '';
    selectedMainLocation.value = box.read('main_location_$_userKey') ?? '';
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;
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
    } finally {
      isLoading.value = false;
    }
  }

  void onStateSelected(String value) {
    selectedState.value = value;
    selectedDistrict.value = '';
    selectedMainLocation.value = '';
    districts.value = allLocations
        .where((e) => e.state.toLowerCase() == value.toLowerCase())
        .map((e) => _cap(e.district))
        .toSet()
        .toList();
    mainLocations.clear();
  }

  void onDistrictSelected(String value) {
    selectedDistrict.value = value;
    selectedMainLocation.value = '';
    mainLocations.value = allLocations
        .where((e) =>
    e.state.toLowerCase() == selectedState.value.toLowerCase() &&
        e.district.toLowerCase() == value.toLowerCase())
        .map((e) => e.mainLocation)
        .toSet()
        .toList();
  }

  Future<void> saveLocation() async {
    box.write('state_$_userKey', selectedState.value);
    box.write('district_$_userKey', selectedDistrict.value);
    box.write('main_location_$_userKey', selectedMainLocation.value);

    final categoryController = Get.put(UserCategoryController());
    await categoryController.fetchCategories();
  }

  String _cap(String v) =>
      v.isEmpty ? v : v[0].toUpperCase() + v.substring(1).toLowerCase();

  void resetLocation() {
    selectedState.value = '';
    selectedDistrict.value = '';
    selectedMainLocation.value = '';
    states.clear();
    districts.clear();
    mainLocations.clear();
    allLocations.clear();
  }
}
