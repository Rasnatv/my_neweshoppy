
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../common/style/app_colors.dart';
import '../../controller/add_advertismentcontroller.dart';
import 'admin_addavertisment.dart';

class AdminAdvertisementPage extends StatelessWidget {
  AdminAdvertisementPage({super.key});
  final AdminAdvertisementController controller = Get.put(AdminAdvertisementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advertisements",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => AdminAddAdvertisementPage());
          controller.fetchAdvertisements(); // refresh after adding
        },
        backgroundColor: AppColors.kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.advertisements.isEmpty) {
          return const Center(
            child: Text(
              "No advertisements added yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAdvertisements,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.advertisements.length,
            itemBuilder: (context, index) {
              final ad = controller.advertisements[index];

              return Dismissible(
                key: Key(ad['id']),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text("Are you sure you want to delete this advertisement?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  controller.deleteAdvertisement(index);
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: ad["banner"] != null && ad["banner"].toString().isNotEmpty
                            ? Image.network(
                          ad["banner"],
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 50, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ad["name"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4)
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                bool? confirmed = await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text("Are you sure you want to delete this advertisement?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  controller.deleteAdvertisement(index);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
