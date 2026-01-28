import 'dart:convert';
import 'package:eshoppy/app/modules/userhome/controller/userwithshopaboutmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class MerchantAboutController extends GetxController {
  final isLoading = false.obs;
  final about = Rxn<MerchantAboutModel>();

  final box = GetStorage();

  Future<void> loadAbout(int merchantId) async {
    try {
      isLoading.value = true;

      final token = box.read('auth_token'); // 🔐 your saved auth token

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/aboutusers",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      final jsonData = json.decode(response.body);

      if (jsonData['status'] == "1") {
        about.value =
            MerchantAboutModel.fromJson(jsonData['data']);
      } else {
        Get.snackbar("Error", jsonData['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load merchant details");
    } finally {
      isLoading.value = false;
    }
  }
}
