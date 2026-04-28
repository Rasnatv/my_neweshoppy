
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../manage_merchants/controller/mervchant_approvalstatus_controller.dart';
import '../../manage_merchants/view/admin_merchantdetailpage.dart';
import '../../manage_merchants/view/adminaddmerchants.dart';


class AdminMerchantHomePageUI extends StatelessWidget {
  AdminMerchantHomePageUI({super.key});

  final AdminMerchantController controller =
  Get.put(AdminMerchantController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "All Merchants",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        backgroundColor: AppColors.kPrimary,
        actions: [
          TextButton.icon(
            onPressed: () => Get.to(() => AdminAddMerchantPage()),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              "Add Merchant",
              style: AppTextStyle.rTextNunitoWhite16w600,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.merchants.isEmpty) {
          return const Center(child: Text("No merchants found"));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMerchants,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.merchants.length,
            itemBuilder: (_, index) {
              final merchant = controller.merchants[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.storefront),
                  title: Text(merchant.shopName),
                  subtitle: Text(merchant.email),
                  onTap: () {
                    Get.to(
                          () => AdminMerchantDetailPageUI(
                        merchantId: merchant.id,
                      ),
                      arguments: merchant.id,
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    ));
  }

}
