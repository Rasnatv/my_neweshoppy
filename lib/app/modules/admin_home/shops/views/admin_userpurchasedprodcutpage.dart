
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/admin_userpurchasecontroller.dart';


class UserPurchasedProductsPage extends StatelessWidget {
  final String userId;
  final String userName;

  UserPurchasedProductsPage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserPurchaseController(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text("$userName's Purchases",style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.purchasedProducts.isEmpty) {
          return const Center(child: Text("No purchased products found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.purchasedProducts.length,
          itemBuilder: (context, index) {
            final product = controller.purchasedProducts[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Image.asset(
                  AppImages.prduct1,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
                title: Text(product["productName"]),
                subtitle: Text(
                  "₹${product["price"]}\nDate: ${product["date"]}",
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      }),
    );
  }
}
