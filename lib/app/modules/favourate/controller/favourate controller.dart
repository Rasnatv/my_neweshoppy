import 'package:get/get.dart';

class FavouriteController extends GetxController {
  RxList<Map<String, dynamic>> favourites = <Map<String, dynamic>>[].obs;

  void toggleFavourite({
    required String id,
    required String name,
    required String image,
    required double price,
  }) {
    final index = favourites.indexWhere((item) => item['id'] == id);

    if (index >= 0) {
      favourites.removeAt(index);
    } else {
      favourites.add({
        'id': id,
        'name': name,
        'image': image,
        'price': price,
      });
    }
  }

  bool isFavourite(String id) {
    return favourites.any((item) => item['id'] == id);
  }
}
