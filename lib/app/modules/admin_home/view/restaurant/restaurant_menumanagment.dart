
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';

/// ================= MODELS =================

class FoodItem {
  final String name;
  final File? image;
  final double price;
  final String discription;

  FoodItem({
    required this.name,
    required this.price,
    this.image,
    required this.discription,
  });
}

enum SeatingType { indoor, outdoor, both }

class TableType {
  final String name;
  final String capacityRange;
  final List<String> availableTables;
  final SeatingType seatingType;

  TableType({
    required this.name,
    required this.capacityRange,
    required this.availableTables,
    required this.seatingType,
  });
}

enum MealType { breakfast, lunch, dinner }

class TimeSlot {
  final MealType mealType;
  final String time;

  TimeSlot({required this.mealType, required this.time});
}

class MealMenu {
  final MealType mealType;
  final RxList<FoodItem> foodItems = <FoodItem>[].obs;

  MealMenu({required this.mealType});
}

/// ================= CONTROLLER =================

class RestaurantController extends GetxController {
  var mealMenus = <MealMenu>[].obs;
  var tableTypes = <TableType>[].obs;
  var timeSlots = <TimeSlot>[].obs;

  var seatingType = SeatingType.indoor.obs;
  var selectedMealType = Rx<MealType>(MealType.breakfast);

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Initialize meal menus for each meal type
    for (var mealType in MealType.values) {
      mealMenus.add(MealMenu(mealType: mealType));
    }
  }

  Future<File?> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  void addTableType(String name, String capacityRange, String tableIds, SeatingType seating) {
    final tables = tableIds
        .split(',')
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .toList();

    if (tables.isEmpty) return;

    tableTypes.add(TableType(
      name: name,
      capacityRange: capacityRange,
      availableTables: tables,
      seatingType: seating,
    ));
  }

  void addFoodItemToMeal(MealType mealType, FoodItem item) {
    final menu = mealMenus.firstWhere((m) => m.mealType == mealType);
    menu.foodItems.add(item);
  }

  void removeFoodItemFromMeal(MealType mealType, FoodItem item) {
    final menu = mealMenus.firstWhere((m) => m.mealType == mealType);
    menu.foodItems.remove(item);
  }

  void removeTableType(TableType table) {
    tableTypes.remove(table);
  }

  void addTimeSlot(MealType meal, String time) {
    if (time.isNotEmpty) timeSlots.add(TimeSlot(mealType: meal, time: time));
  }

  void removeTimeSlot(TimeSlot slot) {
    timeSlots.remove(slot);
  }

  List<TimeSlot> getSlotsByMeal(MealType meal) =>
      timeSlots.where((e) => e.mealType == meal).toList();

  MealMenu getMealMenu(MealType mealType) =>
      mealMenus.firstWhere((m) => m.mealType == mealType);

  void saveAllData() {
    debugPrint("====== TABLES ======");
    for (var t in tableTypes) {
      debugPrint(
          "${t.name} | Capacity: ${t.capacityRange} | Tables: ${t.availableTables.join(', ')} | ${t.seatingType.name}");
    }

    debugPrint("\n====== MEAL TIMINGS ======");
    for (var m in MealType.values) {
      final slots = getSlotsByMeal(m);
      if (slots.isNotEmpty) {
        debugPrint(m.name.toUpperCase());
        for (var t in slots) debugPrint(" - ${t.time}");
      }
    }

    debugPrint("\n====== MENU BY MEAL TYPE ======");
    for (var menu in mealMenus) {
      if (menu.foodItems.isNotEmpty) {
        debugPrint(menu.mealType.name.toUpperCase());
        for (var f in menu.foodItems) {
          debugPrint("  - ${f.name} : ₹${f.price}${f.image != null ? ' [Image]' : ''}");
        }
      }
    }
  }
}

/// ================= MAIN PAGE =================

class MenuManagementPage extends StatelessWidget {
  MenuManagementPage({super.key});

  final RestaurantController controller = Get.put(RestaurantController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          title: Text("Restaurant Menu Management",
              style: AppTextStyle.rTextNunitoWhite17w700),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Tables & Seating"),
              Tab(text: "Meal Timings"),
              Tab(text: "Menu & Preview"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTablesTab(),
            _buildTimingsTab(),
            _buildMenuAndPreviewTab(),
          ],
        ),
      ),
    );
  }

  // ===== TABLES TAB =====
  Widget _buildTablesTab() {
    final tableTypeCtrl = TextEditingController();
    final capacityRangeCtrl = TextEditingController();
    final tableIdsCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Add Table Type"),
          TextField(
            controller: tableTypeCtrl,
            decoration: _inputDecoration("Table Type (e.g., 5-Seater, VIP Table)"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: capacityRangeCtrl,
            decoration: _inputDecoration("Capacity Range (e.g., 2-6 or 4)"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: tableIdsCtrl,
            decoration: _inputDecoration("Available Tables (e.g., T1, T6, T7)"),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<SeatingType>(
            value: controller.seatingType.value,
            decoration: _inputDecoration("Seating Type"),
            items: SeatingType.values
                .map((e) => DropdownMenuItem(
                value: e, child: Text(e.name.capitalizeFirst!)))
                .toList(),
            onChanged: (v) => controller.seatingType.value = v!,
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Table Type"),
              onPressed: () {
                if (tableTypeCtrl.text.isNotEmpty &&
                    capacityRangeCtrl.text.isNotEmpty &&
                    tableIdsCtrl.text.isNotEmpty) {
                  controller.addTableType(
                    tableTypeCtrl.text.trim(),
                    capacityRangeCtrl.text.trim(),
                    tableIdsCtrl.text.trim(),
                    controller.seatingType.value,
                  );
                  tableTypeCtrl.clear();
                  capacityRangeCtrl.clear();
                  tableIdsCtrl.clear();
                  Get.snackbar("Success", "Table type added",
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Your Tables"),
          Obx(() => controller.tableTypes.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text("No tables added yet"),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.tableTypes.length,
            itemBuilder: (context, index) {
              final table = controller.tableTypes[index];
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
                      style:
                      const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Capacity: ${table.capacityRange} people"),
                      Text("Tables: ${table.availableTables.join(', ')}"),
                      Text(
                          "Type: ${table.seatingType.name.capitalizeFirst}"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.removeTableType(table),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  // ===== TIMINGS TAB =====
  Widget _buildTimingsTab() {
    final slotCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Add Meal Timing"),
          Obx(() => DropdownButtonFormField<MealType>(
            value: controller.selectedMealType.value,
            decoration: _inputDecoration("Select Meal Type"),
            items: MealType.values
                .map((m) => DropdownMenuItem(
                value: m, child: Text(m.name.capitalizeFirst!)))
                .toList(),
            onChanged: (v) => controller.selectedMealType.value = v!,
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: slotCtrl,
                  decoration: _inputDecoration("e.g., 9:00 AM - 11:00 AM"),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add"),
                onPressed: () {
                  if (slotCtrl.text.trim().isNotEmpty) {
                    controller.addTimeSlot(
                        controller.selectedMealType.value, slotCtrl.text.trim());
                    slotCtrl.clear();
                    Get.snackbar("Success", "Time slot added",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle("Meal Timings"),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: MealType.values.map((meal) {
              final slots = controller.getSlotsByMeal(meal);
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
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      slots.isEmpty
                          ? const Text("No timings added",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 14))
                          : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots
                            .map((s) => Chip(
                          label: Text(s.time),
                          deleteIcon: const Icon(Icons.close,
                              size: 18),
                          onDeleted: () =>
                              controller.removeTimeSlot(s),
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

  // ===== MENU AND PREVIEW TAB =====
  Widget _buildMenuAndPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Menu Management by Meal Type"),
          const SizedBox(height: 8),
          Text(
            "Click on a meal type to add food items",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Meal Type Cards
          Obx(() => Column(
            children: MealType.values.map((mealType) {
              return _buildMealTypeCard(mealType);
            }).toList(),
          )),

          const SizedBox(height: 32),
          const Divider(thickness: 2),
          const SizedBox(height: 16),

          // PREVIEW SECTION
          _buildPreviewSection(),
        ],
      ),
    );
  }

  Widget _buildMealTypeCard(MealType mealType) {
    final foodNameCtrl = TextEditingController();
    final foodPriceCtrl = TextEditingController();
    final discriptionCtrl=TextEditingController();
    final isExpanded = false.obs;

    // Get icon and color for each meal type
    IconData mealIcon;
    Color mealColor;
    switch (mealType) {
      case MealType.breakfast:
        mealIcon = Icons.free_breakfast;
        mealColor = Colors.orange;
        break;
      case MealType.lunch:
        mealIcon = Icons.lunch_dining;
        mealColor = Colors.green;
        break;
      case MealType.dinner:
        mealIcon = Icons.dinner_dining;
        mealColor = Colors.blue;
        break;
    }

    final menu = controller.getMealMenu(mealType);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Obx(() => Column(
        children: [
          // Header - Click to expand
          InkWell(
            onTap: () => isExpanded.value = !isExpanded.value,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mealColor.withOpacity(0.1),
                borderRadius: isExpanded.value
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
                    : BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mealColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(mealIcon, color: Colors.white, size: 28),
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
                            color: mealColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          "${menu.foodItems.length} items",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: mealColor,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          if (isExpanded.value)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    "Add Food Item to ${mealType.name.capitalizeFirst}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: foodNameCtrl,
                          decoration: _inputDecoration("Food Name"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: foodPriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("Price (₹)"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mealColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                          onPressed: () {
                            final price =
                            double.tryParse(foodPriceCtrl.text);
                            if (foodNameCtrl.text.isNotEmpty &&
                                price != null) {
                              controller.addFoodItemToMeal(
                                mealType,
                                FoodItem(
                                  name: foodNameCtrl.text,
                                  price: price,
                                  image: null,
                                  discription:discriptionCtrl.text,
                                ),
                              );
                              foodNameCtrl.clear();
                              foodPriceCtrl.clear();
                              Get.snackbar("Success", "Food item added",
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: mealColor,
                            side: BorderSide(color: mealColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text("With Image"),
                          onPressed: () async {
                            final image = await controller.pickImage();
                            final price =
                            double.tryParse(foodPriceCtrl.text);
                            if (foodNameCtrl.text.isNotEmpty &&
                                price != null) {
                              controller.addFoodItemToMeal(
                                mealType,
                                FoodItem(
                                  name: foodNameCtrl.text,
                                  price: price,
                                  image: image,
                                  discription: discriptionCtrl.text
                                ),
                              );
                              foodNameCtrl.clear();
                              foodPriceCtrl.clear();
                              Get.snackbar("Success", "Food item added",
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    "Items in ${mealType.name.capitalizeFirst}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => menu.foodItems.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.restaurant,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            "No items added yet",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menu.foodItems.length,
                    itemBuilder: (context, index) {
                      final food = menu.foodItems[index];
                      return Card(
                        color: Colors.grey[50],
                        margin:
                        const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: food.image != null
                              ? ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8),
                            child: Image.file(
                              food.image!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: mealColor.withOpacity(0.2),
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.fastfood,
                                color: mealColor, size: 30),
                          ),
                          title: Text(
                            food.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "₹ ${food.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 22),
                            onPressed: () => controller
                                .removeFoodItemFromMeal(
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

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Restaurant Setup Preview"),
        const SizedBox(height: 16),

        // Tables Preview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.table_restaurant, color: AppColors.kPrimary),
                    const SizedBox(width: 8),
                    const Text("Tables & Seating",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(),
                Obx(() => controller.tableTypes.isEmpty
                    ? const Text("No tables configured")
                    : Column(
                  children: controller.tableTypes.map((t) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                          "• ${t.name} - Capacity: ${t.capacityRange} | Tables: ${t.availableTables.join(', ')} (${t.seatingType.name})"),
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
                Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.kPrimary),
                    const SizedBox(width: 8),
                    const Text("Meal Timings",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(),
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: MealType.values.map((meal) {
                    final slots = controller.getSlotsByMeal(meal);
                    if (slots.isEmpty) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal.name.capitalizeFirst!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          ...slots.map((s) => Text("  • ${s.time}")),
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

        // Menu Preview - Updated to show by meal type
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: AppColors.kPrimary),
                    const SizedBox(width: 8),
                    const Text("Menu Items by Meal Type",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(),
                Obx(() {
                  final hasAnyItems = controller.mealMenus
                      .any((menu) => menu.foodItems.isNotEmpty);

                  if (!hasAnyItems) {
                    return const Text("No menu items added");
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.mealMenus.map((menu) {
                      if (menu.foodItems.isEmpty) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${menu.mealType.name.capitalizeFirst}:",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...menu.foodItems.map((food) => Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                  "• ${food.name} - ₹${food.price.toStringAsFixed(2)}"),
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

        // Save Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save),
            label: const Text("Save Restaurant Configuration",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              controller.saveAllData();
              Get.snackbar(
                "Success",
                "Restaurant configuration saved successfully!",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
          ),
        ),
      ],
    );
  }

  // ===== UI HELPERS =====
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}