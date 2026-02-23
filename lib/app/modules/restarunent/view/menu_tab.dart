import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/restaruantcartmodel.dart';
import '../controller/menu_controller.dart';
import '../controller/restaurantcartcontroller.dart';


class RestaurantMenuTab extends StatelessWidget {
  final String restaurantId;

  RestaurantMenuTab({super.key, required this.restaurantId});

  final Restaurantcartcontroller cartController =
  Get.put(Restaurantcartcontroller());

  @override
  Widget build(BuildContext context) {
    // Use unique tag per restaurant to avoid controller conflicts
    final menuController = Get.put(
      RestaurantMenuController(),
      tag: 'menu_$restaurantId',
    );

    // Fetch on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (menuController.menuItems.isEmpty && !menuController.isLoading.value) {
        menuController.init(restaurantId);
      }
    });

    return Obx(() {
      return Column(
        children: [
          // ──────────── MEAL TYPE CHIPS ────────────
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: menuController.mealTypes.length,
              itemBuilder: (context, index) {
                final type = menuController.mealTypes[index];
                final isSelected =
                    menuController.selectedMealType.value == type['value'];

                return GestureDetector(
                  onTap: () =>
                      menuController.changeMealType(restaurantId, type['value']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                        colors: [Colors.teal, Color(0xFF00897B)],
                      )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                        isSelected ? Colors.teal : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: Text(
                      type['label']!,
                      style: TextStyle(
                        color:
                        isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ──────────── MENU LIST ────────────
          Expanded(
            child: menuController.isLoading.value
                ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
                : menuController.menuItems.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No items available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuController.menuItems.length,
              itemBuilder: (context, index) {
                final item = menuController.menuItems[index];
                return _MenuItemCard(
                  item: item,
                  onAdd: () {
                    cartController.addToCart(
                      RestaurantCartModel(
                        name: item.foodName,
                        price: double.tryParse(item.price)?.toInt() ?? 0,
                        qty: 1,
                        img: item.image,
                      ),
                    );
                    Get.snackbar(
                      "Added to Cart",
                      "${item.foodName} added successfully",
                      backgroundColor: Colors.teal,
                      colorText: Colors.white,
                      icon: const Icon(Icons.check_circle,
                          color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

// ──────────────────────────────────────────
//  MENU ITEM CARD
// ──────────────────────────────────────────
class _MenuItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onAdd;

  const _MenuItemCard({required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // Format price: remove trailing zeros e.g. "999.00" → "999"
    final priceDisplay = double.tryParse(item.price ?? '0')
        ?.toStringAsFixed(
        (double.tryParse(item.price ?? '0') ?? 0) % 1 == 0 ? 0 : 2) ??
        item.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // ── IMAGE ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                item.image,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.fastfood,
                      size: 40, color: Colors.grey.shade400),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: Colors.teal, strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),

            // ── DETAILS ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.shortDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "₹$priceDisplay",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── ADD BUTTON ──
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Material(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: const Text(
                      "ADD",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
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