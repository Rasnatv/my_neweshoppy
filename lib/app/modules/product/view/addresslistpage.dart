
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

  // ── Design tokens ───────────────────────────────────────────────────────────
  static const Color _primary     = Colors.teal;
  static const Color _primarySoft = Color(0xFFEEF2FF);
  static const Color _surface     = Color(0xFFF5F5F8);
  static const Color _card        = Colors.white;
  static const Color _textPrimary = Color(0xFF0F0F10);
  static const Color _textSec     = Color(0xFF5F6070);
  static const Color _textTertiary= Color(0xFF9EA0B0);
  static const Color _border      = Color(0xFFECECF0);

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: _surface,
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }
          return RefreshIndicator(
            color: _primary,
            backgroundColor: Colors.white,
            onRefresh: controller.fetchAddresses,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
              children: [
                _buildAddNewButton(),
                const SizedBox(height: 16),
                if (controller.addressList.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildSectionLabel('Saved Addresses'),
                  const SizedBox(height: 10),
                  ...controller.addressList
                      .map((addr) => _buildAddressCard(addr))
                      .toList(),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: const Text(
        'Select Address',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      actions: [
        Obx(() => Padding(
          padding: const EdgeInsets.only(right: 18),
          child: controller.addressList.isEmpty
              ? const SizedBox.shrink()
              : Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${controller.addressList.length} saved',
              style: const TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )),
      ],
    );
  }

  // ── Section label ───────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ── Add New Address button ──────────────────────────────────────────────────
  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => NewAddAddressPage());
        controller.fetchAddresses();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _primary.withOpacity(0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          // Dashed border workaround via CustomPainter or use solid
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_rounded, color: _primary, size: 20),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Address',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Save a delivery location',
                  style: TextStyle(
                    color: _textTertiary,
                    fontSize: 11.5,
                  ),
                ),
              ],
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
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: _primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_off_outlined,
                size: 40, color: _primary),
          ),
          const SizedBox(height: 20),
          const Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add a new address to get started',
            style: TextStyle(fontSize: 13, color: _textTertiary),
          ),
        ],
      ),
    );
  }

  // ── Address card ────────────────────────────────────────────────────────────
  Widget _buildAddressCard(AddressListModel addr) {
    return Obx(() {
      final bool isSelected =
          controller.selectedAddressId.value == addr.addressId;

      return GestureDetector(
        onTap: () => controller.selectAddress(addr.addressId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _primary : _border,
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: _primary.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Card body ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected ? _primarySoft : const Color(0xFFF3F3F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: isSelected ? _primary : _textTertiary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Text info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  addr.fullName,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: _textPrimary,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          // Address
                          Text(
                            addr.fullAddress,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _textSec,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Phone
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  size: 13, color: _textTertiary),
                              const SizedBox(width: 5),
                              Text(
                                addr.phoneNumber,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: _textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Radio button
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? _primary : _border,
                            width: isSelected ? 2 : 1.5,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: _primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Action strip (visible only when selected) ──────────────
              if (isSelected) ...[
                const Divider(height: 1, color: _border),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Edit button
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await Get.to(
                                  () => EditAddressPage(addressId: addr.addressId));
                          if (result == true) {
                            await controller.fetchAddresses();
                          }
                        },
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primary,
                          side: const BorderSide(
                              color: Color(0xFFD0CFFF), width: 1.5),
                          backgroundColor: _primarySoft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Deliver button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => OrderConfirmationPage(
                              addressId: addr.addressId,
                            ));
                          },
                          icon: const Icon(Icons.check_circle_outline_rounded,
                              size: 16),
                          label: const Text('Deliver here'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}