

import 'package:entenaadu/app/data/models/user_myordersmodel.dart';
import 'package:entenaadu/app/modules/myoders/controller/my_orderscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../../product/view/prodductdetailscreen.dart';
import '../../userhome/view/user_offerproductdetail.dart';

class MyOrdersView extends StatelessWidget {
  MyOrdersView({super.key});

  static Color get primary => AppColors.kPrimary;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrdersController());

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: primary,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0.5,
          shadowColor: Colors.black12,
          title: const Text(
            'My Orders',
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
          if (controller.hasError.value) {
            return _buildErrorState(controller);
          }
          if (controller.orders.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchMyOrders,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(controller.orders[index], controller);
              },
            ),
          );
        }),
      ),
    );
  }

  // ── Order Card ───────────────────────────────────────────────────────────────
  Widget _buildOrderCard(MyOrdersModel order, MyOrdersController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderId,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 11,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.formatDate(order.orderDate),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Items List ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: order.items
                  .map((item) => _buildItemRow(item, controller))
                  .toList(),
            ),
          ),

          // ── Footer ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
              border: Border(
                top: BorderSide(color: Color(0xFFF0F0F0)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Total',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${controller.formatPrice(order.totalAmount)}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Item Row ─────────────────────────────────────────────────────────────────
  Widget _buildItemRow(OrderProduct item, MyOrdersController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // ── Same pattern as CartScreen ──
          // type == 1  →  offer product detail
          // type == 0  →  normal product detail
          if (item.type == 1) {
            Get.to(() => UserOfferProductDetailScreen(
              offerProductId: item.productId,
              preSelectedVariantId: item.variant?.variantId,
            ));
          } else {
            Get.to(() => ProductDetailPage(
              productId: item.productId,
              preSelectedVariantId: item.variant?.variantId,
            ));
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.displayImage,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                  width: 56,
                  height: 56,
                  color: const Color(0xFFF0F0F0),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  // Variant attributes as badge chips
                  if (item.variant != null &&
                      item.variant!.attributes.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: item.variant!.attributes.entries.map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: primary.withOpacity(0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '${_cap(e.key)}: ${_cap(e.value)}',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 5),

                  // Price line
                  Row(
                    children: [
                      if (item.variant != null &&
                          item.variant!.finalPrice < item.variant!.price) ...[
                        Text(
                          '₹${controller.formatPrice(item.variant!.price)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFAAAAAA),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        '₹${controller.formatPrice(item.price)}  ×  ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Item total
            Text(
              '₹${controller.formatPrice(item.total)}',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  // ── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 46,
                color: primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You haven\'t placed any orders yet.\nStart shopping to see your orders here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade500,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error State ──────────────────────────────────────────────────────────────
  Widget _buildErrorState(MyOrdersController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 60, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.fetchMyOrders,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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
}
