import 'package:get/get.dart';
import '../../../data/models/restaurantmodel.dart';

class RestaurantController extends GetxController {
  var restaurants = <Restaurant>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  void fetchRestaurants() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 2));

      var fetchedRestaurants = [
        Restaurant(
            id: '1',
            name: 'The Spice Hub',
            imageUrl: 'assets/images/indianreaturent.jpg',
            category: 'Indian',
            address: '123 Main Street',),
        Restaurant(
            id: '3',
            name: 'Pizza Palace',
            imageUrl: 'assets/images/indianreaturent.jpg',
            category: 'Italian',
            address: '789 Oak Avenue',
          ),
        Restaurant(
            id: '4',
            name: 'Burger Town',
            imageUrl: 'assets/images/indianreaturent.jpg',
            category: 'Fast Food',
            address: '101 Pine Street',
          ),
        Restaurant(
            id: '5',
            name: 'Noodle House',
            imageUrl: 'assets/images/indianreaturent.jpg',
            category: 'Chinese',
            address: '202 Maple Avenue',
          ),
      ];

      restaurants.assignAll(fetchedRestaurants);
    } catch (e) {
      print('Error fetching restaurants: $e');
    } finally {
      isLoading(false);
    }
  }

  List<Restaurant> get filteredRestaurants {
    var list = restaurants.toList();

    if (selectedCategory.value != 'All') {
      list = list
          .where((r) =>
      r.category.toLowerCase() ==
          selectedCategory.value.toLowerCase())
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((r) =>
          r.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    return list;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
