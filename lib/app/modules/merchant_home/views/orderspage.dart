
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';

class MerchantOrdersPage extends StatelessWidget {
  MerchantOrdersPage({super.key});

  // Sample order data
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[
    {
      "id": "Order #1234",
      "status": "Delivered",
      "total": "₹899",
      "user": {
        "name": "John Doe",
        "phone": "9876543210",
        "address": "123, ABC Street, City"
      },
      "products": [
        {"name": "T-Shirt", "quantity": 2, "price": "₹299"},
        {"name": "Cap", "quantity": 1, "price": "₹301"},
      ],
      "salesPerson": null
    },
    {
      "id": "Order #1235",
      "status": "Pending",
      "total": "₹450",
      "user": {
        "name": "Jane Smith",
        "phone": "9123456780",
        "address": "456, XYZ Avenue, City"
      },
      "products": [
        {"name": "Shoes", "quantity": 1, "price": "₹450"},
      ],
    },
  ].obs;

  // Sample sales persons list


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // back arrow color
        ),
        backgroundColor: AppColors.kPrimary,
        title: Text("Orders", style:AppTextStyle.rTextNunitoWhite16w600),
      ),
      body: Obx(() {
        if (orders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderCard(order);
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final user = order["user"];
    final products = order["products"] as List<dynamic>;
    String? assignedPerson = order["salesPerson"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightgreycontainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order["id"], style: AppTextStyle.rTextNunitoBlue16w600),
              Text(order["total"], style: AppTextStyle.rTextNunitoBlack16w600),
            ],
          ),
          const SizedBox(height: 8),

          // User Details
          Text("Customer: ${user["name"]}",
              style: AppTextStyle.rTextNunitoBlack14w500),
          Text("Phone: ${user["phone"]}",
              style: AppTextStyle.rTextNunitoBlack14w500),
          Text("Address: ${user["address"]}",
              style: AppTextStyle.rTextNunitoBlack14w500),
          const SizedBox(height: 8),

          // Products Ordered
          Text("Products:", style: AppTextStyle.rTextNunitoBlack16w600),
          SizedBox(height: 10,),
          ...products.map((p) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "${p["name"]} x${p["quantity"]} - ${p["price"]}",
                  style: AppTextStyle.rTextNunitoBlack14w500,
                ),
              )),
          const SizedBox(height: 8),

            ],
          ),);
  }
}
