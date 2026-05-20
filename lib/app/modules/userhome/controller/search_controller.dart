
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import 'dart:async';  // ✅ Add this import

class SearchController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var productList = [].obs;

  Timer? _debounce;  // ✅ Add this

  // ✅ Add this method
  void onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchProducts(keyword);
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();  // ✅ Clean up timer
    super.onClose();
  }

  Future<void> searchProducts(String keyword) async {


    try {
      isLoading.value = true;

      String token = box.read("auth_token") ?? "";

      var response = await http.post(
        Uri.parse(
            "https://eshoppy.co.in/api/search-products"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "keyword": keyword,
          "state": "",
          "district": ""
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        productList.value = data["data"];
      } else {
        productList.clear();

        // ✅ HANDLE 200 BUT status=false
        if (response.statusCode == 200) {
          final message = data["message"] ?? "No results found";
          AppSnackbar.error(message);
        } else {
          // ✅ API ERROR HANDLER
          final errorMessage = ApiErrorHandler.handleResponse(response);
          AppSnackbar.error(errorMessage);
        }
      }
    } catch (e) {
      productList.clear();

      // ✅ EXCEPTION HANDLER
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
