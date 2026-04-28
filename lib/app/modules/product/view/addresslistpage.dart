
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/addresslistmodel.dart';
import '../controller/address_listcontroller.dart';
import 'address_newadding.dart';
import 'address_updatepage.dart';
import 'orderconfirmationpage.dart';

class AddressListPage extends StatelessWidget {
  AddressListPage({super.key});

  final AddressListController controller = Get.put(AddressListController());

  static Color primary = AppColors.kPrimary;
  static const Color bg = Color(0xFFF0F0F5);
  static const Color textDark = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Select Address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primary));
        }
        return RefreshIndicator(
          color: primary,
          onRefresh: controller.fetchAddresses,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAddNewButton(),
              const SizedBox(height: 4),
              if (controller.addressList.isEmpty)
                _buildEmptyState()
              else
                ...controller.addressList
                    .map((addr) => _buildAddressCard(addr))
                    .toList(),
            ],
          ),
        );
      }),
    ));
  }

  // ── Add New Address button ──────────────────────────────────────────────────
  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => NewAddAddressPage());
        controller.fetchAddresses();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primary.withOpacity(0.4), width: 1.4),
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: primary, size: 20),
            const SizedBox(width: 10),
            Text(
              'ADD NEW ADDRESS',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_off_outlined,
                size: 44, color: Color(0xFFCCCCCC)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add a new address to continue',
            style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
          ),
        ],
      ),
    );
  }

  // ── Address card ────────────────────────────────────────────────────────────
  Widget _buildAddressCard(AddressListModel addr) {
    return Obx(() {
      final isSelected =
          controller.selectedAddressId.value == addr.addressId;

      return GestureDetector(
        onTap: () => controller.selectAddress(addr.addressId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xF0FFFFFF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primary : const Color(0xFFE5E5E5),
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? primary.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        addr.fullName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ),
                    Radio<int>(
                      value: addr.addressId,
                      groupValue: controller.selectedAddressId.value,
                      onChanged: (v) =>
                          controller.selectAddress(v ?? addr.addressId),
                      activeColor: primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  addr.fullAddress,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF444444),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 13, color: Color(0xFF888888)),
                    const SizedBox(width: 4),
                    Text(
                      addr.phoneNumber,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF555555)),
                    ),
                  ],
                ),
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 10),

                  // ── EDIT ──────────────────────────────────────────────────
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final result = await Get.to(
                                  () => EditAddressPage(
                                  addressId: addr.addressId));
                          if (result == true) {
                            await controller.fetchAddresses();
                          }
                        },
                        icon: Icon(Icons.edit_outlined,
                            size: 15, color: primary),
                        label: Text(
                          'EDIT',
                          style: TextStyle(
                            color: primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── DELIVER TO THIS ADDRESS ──────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // ✅ Pass only addressId — no AddressListModel needed
                        Get.to(() => OrderConfirmationPage(
                          addressId: addr.addressId,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Deliver to this Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}