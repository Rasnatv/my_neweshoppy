import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/merchant_orderrecievedmodel.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../controller/merchant_orderscontroller.dart';

class MerchantOrdersView extends StatelessWidget {
  const MerchantOrdersView({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MerchantOrdersController());

    return NetworkAwareWrapper(
        child:Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Received Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        actions: [
          Obx(
                () => !controller.isLoading.value
                ? IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: controller.fetchMerchantOrders,
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.kPrimary));
        }
        if (controller.orders.isEmpty) {
          return _buildEmptyStateWithRetry(controller);
        }

        if (controller.orders.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          color: AppColors.kPrimary,
          onRefresh: controller.fetchMerchantOrders,
          child: CustomScrollView(
            slivers: [
              // ── Summary Header ─────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildSummaryHeader(controller),
              ),
              // ── Orders List ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildOrderCard(
                      controller.orders[index],
                      controller,
                    ),
                    childCount: controller.orders.length,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ));
  }

  // ── Summary Header ────────────────────────────────────────────────────────
  Widget _buildSummaryHeader(MerchantOrdersController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.80)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _statBox(
            icon: Icons.receipt_long_rounded,
            label: 'Total Orders',
            value: '${controller.totalOrdersCount}',
          ),
          Container(
            width: 1,
            height: 48,
            color: Colors.white.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          _statBox(
            icon: Icons.currency_rupee_rounded,
            label: 'Total Revenue',
            value: '₹${controller.totalRevenue.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }

  Widget _statBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Order Card ────────────────────────────────────────────────────────────
  Widget _buildOrderCard(
      MerchantOrderModel order,
      MerchantOrdersController controller,
      ) {
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
          // ── Card Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:AppColors.kPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    color:AppColors.kPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderId}',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.formatDate(order.orderDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // New badge

              ],
            ),
          ),

          // ── Products ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              children: [
                ...order.products.asMap().entries.map((entry) {
                  final isLast = entry.key == order.products.length - 1;
                  return Column(
                    children: [
                      _buildProductRow(entry.value),
                      if (!isLast) ...[
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),

          // ── Delivery Address ───────────────────────────────────────
          _buildAddressSection(order.address),

          // ── Footer ────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 0),
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
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 15,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${order.products.length} ${order.products.length == 1 ? 'product' : 'products'}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Order Total  ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.kPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Address Section ───────────────────────────────────────────────────────
  Widget _buildAddressSection(MerchantOrderAddress address) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1879AE),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.phone_rounded,
                        size: 11, color: Colors.grey.shade500),
                    const SizedBox(width: 3),
                    Text(
                      address.phone,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  address.address,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Product Row ───────────────────────────────────────────────────────────
  Widget _buildProductRow(MerchantOrderProduct product) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            product.image,
            width: 58,
            height: 58,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 58,
              height: 58,
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
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color:AppColors.kPrimary,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '₹${product.price.toStringAsFixed(2)}  ×  ${product.quantity}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          '₹${product.total.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.kPrimary,
          ),
        ),
      ],
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
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
                color:AppColors.kPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 46,
                color: AppColors.kPrimary.withOpacity(0.5),
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
              'You have not received any orders yet.\nThey will appear here once customers order.',
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
  Widget _buildEmptyStateWithRetry(MerchantOrdersController controller) {
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
                color: AppColors.kPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 46,
                color: AppColors.kPrimary.withOpacity(0.5),
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
              'Pull down to refresh or try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.fetchMerchantOrders,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
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