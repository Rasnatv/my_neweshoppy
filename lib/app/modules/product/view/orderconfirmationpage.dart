
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/user_orderconfirmationmodel.dart';
import '../../landingview/controller/landing_controller.dart';
import '../../landingview/view/landing_screen.dart';
import '../controller/order_confirmation_controller.dart';


class OrderConfirmationPage extends StatelessWidget {
  final int addressId; // ✅ direct constructor param
  const OrderConfirmationPage({super.key, required this.addressId});

  @override
  Widget build(BuildContext context) {
    // ✅ Pass addressId directly into controller
    final controller = Get.put(OrderConfirmationController(addressId: addressId));


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
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.kPrimary),
          );
        }

        if (controller.hasError.value) {
          return _buildErrorState(controller);
        }

        final preview = controller.orderPreview.value!;
        return _buildBody(preview, controller);
      }),
    );
  }

  // ── Error State ─────────────────────────────────────────────────────────────
  Widget _buildErrorState(OrderConfirmationController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 60, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final addressId = Get.arguments?['address_id'];
                if (addressId != null) controller.fetchOrderPreview(addressId);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor:  AppColors.kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main Body ────────────────────────────────────────────────────────────────
  Widget _buildBody(OrderConfirmationModel preview, OrderConfirmationController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSuccessBanner(),
          const SizedBox(height: 20),
          _sectionTitle('Delivery Address'),
          const SizedBox(height: 10),
          _buildAddressCard(preview.address),
          const SizedBox(height: 16),
          _sectionTitle('Order Items'),
          const SizedBox(height: 10),
          _buildItemsList(preview.items),
          const SizedBox(height: 16),
          _buildTotalCard(preview.totalAmount),
          const SizedBox(height: 16),
          _buildMerchantInfo(),
          const SizedBox(height: 28),
          _buildConfirmButton(controller),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Success Banner ──────────────────────────────────────────────────────────
  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18), color: AppColors.kPrimary,

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
            color: AppColors.kPrimary,
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
  Widget _buildAddressCard(AddressPreview address) {
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
                  color: AppColors.kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_outline_rounded, color:AppColors.kPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  address.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF6EE7B7), width: 1),
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
          _infoRow(Icons.location_on_outlined, address.address, const Color(0xFF6366F1)),
          const SizedBox(height: 10),
          _infoRow(Icons.phone_outlined, address.phone, const Color(0xFF3B82F6)),
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

  // ── Order Items List ─────────────────────────────────────────────────────────
  Widget _buildItemsList(List<OrderItem> items) {
    return Container(
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFF0F0F0)),
        itemBuilder: (context, index) => _buildItemTile(items[index]),
      ),
    );
  }

  Widget _buildItemTile(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.grey, size: 26),
              ),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                width: 64,
                height: 64,
                color: const Color(0xFFF0F0F0),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.kPrimary,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${item.price.toStringAsFixed(2)}  ×  ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${(item.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.kPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Total Card ──────────────────────────────────────────────────────────────
  Widget _buildTotalCard(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.kPrimary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kPrimary.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          Text(
            '₹${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.kPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
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

//   // ── Confirm Order Button ────────────────────────────────────────────────────
//   Widget _buildConfirmButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           Get.snackbar(
//             '',
//             '',
//             titleText: const Row(
//               children: [
//                 Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   'Order Confirmed!',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                   ),
//                 ),
//               ],
//             ),
//             messageText: const Text(
//               'Your order has been placed successfully.',
//               style: TextStyle(color: Colors.white70, fontSize: 12.5),
//             ),
//             backgroundColor: const Color(0xFF059669),
//             snackPosition: SnackPosition.TOP,
//             borderRadius: 12,
//             margin: const EdgeInsets.all(14),
//             duration: const Duration(seconds: 3),
//             icon: const SizedBox.shrink(),
//           );
//
//           Future.delayed(const Duration(seconds: 2), () {
//             Get.offAll(
//                   () => LandingView(),
//               arguments: LandingItem.MyOrders,
//             );
//           });
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.kPrimary,
//           shadowColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         ),
//         child: Ink(
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 21),
//                 SizedBox(width: 8),
//                 Text(
//                   'Confirm Order',
//                   style: TextStyle(
//                     fontSize: 15.5,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     letterSpacing: 0.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
  Widget _buildConfirmButton(OrderConfirmationController controller) {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
          controller.isConfirming.value ? null : controller.confirmOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimary,
            disabledBackgroundColor: AppColors.kPrimary.withOpacity(0.6),
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: controller.isConfirming.value
                ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Placing Order...',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            )
                : const Row(
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
  }}