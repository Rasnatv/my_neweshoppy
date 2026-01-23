import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../data/models/categoryshoplistmodel.dart';
import '../view/shopview.dart';
class Shopscard extends StatelessWidget {
  final ShoplistModel shop;
  const Shopscard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(shop.image),
      title: Text(shop.shopName),
      subtitle: Text(shop.location),
      onTap: () {
        // You can now pass merchantId to shop details
        Get.to(() => ShopDetailPage(merchantId: shop.merchantId));
      },
    );
  }
}
