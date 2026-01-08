import 'package:get/get.dart';
import '../../../common/storage/storage.dart';
import '../../../data/models/productmodel.dart';
//path to your Storage class

class WishlistController extends GetxController {
  var favoriteItems = <Product>[].obs;

  get Storage => null;

  @override
  void onInit() {
    super.onInit();
    loadFavoritesFromStorage();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      favoriteItems.removeWhere((p) => p.id == product.id);
      Get.snackbar('Removed', '${product.title} removed from favorites');
    } else {
      favoriteItems.add(product);
      Get.snackbar('Added', '${product.title} added to favorites');
    }
    saveFavoritesToStorage();
  }

  bool isFavorite(Product product) {
    return favoriteItems.any((p) => p.id == product.id);
  }

  void saveFavoritesToStorage() {
    final favJson = favoriteItems.map((p) => p.toJson()).toList();
    Storage.saveValueForce('favorites', favJson);
  }

  void loadFavoritesFromStorage() {
    final storedFavs = Storage.getValue<List>('favorites');
    if (storedFavs != null) {
      favoriteItems.value =
          storedFavs.map((json) => Product.fromJson(json)).toList();
    }
  }
}
