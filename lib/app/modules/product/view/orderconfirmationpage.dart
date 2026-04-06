import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/addresslistmodel.dart';
import '../../landingview/controller/landing_controller.dart';
import '../../landingview/view/landing_screen.dart';

class OrderConfirmationPage extends StatelessWidget {
  final AddressListModel address;

  const OrderConfirmationPage({super.key, required this.address});

  static Color get primary => AppColors.kPrimary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Order Confirmation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSuccessBanner(),
            const SizedBox(height: 20),
            _sectionTitle('Delivery Address'),
            const SizedBox(height: 10),
            _buildAddressCard(),
            const SizedBox(height: 16),
            _buildMerchantInfo(),
            const SizedBox(height: 28),
            _buildConfirmButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Success Banner ──────────────────────────────────────────────────────────
  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Almost There!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your delivery details\nbefore confirming the order.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12.5,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Title ───────────────────────────────────────────────────────────
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ── Address Card ────────────────────────────────────────────────────────────
  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_outline_rounded,
                    color: primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  address.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6EE7B7),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'SELECTED',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF059669),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          _infoRow(
            Icons.location_on_outlined,
            address.fullAddress,
            const Color(0xFF6366F1),
          ),
          const SizedBox(height: 10),
          _infoRow(
            Icons.phone_outlined,
            address.phoneNumber,
            const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF444444),
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }

  }

  // ── Merchant Info ───────────────────────────────────────────────────────────
  Widget _buildMerchantInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF2563EB),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'The merchant will contact you soon regarding your order. '
                  'Delivery and further details will be handled directly by '
                  'the merchant. For more information, please contact the merchant.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1E40AF),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Confirm Order Button ────────────────────────────────────────────────────
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(

        onPressed: () {
          Get.snackbar(
            '',
            '',
            titleText: const Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            messageText: const Text(
              'Your order has been placed successfully.',
              style: TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
            backgroundColor: const Color(0xFF059669),
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(14),
            duration: const Duration(seconds: 3),
            icon: const SizedBox.shrink(),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Get.offAll(
                  () => LandingView(),
              arguments: LandingItem.MyOrders,
            );
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimary,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Ink(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    color: Colors.white, size: 21),
                SizedBox(width: 8),
                Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
