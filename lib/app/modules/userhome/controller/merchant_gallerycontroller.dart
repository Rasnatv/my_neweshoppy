// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/models/merchant_gallerymodel.dart';
//
//
// class MerchantGalleryController extends GetxController {
//   final box = GetStorage();
//
//   RxBool isLoading = false.obs;
//   RxList<MerchantGalleryImage> images = <MerchantGalleryImage>[].obs;
//
//   Future<void> loadGallery(int merchantId) async {
//     try {
//       isLoading.value = true;
//
//       final token = box.read('auth_token');
//
//       final response = await http.get(
//         Uri.parse(
//           'https://rasma.astradevelops.in/e_shoppyy/public/api/app/merchant/images?merchant_id=$merchantId',
//         ),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );
//
//       final data = json.decode(response.body);
//
//       if (response.statusCode == 200 && data['status'] == 1) {
//         images.value = List<MerchantGalleryImage>.from(
//           data['data'].map((e) => MerchantGalleryImage.fromJson(e)),
//         );
//       } else {
//         images.clear();
//       }
//     } catch (e) {
//       images.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
