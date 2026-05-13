
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../widgets/delete_widget.dart';
import '../../manage_merchants/controller/admin_merchantdetailedcontroller.dart';
import '../../manage_merchants/controller/mervchant_approvalstatus_controller.dart';
import '../../manage_merchants/view/admin_merchantdetailpage.dart';
import '../../manage_merchants/view/adminaddmerchants.dart';

class AdminMerchantHomePageUI extends StatelessWidget {
  AdminMerchantHomePageUI({super.key});

  final AdminMerchantController controller = Get.put(AdminMerchantController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.kPrimary,
          elevation: 0,
          title: const Text(
            'All Merchants',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          actions: [
            // ── Excel Download Button ──────────────────────────────
            Obx(() {
              if (controller.merchants.isEmpty) return const SizedBox.shrink();
              return controller.isExcelGenerating.value
                  ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                ),
              )
                  : IconButton(
                icon: const Icon(
                  Icons.table_chart_rounded,
                  color: Colors.white,
                ),
                tooltip: 'Download Excel',
                onPressed: controller.downloadMerchantsExcel,
              );
            }),

            // ── Add Merchant Button ────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: () => Get.to(() => AdminAddMerchantPage()),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: Text(
                  'Add Merchant',
                  style: AppTextStyle.rTextNunitoWhite16w600.copyWith(
                    fontSize: 13,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.kPrimary),
            );
          }

          if (controller.merchants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.store_outlined,
                        size: 44,
                        color: AppColors.kPrimary.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'No merchants found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.kPrimary,
            onRefresh: controller.fetchMerchants,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.merchants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final merchant = controller.merchants[index];
                return _buildCard(merchant);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard(dynamic merchant) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.to(
              () => AdminMerchantDetailPage(merchantId: merchant.id),
          arguments: merchant.id,
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Icon avatar ────────────────────────────────────
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.storefront_rounded,
                    color: AppColors.kPrimary, size: 26),
              ),
              const SizedBox(width: 14),

              // ── Shop name + email ──────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant.shopName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            size: 13, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            merchant.email,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Delete + Arrow ─────────────────────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      DeleteConfirmDialog.show(
                        context: Get.context!,
                        title: "Delete Merchant",
                        message:
                        "Are you sure you want to delete this merchant?",
                        onConfirm: () {
                          controller.deleteMerchant(merchant.id);
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}