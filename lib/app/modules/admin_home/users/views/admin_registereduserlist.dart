
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/admin_registeredusers_controller.dart';
import '../../shops/views/admin_userpurchasedprodcutpage.dart';

class AdminUserListPage extends StatelessWidget {
  AdminUserListPage({super.key});

  final AdminUserController controller = Get.put(AdminUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Registered Users", style: AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text("No registered users found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// USER NAME
                    Text(
                      user["name"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                    /// EMAIL
                    Row(
                      children: [
                        const Icon(Icons.email, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(user["email"]),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// PHONE
                    Row(
                      children: [
                        const Icon(Icons.phone_android, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(user["phone"]),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// ADDRESS
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text(user["address"])),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// REGISTERED DATE
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text("Registered: ${user["regDate"]}"),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// BUTTON: VIEW PURCHASED ITEMS
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => UserPurchasedProductsPage(
                              userId: user["id"],
                              userName: user["name"],
                            ));
                          },
                          icon: const Icon(Icons.shopping_basket),
                          label: const Text("Purchased Products"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// }
