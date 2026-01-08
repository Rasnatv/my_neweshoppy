
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../manage_merchants/view/admin_merchantdetailpage.dart';
import '../../manage_merchants/view/adminaddmerchants.dart';

class AdminMerchantHomePageUI extends StatelessWidget {
  const AdminMerchantHomePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy merchant data for UI
    final merchants = [
      {
        "shopName": "Alice Store",
        "ownerName": "Alice Johnson",
        "email": "alice@example.com",
        "phone": "+91 9876543210",
        "state": "Kerala",
        "district": "Kasaragod",
        "location": "Kanhangad",
        "address": "123 Main Street, Kanhangad",
        "whatsapp": "+91 9876543210",
        "facebook": "facebook.com/alicestore",
        "instagram": "@alicestore",
        "website": "www.alicestore.com",
        "status": "Approved",
        "image": null
      },
      {
        "shopName": "Bob Shop",
        "ownerName": "Bob Smith",
        "email": "bob@example.com",
        "phone": "+91 9876543211",
        "state": "Kerala",
        "district": "Kasaragod",
        "location": "Bekal",
        "address": "456 Market Road, Bekal",
        "whatsapp": "+91 9876543211",
        "facebook": "facebook.com/bobshop",
        "instagram": "@bobshop",
        "website": "www.bobshop.com",
        "status": "Pending",
        "image": null
      },
      {
        "shopName": "Charlie Store",
        "ownerName": "Charlie Brown",
        "email": "charlie@example.com",
        "phone": "+91 9876543212",
        "state": "Kerala",
        "district": "Kasaragod",
        "location": "Manjeshwar",
        "address": "789 Shopping Complex, Manjeshwar",
        "whatsapp": "+91 9876543212",
        "facebook": "facebook.com/charliestore",
        "instagram": "@charliestore",
        "website": "www.charliestore.com",
        "status": "Rejected",
        "image": null
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("All Merchants", style: AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
        actions: [
          TextButton.icon(
            onPressed: () => Get.to( ()=>AdminAddMerchantPage  ()),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              "Add Merchant",
              style: AppTextStyle.rTextNunitoWhite16w600,
            ),
          )
        ],
      ),
      body: merchants.isEmpty
          ? const Center(
        child: Text(
          "No merchants registered yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: merchants.length,
        itemBuilder: (context, index) {
          final merchant = merchants[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: merchant["image"] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(merchant["image"]!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.storefront,
                  size: 30,
                  color: AppColors.kPrimary,
                ),
              ),
              title: Text(
                merchant["shopName"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    merchant["email"]!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    merchant["location"]!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(merchant["status"]!)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(merchant["status"]!),
                    width: 1,
                  ),
                ),
                child: Text(
                  merchant["status"]!,
                  style: TextStyle(
                    color: _getStatusColor(merchant["status"]!),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminMerchantDetailPageUI(
                      merchant: Map<String, String?>.from(merchant),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

