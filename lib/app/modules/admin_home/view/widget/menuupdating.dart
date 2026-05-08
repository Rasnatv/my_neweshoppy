import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
import '../../../../widgets/delete_widget.dart';
import '../restaurant/controller/restaurant_menuupdatecontroller.dart';
import 'menuuihelper.dart';

// ─── Menu Tab ─────────────────────────────────────────────────────────────────
class MenuTab extends StatelessWidget {
  final String tag;
  const MenuTab({super.key, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(children: [
      gradientStrip(),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Toggle
            Obx(() => modeToggle(
              leftLabel: 'Edit Items',
              rightLabel: 'Add New Item',
              leftIcon: Icons.edit_outlined,
              rightIcon: Icons.add_circle_outline_rounded,
              isAddMode: c.menuTabMode.value == TabMode.addNew,
              onToggle: (addMode) => c.menuTabMode.value =
              addMode ? TabMode.addNew : TabMode.existing,
            )),
            const SizedBox(height: 20),

            // Add New
            Obx(() {
              if (c.menuTabMode.value != TabMode.addNew)
                return const SizedBox();
              return buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeader(
                      icon: Icons.restaurant_menu_rounded,
                      title: 'Add Menu Items',
                      subtitle: 'Add food items by meal period',
                    ),
                    const SizedBox(height: 16),
                    ...['breakfast', 'lunch', 'dinner'].map(
                          (m) => AddMenuItemCard(mealType: m, tag: tag),
                    ),
                  ],
                ),
              );
            }),

            // Edit Existing
            Obx(() {
              if (c.menuTabMode.value != TabMode.existing)
                return const SizedBox();
              return _ExistingMenuItems(tag: tag, context: context);
            }),
          ],
        ),
      ),
    ]),
  );
}

// ─── Existing Menu Items ──────────────────────────────────────────────────────
class _ExistingMenuItems extends StatelessWidget {
  final String tag;
  final BuildContext context;
  const _ExistingMenuItems({required this.tag, required this.context});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext ctx) => Column(children: [
    // Edit form when item selected
    Obx(() {
      final sel = c.selectedMenuItem.value;
      if (sel == null) return const SizedBox();
      return Column(children: [
        MenuItemEditForm(tag: tag, item: sel),
        const SizedBox(height: 20),
      ]);
    }),

    // Menu items list
    buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader(
            icon: Icons.menu_book_rounded,
            title: 'Menu Items',
            subtitle: 'Tap an item to edit it',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (c.isLoadingMenuItems.value) return loadingIndicator();
            if (c.menuItems.isEmpty)
              return emptyState(
                icon: Icons.menu_book_outlined,
                message: 'No menu items found',
                sub: 'Switch to "Add New Item" to add one',
              );
            return Column(
              children: ['breakfast', 'lunch', 'dinner'].map((meal) {
                final items = c.getMenuItemsByMeal(meal);
                if (items.isEmpty) return const SizedBox();
                return MealSection(
                    mealType: meal, items: items, tag: tag,
                    context: context);
              }).toList(),
            );
          }),
        ],
      ),
    ),
  ]);
}

// ─── Menu Item Edit Form ──────────────────────────────────────────────────────
class MenuItemEditForm extends StatelessWidget {
  final String tag;
  final MenuItemModel item;
  const MenuItemEditForm({super.key, required this.tag, required this.item});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    final color = mealColor(item.mealType);
    return buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader(
            icon: Icons.edit_rounded,
            title: 'Edit Menu Item',
            subtitle: '${item.foodName} · ${item.mealType.capitalizeFirst}',
            iconColor: color,
          ),
          const SizedBox(height: 20),
          modernTextField(
            controller: c.menuNameCtrl,
            label: 'Food Name',
            hint: 'Enter food name',
            icon: Icons.fastfood_outlined,
          ),
          const SizedBox(height: 16),
          modernTextField(
            controller: c.menuPriceCtrl,
            label: 'Price (₹)',
            hint: 'e.g. 299.00',
            icon: Icons.currency_rupee_outlined,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          modernTextField(
            controller: c.menuDescCtrl,
            label: 'Description',
            hint: 'Short description of the dish',
            icon: Icons.notes_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          sectionHeader(icon: Icons.image_rounded, title: 'Food Image'),
          const SizedBox(height: 12),

          // Existing image
          if (item.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(item.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()),
            ),
            const SizedBox(height: 10),
          ],

          // New image picker
          Obx(() => c.pickedMenuImage.value != null
              ? Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(c.pickedMenuImage.value!,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => c.pickedMenuImage.value = null,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ])
              : InkWell(
            onTap: c.pickMenuImage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: color.withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: color, size: 20),
                  const SizedBox(width: 10),
                  Text('Replace Photo',
                      style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )),
          const SizedBox(height: 24),

          Row(children: [
            Expanded(
                child: outlinedBtn(
                  label: 'Cancel',
                  icon: Icons.close_rounded,
                  onPressed: c.clearMenuItemSelection,
                )),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Obx(() => primaryBtn(
                label: 'Update Item',
                icon: Icons.save_rounded,
                loading: c.isUpdatingMenuItem.value,
                onPressed: c.isUpdatingMenuItem.value
                    ? null
                    : c.updateMenuItem,
                color: color,
              )),
            ),
          ]),
        ],
      ),
    );
  }
}

// ─── Meal Section (expandable) ────────────────────────────────────────────────
class MealSection extends StatelessWidget {
  final String mealType;
  final List<MenuItemModel> items;
  final String tag;
  final BuildContext context;
  const MealSection({
    super.key,
    required this.mealType,
    required this.items,
    required this.tag,
    required this.context,
  });

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext ctx) {
    final color    = mealColor(mealType);
    final expanded = c.expandedMeals[mealType]!;

    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: expanded.value
            ? color.withOpacity(0.02)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded.value
              ? color.withOpacity(0.3)
              : Colors.grey.shade200,
          width: expanded.value ? 1.5 : 1.0,
        ),
      ),
      child: Column(children: [
        // Header
        InkWell(
          onTap: () => expanded.value = !expanded.value,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      Color.lerp(color, Colors.black, 0.25)!
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(mealIcon(mealType),
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mealType.capitalizeFirst!,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: color)),
                    Text(
                      '${items.length} item${items.length != 1 ? 's' : ''}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: expanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.expand_more_rounded,
                      color: color, size: 20),
                ),
              ),
            ]),
          ),
        ),

        // Expanded items
        if (expanded.value) ...[
          Divider(height: 1, color: color.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: items
                  .map((f) => MenuItemCard(
                  item: f, color: color, tag: tag,
                  context: context))
                  .toList(),
            ),
          ),
        ],
      ]),
    ));
  }
}

// ─── Menu Item Card ───────────────────────────────────────────────────────────
class MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final Color color;
  final String tag;
  final BuildContext context;
  const MenuItemCard({
    super.key,
    required this.item,
    required this.color,
    required this.tag,
    required this.context,
  });

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext ctx) => Obx(() {
    final isSelected = c.selectedMenuItem.value?.id == item.id;
    return GestureDetector(
      onTap: () => isSelected
          ? c.clearMenuItemSelection()
          : c.selectMenuItemForEdit(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.04)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.35)
                : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl.isNotEmpty
                ? Image.network(item.imageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.foodName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: DS.textPrimary)),
                if (item.shortDescription.isNotEmpty)
                  Text(item.shortDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
                const SizedBox(height: 4),
                Text(
                  '₹ ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: DS.success,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(mainAxisSize: MainAxisSize.min, children: [
            // Edit icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.12)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? color.withOpacity(0.3)
                      : Colors.grey.shade200,
                ),
              ),
              child: Icon(
                isSelected ? Icons.edit_rounded : Icons.edit_outlined,
                size: 16,
                color: isSelected ? color : Colors.grey.shade400,
              ),
            ),
            const SizedBox(width: 6),
            // Delete icon
            Obx(() => c.isDeletingMenuItem.value
                ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2))
                : GestureDetector(
              onTap: () => DeleteConfirmDialog.show(
                context: context,
                title: 'Delete Item',
                message:
                'Delete "${item.foodName}"? This cannot be undone.',
                onConfirm: () => c.deleteMenuItem(item),
              ),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border:
                  Border.all(color: Colors.red.shade100),
                ),
                child: Icon(Icons.delete_outline_rounded,
                    size: 16, color: Colors.red.shade400),
              ),
            )),
          ]),
        ]),
      ),
    );
  });

  Widget _placeholder() => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(Icons.fastfood_rounded, color: color, size: 22),
  );
}

// ─── Add Menu Item Card (expandable per meal) ─────────────────────────────────
class AddMenuItemCard extends StatelessWidget {
  final String mealType;
  final String tag;
  const AddMenuItemCard({super.key, required this.mealType, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    final color    = mealColor(mealType);
    final expanded = c.expandedMeals[mealType]!;
    final imgRx    = c.addFoodImages[mealType]!;

    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded.value
              ? color.withOpacity(0.4)
              : Colors.grey.shade200,
          width: expanded.value ? 1.5 : 1,
        ),
        color: expanded.value
            ? color.withOpacity(0.02)
            : Colors.grey.shade50,
      ),
      child: Column(children: [
        // Header
        InkWell(
          onTap: () => expanded.value = !expanded.value,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      Color.lerp(color, Colors.black, 0.25)!
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(mealIcon(mealType),
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(mealType.capitalizeFirst!,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ),
              AnimatedRotation(
                turns: expanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.expand_more_rounded,
                      color: color, size: 20),
                ),
              ),
            ]),
          ),
        ),

        // Form
        if (expanded.value) ...[
          Divider(height: 1, color: color.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                Expanded(
                  flex: 2,
                  child: modernTextField(
                    controller: c.addFoodNameCtrls[mealType]!,
                    label: 'Food Name',
                    hint: 'e.g. Masala Dosa',
                    icon: Icons.fastfood_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: modernTextField(
                    controller: c.addFoodPriceCtrls[mealType]!,
                    label: 'Price ₹',
                    hint: '0.00',
                    icon: Icons.currency_rupee_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              modernTextField(
                controller: c.addFoodDescCtrls[mealType]!,
                label: 'Description (optional)',
                hint: 'Short description of the dish',
                icon: Icons.notes_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Image picker
              Obx(() => imgRx.value != null
                  ? Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(imgRx.value!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => imgRx.value = null,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius:
                          BorderRadius.circular(8)),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ])
                  : InkWell(
                onTap: () => c.pickAddFoodImage(mealType),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: color.withOpacity(0.25),
                        width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: color, size: 20),
                      const SizedBox(width: 10),
                      Text('Add Photo',
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 16),
              Obx(() => primaryBtn(
                label: 'Add to Menu',
                icon: Icons.add_rounded,
                loading: c.isAddingMenuItem.value,
                color: color,
                onPressed: c.isAddingMenuItem.value
                    ? null
                    : () => c.submitAddFoodItem(mealType),
              )),
            ]),
          ),
        ],
      ]),
    ));
  }
}