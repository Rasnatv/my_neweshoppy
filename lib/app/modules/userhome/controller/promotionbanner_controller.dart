
import 'package:get/get.dart';

class PromotionController extends GetxController {
  RxList<String> bannerImages = <String>[].obs;

  bool get hasBanners => bannerImages.isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    /// TODO: Fetch from Firebase or API
    fetchBanners();
  }

  void fetchBanners() {
    bannerImages.value = [

      "assets/images/promo1.jpg",
      "assets/images/promo2.jpg",
      "assets/images/promo3.jpg"

    ];

  }
}
