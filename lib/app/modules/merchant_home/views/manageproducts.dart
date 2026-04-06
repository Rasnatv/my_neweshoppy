
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../common/style/app_text_style.dart';
import '../../merchant_home/controller/manageproduct_controller.dart';
import 'merchnatproductediting.dart';

class ManageProductsPage extends StatelessWidget {
  final ManageproductController controller = Get.put(ManageproductController());

  ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleSpacing: 0,
      title: const Text(
        'Manage Products',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      backgroundColor: const Color(0xFF00796B),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(height: 0.5, color: Colors.white.withOpacity(0.2)),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
          onPressed: () => controller.refreshProducts(),
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) return _buildLoadingState();
    if (controller.errorMessage.value.isNotEmpty) return _buildErrorState();
    if (controller.products.isEmpty) return _buildEmptyState();
    return _buildProductList();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: Color(0xFF00796B),
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF78909C),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 36, color: Color(0xFFE53935)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load products',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(fontSize: 13, color: Color(0xFF90A4AE), height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.fetchProducts(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Retry', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.inventory_2_outlined, size: 44, color: Color(0xFF00796B)),
          ),
          const SizedBox(height: 24),
          const Text('No products yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
          const SizedBox(height: 8),
          const Text('Your product list will appear here', style: TextStyle(fontSize: 14, color: Color(0xFF90A4AE))),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return RefreshIndicator(
      onRefresh: controller.refreshProducts,
      color: const Color(0xFF00796B),
      strokeWidth: 2.5,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildSummaryHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = controller.products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ProductCard(product: product, index: index, controller: controller),
                  );
                },
                childCount: controller.products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            '${controller.products.length} Products',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF546E7A),
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.sort_rounded, size: 14, color: Color(0xFF546E7A)),
                SizedBox(width: 4),
                Text('Latest', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF546E7A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;
  final int index;
  final ManageproductController controller;

  const _ProductCard({required this.product, required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main product row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                _buildProductImage(),
                const SizedBox(width: 14),
                // Product info
                Expanded(child: _buildProductInfo()),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

          // Action bar
          _buildActionBar(context),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF5F5F5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFFF0F4F3),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF00796B)),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFFF5F5F5),
                child: const Icon(Icons.image_not_supported_outlined, size: 28, color: Color(0xFFBDBDBD)),
              ),
            ),
          ),
        ),
        // In stock dot
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF43A047),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            height: 1.35,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Price row
        Row(
          children: [
            const Text('₹', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00796B))),
            Text(
              product.price,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF00796B)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Chips row
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            _buildChip(
              label: 'In Stock',
              bgColor: const Color(0xFFE8F5E9),
              textColor: const Color(0xFF2E7D32),
            ),
            if (product.variants.length > 1)
              _buildChip(
                label: '${product.variants.length} variants',
                bgColor: const Color(0xFFE3F2FD),
                textColor: const Color(0xFF1565C0),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip({required String label, required Color bgColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Edit button
          Expanded(
            child: _OutlinedActionButton(
              label: 'Edit Product',
              icon: Icons.edit_outlined,
              color: const Color(0xFF1565C0),
              onTap: () async {
                if (product.id == null) {
                  _showSnackbar('Error', 'Product ID not found', isError: true);
                  return;
                }
                final result = await Get.to(
                      () => UpdateProductPage(),
                  arguments: {'product_id': product.id},
                );
                if (result == true) {
                  controller.refreshProducts();
                  _showSnackbar('Updated', 'Product updated successfully');
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          // Delete button - icon only
          GestureDetector(
            onTap: () => _confirmDelete(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFC62828)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Delete Product?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF212121)),
            ),
            const SizedBox(height: 8),
            Text(
              'This will permanently remove "${product.name}" from your store.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF78909C), height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF546E7A),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteProduct(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                      elevation: 0,
                    ),
                    child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: Icon(
        isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
        color: Colors.white,
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OutlinedActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
