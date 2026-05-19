import 'package:entenaadu/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/shared_uihelpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/adminretaurant_menumodel.dart';
import '../controller/restaurant_menuaddingcontroller.dart';
import 'inputformaters.dart';
import 'mealclricons.dart';


class MealTypeCardzz extends StatelessWidget {
  final MealType mealType;
  const MealTypeCardzz({super.key, required this.mealType});

  RestaurantmenuController get c => Get.find();
  Color get _color => mealColorszz(mealType);
  IconData get _icon => mealIconszz(mealType);

  @override
  Widget build(BuildContext context) {
    final menu = c.getMealMenu(mealType);
    final isExpanded = c.expandedCards[mealType]!;
    final pickedImage = c.pickedImages[mealType]!;

    return Obx(() {
      final expanded = isExpanded.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: expanded
                ? _color.withOpacity(0.4)
                : Colors.grey.shade200,
            width: expanded ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: expanded
                  ? _color.withOpacity(0.06)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          InkWell(
            onTap: () => c.toggleCard(mealType),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _color,
                        Color.lerp(_color, Colors.black, 0.25)!
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: _color.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Icon(_icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mealType.name.capitalizeFirst!,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _color)),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                        '${menu.foodItems.length} item${menu.foodItems.length != 1 ? 's' : ''} on menu',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500),
                      )),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.expand_more_rounded,
                        color: _color, size: 20),
                  ),
                ),
              ]),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: _color.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New Item label
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(_icon, color: _color, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text('New Item',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _color,
                            letterSpacing: 0.5)),
                  ]),
                  const SizedBox(height: 14),
                  modernTextFieldzz(
                    controller: c.foodNameCtrls[mealType]!,
                    label: 'Food Name',
                    hint: 'e.g. Masala Dosa',
                    icon: Icons.fastfood_outlined,
                  ),
                  const SizedBox(height: 12),
                  modernTextFieldzz(
                    controller: c.foodPriceCtrls[mealType]!,
                    label: 'Price ₹',
                    hint: '0.00',
                    icon: Icons.currency_rupee_outlined,
                    type: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [PriceInputFormatterzz()],
                  ),
                  const SizedBox(height: 12),
                  modernTextFieldzz(
                    controller: c.descriptionCtrls[mealType]!,
                    label: 'Description (optional)',
                    hint: 'Short description of the dish',
                    icon: Icons.notes_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Obx(() => pickedImage.value != null
                      ? Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        pickedImage.value!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => pickedImage.value = null,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ])
                      : InkWell(
                    onTap: () => c.pickFoodImage(mealType),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _color.withOpacity(0.25),
                            width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              color: _color, size: 20),
                          const SizedBox(width: 10),
                          Text('Add Photo',
                              style: TextStyle(
                                  color: _color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  Obx(() => primaryBtnzz(
                    label: 'Add to Menu',
                    icon: Icons.add_rounded,
                    loading: c.isAddingMenuItem.value,
                    color: _color,
                    onPressed: c.isAddingMenuItem.value
                        ? null
                        : () => c.submitFoodItem(mealType),
                  )),

                  // ── On the Menu list ─────────────────────────────────────
                  Obx(() {
                    if (menu.foodItems.isEmpty) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.list_alt_outlined,
                                color: _color, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Text('On the Menu',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _color,
                                  letterSpacing: 0.5)),
                        ]),
                        const SizedBox(height: 12),
                        ...List.generate(menu.foodItems.length, (i) {
                          final food = menu.foodItems[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade200),
                            ),
                            child: Row(children: [
                              _buildFoodImagezz(food),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(food.name,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1D2E))),
                                    if (food.description.isNotEmpty)
                                      Text(food.description,
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                              Colors.grey.shade500)),
                                    const SizedBox(height: 3),
                                    Text(
                                        '₹ ${food.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1DA87A))),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () =>
                                      c.removeFoodItemLocally(
                                          mealType, food),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 18),
                                ),
                              ),
                            ]),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ]),
      );
    });
  }

  Widget _buildFoodImagezz(FoodItem food) {
    final placeholder = Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.fastfood_rounded, color: _color, size: 22),
    );
    if (food.imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(food.imageFile!,
            width: 52, height: 52, fit: BoxFit.cover),
      );
    }
    if (food.imageUrl != null && food.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          food.imageUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }
    return placeholder;
  }
}