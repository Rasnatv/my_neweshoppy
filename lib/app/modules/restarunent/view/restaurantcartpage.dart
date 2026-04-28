
import 'package:eshoppy/app/modules/restarunent/view/restaurantbookingpage.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/restaruantcartmodel.dart';
import '../controller/restaurantcartcontroller.dart';


class RestaurantCartPage extends StatelessWidget {
  final int restaurantId;
  const RestaurantCartPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final Restaurantcartcontroller cartController =
    Get.find<Restaurantcartcontroller>();

    // ✅ Always refresh when this page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.fetchCart();
    });

    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5151),
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        title: const Text(
          'Purchased items',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => cartController.fetchCart(),
            icon: const Icon(Icons.refresh, color: Colors.teal),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        final items = cartController.itemsForRestaurant(restaurantId);

        if (items.isEmpty) {
          return _EmptyCartView();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _CartItemCard(
                    item: item,
                    cartController: cartController,
                  );
                },
              ),
            ),
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        final items = cartController.itemsForRestaurant(restaurantId);
        if (items.isEmpty) return const SizedBox();
        final subTotal = cartController.grandTotalForRestaurant(restaurantId);
        return _PlaceOrderBar(
          subTotal: subTotal,
          cartController: cartController,
          restaurantId: restaurantId,
        );
      }),
    ));
  }
}


class _CartItemCard extends StatelessWidget {
  final RestaurantCartModel item;
  final Restaurantcartcontroller cartController;

  const _CartItemCard({required this.item, required this.cartController});

  @override
  Widget build(BuildContext context) {
    final priceDisplay = item.price % 1 == 0
        ? item.price.toInt().toString()
        : item.price.toStringAsFixed(2);
    final totalDisplay = item.totalPrice % 1 == 0
        ? item.totalPrice.toInt().toString()
        : item.totalPrice.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.fastfood,
                      size: 36, color: Colors.grey.shade400),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: Colors.teal, strokeWidth: 2),
                    ),
                  );
                },
              )
                  : Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: Icon(Icons.fastfood,
                    size: 36, color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹$priceDisplay / item',
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹$totalDisplay',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              final isUpdating = cartController.isUpdating.value;
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: isUpdating
                          ? null
                          : () => cartController.updateQuantity(
                          item.menuId, 'decrement'),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Icon(
                          item.quantity == 1
                              ? Icons.delete_outline
                              : Icons.remove,
                          size: 16,
                          color: item.quantity == 1
                              ? Colors.red.shade400
                              : Colors.teal,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      alignment: Alignment.center,
                      child: isUpdating
                          ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            color: Colors.teal, strokeWidth: 2),
                      )
                          : Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: isUpdating
                          ? null
                          : () => cartController.updateQuantity(
                          item.menuId, 'increment'),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Icon(Icons.add,
                            size: 16, color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  final double subTotal;
  final Restaurantcartcontroller cartController;
  final int restaurantId;

  const _PlaceOrderBar({
    required this.subTotal,
    required this.cartController,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    final totalDisplay = subTotal % 1 == 0
        ? subTotal.toInt().toString()
        : subTotal.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '₹$totalDisplay',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5151),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: const Color(0xFF0F5151),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.to(() => RestaurantBookingPage(),
                        arguments: {"restaurant_id": restaurantId});
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Book Slot',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from the menu to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1F1A),
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Get.back(),
            child: const Text(
              'Browse Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}