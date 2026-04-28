
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantAdvertisementGetController extends GetxController {
  final ads = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final GetStorage box = GetStorage();
  String authToken = "";

  @override
  void onInit() {
    super.onInit();
    authToken = box.read("auth_token") ?? "";


    fetchAdvertisements();
  }

  Future<void> fetchAdvertisements() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "https://eshoppy.co.in/api/getadvertisement",
        ),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body["status"] == "1" || body["status"] == 1) {
          ads.value = List<Map<String, dynamic>>.from(
            body["data"].map((e) {
              String? district = e["district"]?.toString();
              String? area = e["main_location"]?.toString();

              if (district != null && district
                  .trim()
                  .isEmpty) district = null;
              if (area != null && area
                  .trim()
                  .isEmpty) area = null;

              return {
                "id": e["id"].toString(),
                "title": e["advertisement"],
                "image": e["banner_image"],
                "district": district,
                "main_location": area,
              };
            }),
          );
        }
      }

    } catch (e) {
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
