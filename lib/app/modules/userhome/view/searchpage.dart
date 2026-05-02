
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../product/widgtet/productcard.dart';
import '../controller/search_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController controller = Get.put(SearchController());
  final TextEditingController searchCtrl = TextEditingController();
  final RxString searchText = ''.obs; // ✅ Reactive string

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Products"),
      ),
      body: Column(
        children: [

          // 🔍 Search Box
          Padding(
            padding: const EdgeInsets.all(12),
            child: Obx(() => TextField(
              controller: searchCtrl,
              onChanged: (value) {
                searchText.value = value; // ✅ Update reactive variable
                controller.onSearchChanged(value);
              },
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.value.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchCtrl.clear();
                    searchText.value = '';
                    controller.productList.clear();
                  },
                )
                    : const SizedBox.shrink(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )),
          ),

          // 📦 Results
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (searchText.value.isEmpty) { // ✅ Use reactive variable
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        "Type to search products",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              if (controller.productList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        "No Products Found",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: controller.productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  var product = controller.productList[index];

                  return ProductCard(
                    productName: product["product_name"],
                    imageUrl: product["image"],
                    price: product["price"],
                    productId: int.tryParse(product["id"].toString()) ?? 0,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}