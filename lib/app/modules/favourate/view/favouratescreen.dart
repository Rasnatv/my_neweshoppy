import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/favourate controller.dart';


class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavouriteController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text("Favourites")),
      body: Obx(() {
        if (controller.favourites.isEmpty) {
          return const Center(child: Text("No favourites added"));
        }

        return ListView.builder(
          itemCount: controller.favourites.length,
          itemBuilder: (context, index) {
            final item = controller.favourites[index];

            return ListTile(
              leading: Image.asset(item['image'], width: 60),
              title: Text(item['name']),
              subtitle: Text("₹${item['price']}"),
              trailing: const Icon(Icons.favorite, color: Colors.red),
            );
          },
        );
      }),
    );
  }
}
