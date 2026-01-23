
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/user_category model.dart';

class UserCategoryController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/usercategoriesget";

  var isLoading = false.obs;
  var categories = <UserCategoryModel>[].obs;

  String get _userKey => box.read("user_id") ?? "guest";

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final token = box.read("auth_token");
    if (token == null) return;

    final state = box.read('state_$_userKey') ?? '';
    final district = box.read('district_$_userKey') ?? '';
    final mainLocation = box.read('main_location_$_userKey') ?? '';

    if (state.isEmpty || district.isEmpty || mainLocation.isEmpty) {
      categories.clear(); // no location selected
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "state": state,
          "district": district,
          "main_location": mainLocation,
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'];
        categories.value =
            list.map((e) => UserCategoryModel.fromJson(e)).toList();
      } else {
        categories.clear();
      }
    } catch (e) {
      categories.clear();
      print("Category fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearCategories() {
    categories.clear();
  }
}
