// import 'package:flutter/material.dart';
//
// import '../../../../common/constants/app_images.dart';
// import '../../../../common/style/app_colors.dart';
// import '../../../../data/models/productmodel.dart';
// class Product {
//   final String name;
//   final double price;
//   final String image;
//   Product({required this.name, required this.price, required this.image});
// }
// class ShopProductsPage extends StatelessWidget {
//   final Map<String, List<Product>> dummyProducts = {
//     "Shop 1": [
//       Product(name: "Burger", price: 150, image: ""),
//       Product(name: "Pizza", price: 250, image: ""),
//     ],
//     "Shop 2": [
//       Product(name: "Cake", price: 200, image: ""),
//       Product(name: "Ice Cream", price: 100, image: ""),
//     ],
//     "Shop 3": [
//       Product(name: "Coffee", price: 50, image: ""),
//       Product(name: "Tea", price: 30, image: ""),
//     ],
//   };
//   final String shopName;
//   final List<Product> products;
//    ShopProductsPage({super.key, required this.shopName, required this.products});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(shopName), backgroundColor:AppColors.kPrimary),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: ListTile(
//               leading: Image.asset(AppImages.prduct2),
//               title: Text(product.name),
//               subtitle: Text("₹ ${product.price}"),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../admin_shoppage.dart';

/// ---------------- PRODUCT MODEL ----------------
class Products {
  final String name;
  final double price;
  final String image;

  Products({
    required this.name,
    required this.price,
    required this.image,
  });
}

/// ---------------- SHOP PRODUCTS PAGE ----------------
class ShopProductsPage extends StatelessWidget {
  final String shopName;
  final List<Products> products;

  const ShopProductsPage({
    super.key,
    required this.shopName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shopName,style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
      ),
      body: products.isEmpty
          ? const Center(
        child: Text(
          "No products available",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Image.asset(
                product.image.isEmpty
                    ? AppImages.prduct2
                    : product.image,
                width: 40,
              ),
              title: Text(product.name),
              subtitle: Text("₹ ${product.price}"),
            ),
          );
        },
      ),
    );
  }
}
