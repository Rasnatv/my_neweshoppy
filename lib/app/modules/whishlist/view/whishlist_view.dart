import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../common/style/app_text_style.dart';
import '../../product/controller/whishlistcontroller.dart';
import '../../product/widgtet/productcard.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final WishlistController controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          title:  Text("My Wishlist",style: AppTextStyle.rTextNunitoWhite17w700)
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlist.isEmpty) {
          return const Center(child: Text("No items in wishlist"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final item = controller.wishlist[index];
            return ProductCard(
              productId: item.productId,
              productName: item.name,
              imageUrl: item.image,
              price: item.price,
            );
          },
        );
      }),
    );
  }
}
