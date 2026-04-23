
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/cartcontroller.dart';
import '../../../data/models/cartmodel.dart';
import 'addresslistpage.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text("My Cart", style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Obx(() => cartController.cartItems.isNotEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${cartController.cartItems.length} items",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.kPrimary),
                const SizedBox(height: 16),
                Text(
                  "Loading your cart...",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          );
        }
        if (cartController.cartItems.isEmpty) {
          return _buildEmptyCart();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return _CartItemCard(
                    item: item,
                    cartController: cartController,
                  );
                },
              ),
            ),
            _buildCheckoutPanel(),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Looks like you haven't added anything yet",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.storefront_outlined, size: 18),
            label: const Text("Browse Products"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                // Calculate total savings from offer items
                final totalSavings = cartController.cartItems.fold(
                  0.0,
                      (sum, item) =>
                  sum +
                      ((item.price - item.finalPrice) * item.quantity),
                );

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1, thickness: 1),
                    ),
                    _summaryRow(
                      label: "Total Amount",
                      value:
                      "₹${cartController.total.value.toStringAsFixed(0)}",
                      labelStyle: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                      valueStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.kPrimary),
                    )
               ] );
              }),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (cartController.cartItems.isEmpty) {
                      Get.snackbar(
                        "Cart Empty",
                        "Add products first",
                        backgroundColor: Colors.red.shade400,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                      return;
                    }
                    Get.to(()=> AddressListPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Proceed to Checkout",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Cart Item Card
// ─────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartController cartController;

  const _CartItemCard({
    Key? key,
    required this.item,
    required this.cartController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text("Remove Item",
                style: TextStyle(fontWeight: FontWeight.w700)),
            content: Text(
              "Remove \"${item.productName}\" from your cart?",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text("Cancel",
                    style: TextStyle(color: Colors.grey.shade600)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Remove",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) =>
          cartController.removeFromCart(int.parse(item.productId)),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text("Remove",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      child: Obx(() {
        final isRemoving = cartController.isItemRemoving(item.productId);
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isRemoving ? 0.5 : 1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Product Image ──
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 86,
                          height: 86,
                          color: Colors.grey.shade100,
                          child: item.productImage.isNotEmpty
                              ? Image.network(
                            item.productImage,
                            width: 86,
                            height: 86,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_outlined,
                              color: Colors.grey.shade400,
                              size: 36,
                            ),
                          )
                              : Icon(
                            Icons.image_outlined,
                            color: Colors.grey.shade400,
                            size: 36,
                          ),
                        ),
                      ),
                      // Offer badge on image
                      if (item.type == 1 && item.offerPercentage > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              "${item.offerPercentage.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // ── Details ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Delete button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: isRemoving
                                  ? null
                                  : () => cartController.removeFromCart(
                                  int.parse(item.productId)),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isRemoving
                                    ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.red.shade400,
                                  ),
                                )
                                    : Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // ── Price row ──
                        if (item.type == 1 && item.offerPercentage > 0) ...[
                          // Offer item: strikethrough original + green final
                          Row(
                            children: [
                              Text(
                                "₹${item.price.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "₹${item.finalPrice.toStringAsFixed(0)} each",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Normal item: plain price
                          Text(
                            "₹${item.finalPrice.toStringAsFixed(0)} each",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        // ── Stepper + Item total ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _QuantityStepper(
                              quantity: item.quantity,
                              stock: item.stock, // ✅ NEW
                              onDecrement: () => cartController.updateQuantity(
                                  int.parse(item.productId), "decrement"),
                              onIncrement: () => cartController.updateQuantity(
                                  int.parse(item.productId), "increment"),
                            ),
                            const Spacer(),
                            // Item total
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${item.itemTotal.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                if (item.type == 1 &&
                                    item.offerPercentage > 0)
                                  Text(
                                    "saved ₹${((item.price - item.finalPrice) * item.quantity).toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
// Quantity Stepper
// ─────────────────────────────────────────
// class _QuantityStepper extends StatelessWidget {
//   final int quantity;
//   final VoidCallback onDecrement;
//   final VoidCallback onIncrement;
//
//   const _QuantityStepper({
//     Key? key,
//     required this.quantity,
//     required this.onDecrement,
//     required this.onIncrement,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 36,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7F8FA),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           GestureDetector(
//             onTap: onDecrement,
//             child: Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: Icon(
//                 Icons.remove_rounded,
//                 size: 18,
//                 color: quantity <= 1
//                     ? Colors.grey.shade400
//                     : Colors.grey.shade700,
//               ),
//             ),
//           ),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 150),
//             transitionBuilder: (child, anim) =>
//                 ScaleTransition(scale: anim, child: child),
//             child: SizedBox(
//               key: ValueKey(quantity),
//               width: 32,
//               child: Center(
//                 child: Text(
//                   "$quantity",
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1A2E),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: onIncrement,
//             child: Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: Icon(
//                 Icons.add_rounded,
//                 size: 18,
//                 color: AppColors.kPrimary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final int stock; // ✅ NEW
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    Key? key,
    required this.quantity,
    required this.stock, // ✅ NEW
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool atMax = quantity >= stock; // ✅ NEW

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Decrement ──
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 18,
                color: quantity <= 1
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
              ),
            ),
          ),
          // ── Count ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: SizedBox(
              key: ValueKey(quantity),
              width: 32,
              child: Center(
                child: Text(
                  "$quantity",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
          ),
          // ── Increment ── ✅ greyed out at stock limit
          GestureDetector(
            onTap: atMax ? null : onIncrement,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 18,
                color: atMax ? Colors.grey.shade300 : AppColors.kPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}