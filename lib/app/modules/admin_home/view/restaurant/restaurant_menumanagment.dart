
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

  FoodItem({
    required this.name,
    required this.price,
    this.image,
  });
}

class MenuCategory {
  final String name;
  final RxList<FoodItem> foodItems = <FoodItem>[].obs;

  MenuCategory({required this.name});
}

enum SeatingType { indoor, outdoor, both }

class TableType {
  final String name;
  final int capacity;
  final int tableCount;
  final SeatingType seatingType;

  TableType({
    required this.name,
    required this.capacity,
    required this.tableCount,
    required this.seatingType,
  });
}

enum MealType { breakfast, lunch, dinner }

class TimeSlot {
  final MealType mealType;
  final String time;

  TimeSlot({required this.mealType, required this.time});
}

/// ================= CONTROLLER =================

class RestaurantController extends GetxController {
  var categories = <MenuCategory>[].obs;
  var tableTypes = <TableType>[].obs;
  var timeSlots = <TimeSlot>[].obs;

  var seatingType = SeatingType.indoor.obs;
  var selectedMealType = MealType.breakfast.obs;

  final ImagePicker picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  void addTableType(TableType table) {
    tableTypes.add(table);
  }

  void addCategory(String name) {
    if (name.isNotEmpty) categories.add(MenuCategory(name: name));
  }

  void addFoodItem(MenuCategory category, FoodItem item) {
    category.foodItems.add(item);
  }

  void addTimeSlot(MealType meal, String time) {
    if (time.isNotEmpty) timeSlots.add(TimeSlot(mealType: meal, time: time));
  }

  List<TimeSlot> getSlotsByMeal(MealType meal) =>
      timeSlots.where((e) => e.mealType == meal).toList();

  void saveAllData() {

    for (var t in tableTypes) {
      debugPrint(
          "${t.name} (${t.capacity}) × ${t.tableCount} - ${t.seatingType.name}");
    }

    for (var m in MealType.values) {
      debugPrint(m.name.toUpperCase());
      for (var t in getSlotsByMeal(m)) debugPrint(" - ${t.time}");
    }

    debugPrint("====== MENU ======");
    for (var cat in categories) {
      debugPrint("Category: ${cat.name}");
      for (var f in cat.foodItems) {
        debugPrint(" - ${f.name} : ₹${f.price}");
      }
    }
  }
}

/// ================= MAIN PAGE =================

class MenuManagementPage extends StatelessWidget {
  MenuManagementPage({super.key});

  final RestaurantController controller = Get.put(RestaurantController());

  final TextEditingController categoryCtrl = TextEditingController();
  final TextEditingController slotCtrl = TextEditingController();

  final TextEditingController tableTypeCtrl = TextEditingController();
  final TextEditingController capacityCtrl = TextEditingController();
  final TextEditingController tableCountCtrl = TextEditingController();

  final TextEditingController foodNameCtrl = TextEditingController();
  final TextEditingController foodPriceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text("Restaurant Menu Management",style:AppTextStyle.rTextNunitoWhite17w700),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== DEFAULT SEATING TYPE =====
            sectionTitle("Default Seating Type"),
            Obx(() => Column(
              children: SeatingType.values
                  .map((type) => RadioListTile<SeatingType>(
                title: Text(type.name.capitalizeFirst!),
                value: type,
                groupValue: controller.seatingType.value,
                onChanged: (val) =>
                controller.seatingType.value = val!,
              ))
                  .toList(),
            )),
            const Divider(height: 32),

            // ===== TABLE TYPES =====
            sectionTitle("Table Types"),
            TextField(
              controller: tableTypeCtrl,
              decoration: inputDecoration("Table Type (Eg: 4-Seater)"),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: capacityCtrl,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("Capacity"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: tableCountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("No. of Tables"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<SeatingType>(
              value: controller.seatingType.value,
              decoration: inputDecoration("Seating Type"),
              items: SeatingType.values
                  .map((e) => DropdownMenuItem(
                  value: e, child: Text(e.name.capitalizeFirst!)))
                  .toList(),
              onChanged: (v) => controller.seatingType.value = v!,
            )),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final capacity = int.tryParse(capacityCtrl.text);
                final count = int.tryParse(tableCountCtrl.text);
                if (tableTypeCtrl.text.isNotEmpty &&
                    capacity != null &&
                    count != null) {
                  controller.addTableType(TableType(
                      name: tableTypeCtrl.text,
                      capacity: capacity,
                      tableCount: count,
                      seatingType: controller.seatingType.value));
                  tableTypeCtrl.clear();
                  capacityCtrl.clear();
                  tableCountCtrl.clear();
                }
              },
              child: const Text("Add "),
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: controller.tableTypes
                  .map((t) => Chip(
                  label: Text(
                      "${t.name} (${t.capacity}) × ${t.tableCount} - ${t.seatingType.name}")))
                  .toList(),
            )),
            const Divider(height: 32),

            // ===== TIME SLOTS =====
            sectionTitle("Meal Timings"),
            Obx(() => DropdownButtonFormField<MealType>(
              value: controller.selectedMealType.value,
              decoration: inputDecoration("Select Meal"),
              items: MealType.values
                  .map((m) => DropdownMenuItem(
                  value: m, child: Text(m.name.capitalizeFirst!)))
                  .toList(),
              onChanged: (v) => controller.selectedMealType.value = v!,
            )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: slotCtrl,
                    decoration:
                    inputDecoration("Eg: 9:00 AM - 11:00 AM"),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.addTimeSlot(
                        controller.selectedMealType.value, slotCtrl.text.trim());
                    slotCtrl.clear();
                  },
                  child: const Text("Add"),
                )
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: MealType.values.map((meal) {
                final slots = controller.getSlotsByMeal(meal);
                if (slots.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name.capitalizeFirst!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children:
                      slots.map((s) => Chip(label: Text(s.time))).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            )),
            const Divider(height: 32),

            // ===== MENU CATEGORY =====
            sectionTitle("Menu Categories"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: categoryCtrl,
                    decoration: inputDecoration("Category Name"),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.addCategory(categoryCtrl.text.trim());
                    categoryCtrl.clear();
                  },
                  child: const Text("Add"),
                )
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.categories.isEmpty
                ? const Center(child: Text("No categories added"))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: foodNameCtrl,
                                decoration:
                                inputDecoration("Food Name"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: foodPriceCtrl,
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration("Price"),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green),
                              onPressed: () async {
                                final image =
                                await controller.pickImage();
                                final price =
                                double.tryParse(foodPriceCtrl.text);
                                if (foodNameCtrl.text.isNotEmpty &&
                                    price != null) {
                                  controller.addFoodItem(
                                      category,
                                      FoodItem(
                                          name: foodNameCtrl.text,
                                          price: price,
                                          image: image));
                                  foodNameCtrl.clear();
                                  foodPriceCtrl.clear();
                                }
                              },
                            )
                          ],
                        ),
                        Obx(() => Column(
                          children: category.foodItems
                              .map((f) => ListTile(
                            leading: f.image != null
                                ? Image.file(f.image!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover)
                                : const Icon(Icons.fastfood),
                            title: Text(f.name),
                            subtitle: Text("₹ ${f.price}"),
                          ))
                              .toList(),
                        ))
                      ],
                    ),
                  ),
                );
              },
            )),

            const SizedBox(height: 24),

            // ===== SAVE BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Restaurant Details"),
                onPressed: () {
                  controller.saveAllData();
                  Get.snackbar("Success", "Restaurant data saved successfully",
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===== UI HELPERS =====
  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  InputDecoration inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
