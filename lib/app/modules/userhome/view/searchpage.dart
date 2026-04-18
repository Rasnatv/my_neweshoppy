import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../product/widgtet/productcard.dart';
import '../controller/search_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final SearchController controller = Get.put(SearchController());
  final TextEditingController searchCtrl = TextEditingController();

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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    controller.searchProducts(searchCtrl.text);
                  },
                  child: const Text("Search"),
                )
              ],
            ),
          ),
    Expanded(
    child: Obx(() {
    if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
    }

    if (controller.productList.isEmpty) {
    return const Center(child: Text("No Products Found"));
    }

    return GridView.builder(
    padding: const EdgeInsets.all(14),
    itemCount: controller.productList.length,
    gridDelegate:
    const SliverGridDelegateWithFixedCrossAxisCount(
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
     // 🔥 adjust based on API
    );
    },
    );
    }),
    )


      ]),
    );
  }
}