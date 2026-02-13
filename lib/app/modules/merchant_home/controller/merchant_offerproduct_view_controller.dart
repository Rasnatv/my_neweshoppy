import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/merchant_offerproductviewmodel.dart';

class MerchantOfferProductViewController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var offerProduct = Rxn<MerchantViewOfferProduct>();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/view-offer-product";

  @override
  void onInit() {
    fetchOfferProduct(1); // offer_id
    super.onInit();
  }

  Future<void> fetchOfferProduct(int offerId) async {
    try {
      isLoading(true);

      String token = box.read('auth_token') ?? "";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 🔑 TOKEN ADDED
        },
        body: jsonEncode({
          "offer_id": offerId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 1) {
          offerProduct.value =
              MerchantViewOfferProduct.fromJson(jsonData['data']);
        } else {
          Get.snackbar("Error", jsonData['message']);
        }
      } else {
        Get.snackbar("Error", "Server Error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
