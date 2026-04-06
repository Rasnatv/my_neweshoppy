
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/categoryshoplistmodel.dart';
import '../controller/company_controller.dart';
import '../widget/shopscard.dart';

class Categoriesofshoplist extends StatelessWidget {
  const Categoriesofshoplist({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyController controller =
    Get.find<CompanyController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Shops",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // ✅ Scaffold.body gives bounded height
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.shops.isEmpty) {
          return const Center(child: Text("No shops found"));
        }

        // ✅ ONLY scrollable widget on this screen
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.shops.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final ShoplistModel shop = controller.shops[index];
            return Shopscard(shop: shop);
          },
        );
      }),
    );
  }
}
