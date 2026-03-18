
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/addresslistmodel.dart';
import '../controller/address_listcontroller.dart';
import 'address_newadding.dart';


class AddressListPage extends StatelessWidget {
  AddressListPage({super.key});

  final AddressListController controller = Get.put(AddressListController());

  static const Color primary = Color(0xFFB02399);
  static const Color bg = Color(0xFFF0F0F5);
  static const Color textDark = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'ADDRESS',
          style: TextStyle(
            color: textDark,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              }
              return RefreshIndicator(
                color: primary,
                onRefresh: controller.fetchAddresses,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ── Add New Address button ──────────────────────────────
                    _buildAddNewButton(),
                    const SizedBox(height: 4),

                    // ── Address cards ──────────────────────────────────────
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
          ),
        ],
      ),
    );
  }

  // ── Step indicator ──────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ['Cart', 'Address', 'Payment', 'Summary'];
    const currentStep = 1;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isCompleted = i < currentStep;
          final isCurrent = i == currentStep;
          final isLast = i == steps.length - 1;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted || isCurrent
                              ? primary
                              : const Color(0xFFDDDDDD),
                        ),
                      ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? primary
                            : isCurrent
                            ? Colors.white
                            : const Color(0xFFF0F0F0),
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? primary
                              : const Color(0xFFCCCCCC),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                            : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? primary
                                : const Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? primary
                              : const Color(0xFFDDDDDD),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                    isCurrent ? FontWeight.w700 : FontWeight.w400,
                    color: isCompleted || isCurrent
                        ? primary
                        : const Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Add New Address button ──────────────────────────────────────────────────
  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => NewAddAddressPage());
        // Refresh list after returning from add page
        controller.fetchAddresses();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primary.withOpacity(0.4), width: 1.4),
        ),
        child: const Row(
          children: [
            Icon(Icons.add_circle_outline, color: primary, size: 20),
            SizedBox(width: 10),
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
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.location_off_outlined,
              size: 64, color: Color(0xFFCCCCCC)),
          SizedBox(height: 16),
          Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
          SizedBox(height: 6),
          Text(
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
            color: isSelected ? const Color(0xFFFCF0FB) : Colors.white,
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
                // Name + Radio
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
                      materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Full address
                Text(
                  addr.fullAddress,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF444444),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 5),

                // Phone
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 13, color: Color(0xFF888888)),
                    const SizedBox(width: 4),
                    Text(
                      addr.phoneNumber,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),

                // Edit + Deliver button (only when selected)
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 10),

                  // Edit button
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          // Navigate to edit — pass address data
                          // await Get.to(() => EditAddressPage(address: addr));
                          // controller.fetchAddresses();
                        },
                        icon: const Icon(Icons.edit_outlined,
                            size: 15, color: primary),
                        label: const Text(
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

                  // Deliver to this address button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.deliverToSelected,
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