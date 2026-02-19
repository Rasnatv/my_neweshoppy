
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../data/models/adminretaurant_menumodel.dart';
import 'controller/restaurant_menuaddingcontroller.dart';

class MenuManagementPage extends StatelessWidget {
  const MenuManagementPage({super.key});

  // ✅ GetX controller holds everything — no StatefulWidget needed
  RestaurantmenuController get c => Get.find<RestaurantmenuController>();

  @override
  Widget build(BuildContext context) {
    // ✅ Register controller once when page builds
    Get.put(RestaurantmenuController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          title: Text(
            'Restaurant Menu Management',
            style: AppTextStyle.rTextNunitoWhite17w700,
          ),
          centerTitle: true,
          actions: [
            Obx(() => c.isLoadingPreview.value
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              ),
            )
                : IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Refresh preview',
              onPressed: c.fetchSetupPreview,
            )),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Tables & Seating'),
              Tab(text: 'Meal Timings'),
              Tab(text: 'Menu & Preview'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTablesTab(context),
            _buildTimingsTab(context),
            _buildMenuAndPreviewTab(),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 1: TABLES ====================

  Widget _buildTablesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Add Table Type'),

          // ✅ Controllers come from GetX — stable, never reset
          TextField(
            controller: c.tableTypeCtrl,
            decoration:
            _inputDecoration('Table Type (e.g., 5-Seater, VIP Table)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: c.capacityRangeCtrl,
            decoration:
            _inputDecoration('Capacity Range (e.g., 2-6 or 4)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: c.tableIdsCtrl,
            decoration:
            _inputDecoration('Table Names (e.g., T1, T6, T7)'),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<SeatingType>(
            value: c.seatingType.value,
            decoration: _inputDecoration('Seating Type'),
            items: SeatingType.values
                .map((e) => DropdownMenuItem(
                value: e, child: Text(e.name.capitalizeFirst!)))
                .toList(),
            onChanged: (v) => c.seatingType.value = v!,
          )),
          const SizedBox(height: 16),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
              ),
              icon: c.isAddingTable.value
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Icon(Icons.add),
              label: Text(c.isAddingTable.value
                  ? 'Saving...'
                  : 'Add Table Type'),
              // ✅ submitTableForm() handles validation + API + clear
              onPressed:
              c.isAddingTable.value ? null : c.submitTableForm,
            ),
          )),
          const SizedBox(height: 24),
          _sectionTitle('Your Tables'),
          Obx(() => c.tableTypes.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No tables added yet',
                  style: TextStyle(color: Colors.grey)),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: c.tableTypes.length,
            itemBuilder: (context, index) {
              final table = c.tableTypes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.table_restaurant,
                        color: AppColors.kPrimary),
                  ),
                  title: Text(table.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Capacity: ${table.capacityRange} people'),
                      Text(
                          'Tables: ${table.availableTables.join(', ')}'),
                      Text(
                          'Type: ${table.seatingType.name.capitalizeFirst}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () =>
                        c.removeTableTypeLocally(table),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  // ==================== TAB 2: TIMINGS ====================

  Widget _buildTimingsTab(BuildContext context) {
    Future<void> pickTime(TextEditingController ctrl) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        final hh = picked.hour.toString().padLeft(2, '0');
        final mm = picked.minute.toString().padLeft(2, '0');
        ctrl.text = '$hh:$mm';
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Add Meal Timing'),
          Obx(() => DropdownButtonFormField<MealType>(
            value: c.selectedMealType.value,
            decoration: _inputDecoration('Select Meal Type'),
            items: MealType.values
                .map((m) => DropdownMenuItem(
                value: m, child: Text(m.name.capitalizeFirst!)))
                .toList(),
            onChanged: (v) => c.selectedMealType.value = v!,
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: c.startCtrl,
                  readOnly: true,
                  onTap: () => pickTime(c.startCtrl),
                  decoration: _inputDecoration('Start Time').copyWith(
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: c.endCtrl,
                  readOnly: true,
                  onTap: () => pickTime(c.endCtrl),
                  decoration: _inputDecoration('End Time').copyWith(
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add to Queue'),
              // ✅ addToPendingSlots() handles validation + adds to queue
              onPressed: c.addToPendingSlots,
            ),
          ),

          // Pending queue indicator
          Obx(() {
            final total = c.pendingSlots.values
                .fold(0, (s, e) => s + e.length);
            if (total == 0) return const SizedBox();
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pending_actions, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$total slot(s) queued — tap Save to submit',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                  TextButton(
                    onPressed: () => c.pendingSlots.clear(),
                    child: const Text('Clear',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
              ),
              icon: c.isAddingTimings.value
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Icon(Icons.save),
              label: Text(c.isAddingTimings.value
                  ? 'Saving...'
                  : 'Save Timings'),
              onPressed: c.isAddingTimings.value ||
                  c.pendingSlots.isEmpty
                  ? null
                  : () async {
                await c.addMealTimings(c.pendingSlots);
                c.pendingSlots.clear();
              },
            ),
          )),
          const SizedBox(height: 24),
          _sectionTitle('Saved Meal Timings'),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: MealType.values.map((meal) {
              final slots = c.getSlotsByMeal(meal);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name.capitalizeFirst!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      slots.isEmpty
                          ? const Text('No timings added',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 14))
                          : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots
                            .map((s) => Chip(
                          label: Text(s.displayTime),
                          deleteIcon: const Icon(
                              Icons.close,
                              size: 18),
                          onDeleted: () =>
                              c.removeTimeSlot(s),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  // ==================== TAB 3: MENU & PREVIEW ====================

  Widget _buildMenuAndPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Menu Management by Meal Type'),
          const SizedBox(height: 4),
          Text(
            'Expand a meal type to add food items',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          // ✅ Each card is a pure StatelessWidget — controllers from GetX
          ...MealType.values.map((m) => _MealTypeCard(mealType: m)),
          const SizedBox(height: 32),
          const Divider(thickness: 2),
          const SizedBox(height: 16),
          _buildPreviewSection(),
        ],
      ),
    );
  }

  // ==================== PREVIEW SECTION ====================

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Restaurant Setup Preview'),
        const SizedBox(height: 16),

        // Tables Preview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.table_restaurant, color: AppColors.kPrimary),
                  const SizedBox(width: 8),
                  const Text('Tables & Seating',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                const Divider(),
                Obx(() => c.tableTypes.isEmpty
                    ? const Text('No tables configured',
                    style: TextStyle(color: Colors.grey))
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: c.tableTypes.map((t) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '• ${t.name} — Capacity: ${t.capacityRange} | '
                            'Tables: ${t.availableTables.join(', ')} (${t.seatingType.name})',
                      ),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Timings Preview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.access_time, color: AppColors.kPrimary),
                  const SizedBox(width: 8),
                  const Text('Meal Timings',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                const Divider(),
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: MealType.values.map((meal) {
                    final slots = c.getSlotsByMeal(meal);
                    if (slots.isEmpty) return const SizedBox();
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal.name.capitalizeFirst!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          ...slots.map(
                                  (s) => Text('  • ${s.displayTime}')),
                        ],
                      ),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Menu Preview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.restaurant_menu, color: AppColors.kPrimary),
                  const SizedBox(width: 8),
                  const Text('Menu Items by Meal Type',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                const Divider(),
                Obx(() {
                  final hasAnyItems = c.mealMenus
                      .any((menu) => menu.foodItems.isNotEmpty);
                  if (!hasAnyItems) {
                    return const Text('No menu items added',
                        style: TextStyle(color: Colors.grey));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: c.mealMenus.map((menu) {
                      if (menu.foodItems.isEmpty) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${menu.mealType.name.capitalizeFirst}:',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            ...menu.foodItems.map((food) => Padding(
                              padding:
                              const EdgeInsets.only(left: 16),
                              child: Text(
                                  '• ${food.name} — ₹${food.price.toStringAsFixed(2)}'),
                            )),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Refresh Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Preview',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: c.fetchSetupPreview,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ==================== UI HELPERS ====================

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold)),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

// ==================== MEAL TYPE CARD ====================
// ✅ Pure StatelessWidget — all state comes from GetX controller

class _MealTypeCard extends StatelessWidget {
  final MealType mealType;

  const _MealTypeCard({required this.mealType});

  RestaurantmenuController get c => Get.find<RestaurantmenuController>();

  IconData get _mealIcon {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }

  Color get _mealColor {
    switch (mealType) {
      case MealType.breakfast:
        return Colors.orange;
      case MealType.lunch:
        return Colors.green;
      case MealType.dinner:
        return Colors.blue;
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    final menu = c.getMealMenu(mealType);
    final isExpanded = c.expandedCards[mealType]!;
    final pickedImage = c.pickedImages[mealType]!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Obx(() => Column(
        children: [
          // ---- Header ----
          InkWell(
            onTap: () => c.toggleCard(mealType),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _mealColor.withOpacity(0.1),
                borderRadius: isExpanded.value
                    ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))
                    : BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _mealColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_mealIcon,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealType.name.capitalizeFirst!,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _mealColor),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          '${menu.foodItems.length} items',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14),
                        )),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _mealColor,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          // ---- Expanded Content ----
          if (isExpanded.value)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Add Food Item to ${mealType.name.capitalizeFirst}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  // Name + Price
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          // ✅ Controller from GetX map — stable
                          controller: c.foodNameCtrls[mealType],
                          decoration: _inputDecoration('Food Name'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: c.foodPriceCtrls[mealType],
                          keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: _inputDecoration('Price (₹)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextField(
                    controller: c.descriptionCtrls[mealType],
                    maxLines: 2,
                    decoration:
                    _inputDecoration('Short Description'),
                  ),
                  const SizedBox(height: 12),

                  // Image Picker
                  Obx(() => pickedImage.value != null
                      ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: Image.file(
                          pickedImage.value!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () =>
                          pickedImage.value = null,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close,
                                color: Colors.white,
                                size: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                      : OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _mealColor,
                      side: BorderSide(color: _mealColor),
                    ),
                    icon:
                    const Icon(Icons.add_photo_alternate),
                    label:
                    const Text('Pick Image (Optional)'),
                    // ✅ pickFoodImage() sets pickedImages[mealType]
                    onPressed: () =>
                        c.pickFoodImage(mealType),
                  )),
                  const SizedBox(height: 16),

                  // Add Food Item Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _mealColor,
                        foregroundColor: Colors.white,
                      ),
                      icon: c.isAddingMenuItem.value
                          ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2))
                          : const Icon(Icons.add),
                      label: Text(c.isAddingMenuItem.value
                          ? 'Saving...'
                          : 'Add Food Item'),
                      // ✅ submitFoodItem() handles validation + API + clear
                      onPressed: c.isAddingMenuItem.value
                          ? null
                          : () => c.submitFoodItem(mealType),
                    ),
                  )),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Items in ${mealType.name.capitalizeFirst}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Food Items List
                  Obx(() => menu.foodItems.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.restaurant,
                              size: 48,
                              color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text('No items added yet',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: menu.foodItems.length,
                    itemBuilder: (context, index) {
                      final food = menu.foodItems[index];
                      return Card(
                        color: Colors.grey[50],
                        margin: const EdgeInsets.symmetric(
                            vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                        child: ListTile(
                          leading: _buildFoodImage(food),
                          title: Text(food.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹ ${food.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 15),
                              ),
                              if (food.description.isNotEmpty)
                                Text(
                                  food.description,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12),
                                ),
                            ],
                          ),
                          isThreeLine:
                          food.description.isNotEmpty,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 22),
                            onPressed: () =>
                                c.removeFoodItemLocally(
                                    mealType, food),
                          ),
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
        ],
      )),
    );
  }

  Widget _buildFoodImage(FoodItem food) {
    if (food.imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(food.imageFile!,
            width: 60, height: 60, fit: BoxFit.cover),
      );
    }
    if (food.imageUrl != null && food.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          food.imageUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _foodPlaceholder(),
        ),
      );
    }
    return _foodPlaceholder();
  }

  Widget _foodPlaceholder() => Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: _mealColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(Icons.fastfood, color: _mealColor, size: 30),
  );
}