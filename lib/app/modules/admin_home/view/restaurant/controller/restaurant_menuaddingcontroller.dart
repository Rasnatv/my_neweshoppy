//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../../data/models/adminretaurant_menumodel.dart';
//
// const String _baseUrl =
//     'https://rasma.astradevelops.in/e_shoppyy/public/api';
//
// class RestaurantmenuController extends GetxController {
//   final _storage = GetStorage();
//
//   // ---- Observables ----
//   var mealMenus = <MealMenu>[].obs;
//   var tableTypes = <TableType>[].obs;
//   var timeSlots = <TimeSlot>[].obs;
//   var seatingType = SeatingType.indoor.obs;
//   var selectedMealType = Rx<MealType>(MealType.breakfast);
//
//   var isLoadingPreview = false.obs;
//   var isAddingTable = false.obs;
//   var isAddingTimings = false.obs;
//   var isAddingMenuItem = false.obs;
//
//   // ==================== TAB 1: TABLE CONTROLLERS ====================
//   final tableTypeCtrl = TextEditingController();
//   final capacityRangeCtrl = TextEditingController();
//   final tableIdsCtrl = TextEditingController();
//
//   // ==================== TAB 2: TIMING CONTROLLERS ====================
//   final startCtrl = TextEditingController();
//   final endCtrl = TextEditingController();
//   final RxMap<MealType, List<TimeSlot>> pendingSlots =
//       <MealType, List<TimeSlot>>{}.obs;
//
//   // ==================== TAB 3: PER-MEAL CARD CONTROLLERS ====================
//   final Map<MealType, TextEditingController> foodNameCtrls = {};
//   final Map<MealType, TextEditingController> foodPriceCtrls = {};
//   final Map<MealType, TextEditingController> descriptionCtrls = {};
//   final Map<MealType, Rx<File?>> pickedImages = {};
//   final Map<MealType, RxBool> expandedCards = {};
//
//   final ImagePicker _picker = ImagePicker();
//
//   // -------------------- AUTH --------------------
//
//   String get authToken => _storage.read('auth_token') ?? '';
//
//   int get restaurantId {
//     final dynamic raw = _storage.read('restaurant_id');
//     if (raw == null) {
//       debugPrint('⚠️ restaurant_id not found in storage');
//       Get.snackbar(
//         'Session Error',
//         'Restaurant ID not found. Please re-register.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return 0;
//     }
//     final id = raw is int ? raw : int.tryParse(raw.toString()) ?? 0;
//     debugPrint('✅ restaurantId: $id');
//     return id;
//   }
//
//   Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $authToken',
//   };
//
//   // -------------------- INIT --------------------
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     for (var mealType in MealType.values) {
//       mealMenus.add(MealMenu(mealType: mealType));
//     }
//
//     for (var mealType in MealType.values) {
//       foodNameCtrls[mealType] = TextEditingController();
//       foodPriceCtrls[mealType] = TextEditingController();
//       descriptionCtrls[mealType] = TextEditingController();
//       pickedImages[mealType] = Rx<File?>(null);
//       expandedCards[mealType] = false.obs;
//     }
//
//     fetchSetupPreview();
//   }
//
//   // -------------------- DISPOSE --------------------
//
//   @override
//   void onClose() {
//     tableTypeCtrl.dispose();
//     capacityRangeCtrl.dispose();
//     tableIdsCtrl.dispose();
//     startCtrl.dispose();
//     endCtrl.dispose();
//
//     for (var mealType in MealType.values) {
//       foodNameCtrls[mealType]?.dispose();
//       foodPriceCtrls[mealType]?.dispose();
//       descriptionCtrls[mealType]?.dispose();
//     }
//
//     super.onClose();
//   }
//
//   // ==================== FORM HELPERS ====================
//
//   void toggleCard(MealType mealType) =>
//       expandedCards[mealType]!.value = !expandedCards[mealType]!.value;
//
//   void clearFoodForm(MealType mealType) {
//     foodNameCtrls[mealType]?.clear();
//     foodPriceCtrls[mealType]?.clear();
//     descriptionCtrls[mealType]?.clear();
//     pickedImages[mealType]?.value = null;
//   }
//
//   void addToPendingSlots() {
//     if (startCtrl.text.isEmpty || endCtrl.text.isEmpty) {
//       Get.snackbar('Validation', 'Please select start and end time',
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     final mealType = selectedMealType.value;
//     final slot = TimeSlot(
//       mealType: mealType,
//       startTime: startCtrl.text,
//       endTime: endCtrl.text,
//     );
//     pendingSlots.update(
//       mealType,
//           (list) => [...list, slot],
//       ifAbsent: () => [slot],
//     );
//     startCtrl.clear();
//     endCtrl.clear();
//   }
//
//   void submitTableForm() {
//     if (tableTypeCtrl.text.trim().isEmpty ||
//         capacityRangeCtrl.text.trim().isEmpty ||
//         tableIdsCtrl.text.trim().isEmpty) {
//       Get.snackbar('Validation', 'Please fill all table fields',
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     addTableType(
//       tableTypeCtrl.text.trim(),
//       capacityRangeCtrl.text.trim(),
//       tableIdsCtrl.text.trim(),
//       seatingType.value,
//     );
//     tableTypeCtrl.clear();
//     capacityRangeCtrl.clear();
//     tableIdsCtrl.clear();
//   }
//
//   Future<void> submitFoodItem(MealType mealType) async {
//     final price = double.tryParse(foodPriceCtrls[mealType]!.text.trim());
//     if (foodNameCtrls[mealType]!.text.trim().isEmpty || price == null) {
//       Get.snackbar(
//         'Validation',
//         'Please enter food name and valid price',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//     await addFoodItem(
//       mealType,
//       FoodItem(
//         name: foodNameCtrls[mealType]!.text.trim(),
//         price: price,
//         imageFile: pickedImages[mealType]?.value,
//         description: descriptionCtrls[mealType]!.text.trim(),
//       ),
//     );
//     clearFoodForm(mealType);
//   }
//
//   // -------------------- IMAGE PICKER --------------------
//
//   Future<File?> pickImage() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );
//     return image != null ? File(image.path) : null;
//   }
//
//   Future<void> pickFoodImage(MealType mealType) async {
//     final img = await pickImage();
//     pickedImages[mealType]?.value = img;
//   }
//
//   Future<String?> _fileToBase64(File file) async {
//     final bytes = await file.readAsBytes();
//     final ext = file.path.split('.').last.toLowerCase();
//     final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
//     return 'data:$mime;base64,${base64Encode(bytes)}';
//   }
//
//   // ==================== API: FETCH PREVIEW ====================
//
//   Future<void> fetchSetupPreview() async {
//     final id = restaurantId;
//     if (id == 0) return;
//
//     try {
//       isLoadingPreview.value = true;
//       final response = await http.post(
//         Uri.parse('$_baseUrl/restaurant/setup-preview'),
//         headers: _headers,
//         body: jsonEncode({'restaurant_id': id}),
//       );
//
//       debugPrint('fetchSetupPreview status: ${response.statusCode}');
//       debugPrint('fetchSetupPreview body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json['status'] == '1') {
//           final data = json['data'];
//           _loadTablesFromJson(data['tables'] ?? []);
//           _loadTimingsFromJson(data['meal_timings'] ?? []);
//           _loadMenuFromJson(data['menu_items'] ?? {});
//         }
//       }
//     } catch (e) {
//       debugPrint('fetchSetupPreview error: $e');
//     } finally {
//       isLoadingPreview.value = false;
//     }
//   }
//
//   void _loadTablesFromJson(List<dynamic> tablesJson) {
//     final tables = tablesJson
//         .map((t) => TableType.fromJson(t))
//         .toList();
//     tableTypes.assignAll(tables);
//   }
//
//   void _loadTimingsFromJson(List<dynamic> timingsJson) {
//     final seen = <String>{};
//     final slots = <TimeSlot>[];
//     for (var t in timingsJson) {
//       final slot = TimeSlot.fromJson(t);
//       final key =
//           '${slot.mealType.name}|${slot.startTime}|${slot.endTime}';
//       if (!seen.contains(key)) {
//         seen.add(key);
//         slots.add(slot);
//       }
//     }
//     timeSlots.assignAll(slots);
//   }
//
//   void _loadMenuFromJson(Map<String, dynamic> menuJson) {
//     for (var menu in mealMenus) {
//       final items = menuJson[menu.mealType.name] as List<dynamic>? ?? [];
//       menu.foodItems
//           .assignAll(items.map((e) => FoodItem.fromJson(e)).toList());
//     }
//   }
//
//   // ==================== API: ADD TABLE ====================
//
//   // ✅ FIXED: Send all table names in ONE request as comma-separated string
//   // API response: { "table_name": "T1,t2,t3" } — not one per request
//   Future<void> addTableType(
//       String name,
//       String capacityRange,
//       String tableIds, // e.g. "T1, T2, T3" from user input
//       SeatingType seating,
//       ) async {
//     final id = restaurantId;
//     if (id == 0) return;
//
//     // Normalize: trim, uppercase, rejoin as comma-separated
//     final normalizedTableIds = tableIds
//         .split(',')
//         .map((e) => e.trim().toUpperCase())
//         .where((e) => e.isNotEmpty)
//         .join(',');
//
//     if (normalizedTableIds.isEmpty) return;
//
//     try {
//       isAddingTable.value = true;
//
//       // ✅ Single API call with all table names
//       final payload = {
//         'restaurant_id': id,
//         'table_type': name,
//         'capacity_range': capacityRange,
//         'table_name': normalizedTableIds, // e.g. "T1,T2,T3"
//         'seating_type': seating.name,
//       };
//       debugPrint('addTableType payload: $payload');
//
//       final response = await http.post(
//         Uri.parse('$_baseUrl/add-restaurant-table'),
//         headers: _headers,
//         body: jsonEncode(payload),
//       );
//
//       debugPrint('addTableType status: ${response.statusCode}');
//       debugPrint('addTableType body: ${response.body}');
//
//       final json = jsonDecode(response.body);
//       if (json['status'] == '1') {
//         // ✅ Parse the returned table using the fixed fromJson
//         // which splits "T1,t2,t3" into ["T1", "T2", "T3"]
//         final addedTable = TableType.fromJson(json['data']);
//
//         final existing = tableTypes.firstWhereOrNull(
//               (t) =>
//           t.name == name &&
//               t.capacityRange == capacityRange &&
//               t.seatingType == seating,
//         );
//
//         if (existing != null) {
//           // Merge with existing group if same type exists
//           final index = tableTypes.indexOf(existing);
//           tableTypes[index] = TableType(
//             id: existing.id,
//             name: existing.name,
//             capacityRange: existing.capacityRange,
//             seatingType: existing.seatingType,
//             availableTables: [
//               ...existing.availableTables,
//               ...addedTable.availableTables,
//             ],
//           );
//         } else {
//           // Add as new group
//           tableTypes.add(addedTable);
//         }
//
//         Get.snackbar(
//           'Success',
//           '${addedTable.availableTables.length} table(s) added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           json['message'] ?? 'Failed to add tables',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Network error: $e',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       debugPrint('addTableType error: $e');
//     } finally {
//       isAddingTable.value = false;
//     }
//   }
//
//   void removeTableTypeLocally(TableType table) =>
//       tableTypes.remove(table);
//
//   // ==================== API: MEAL TIMINGS ====================
//
//   Future<void> addMealTimings(Map<MealType, List<TimeSlot>> slots) async {
//     final id = restaurantId;
//     if (id == 0) return;
//
//     final List<Map<String, String>> timingsPayload = [];
//     for (final entry in slots.entries) {
//       for (final slot in entry.value) {
//         timingsPayload.add({
//           'meal_type': entry.key.name,
//           'start_time': slot.startTime,
//           'end_time': slot.endTime,
//         });
//       }
//     }
//     if (timingsPayload.isEmpty) return;
//
//     try {
//       isAddingTimings.value = true;
//       final payload = {
//         'restaurant_id': id,
//         'meal_timings': timingsPayload,
//       };
//       debugPrint('addMealTimings payload: $payload');
//
//       final response = await http.post(
//         Uri.parse('$_baseUrl/restaurant/meal-timings'),
//         headers: _headers,
//         body: jsonEncode(payload),
//       );
//
//       debugPrint('addMealTimings status: ${response.statusCode}');
//       debugPrint('addMealTimings body: ${response.body}');
//
//       final json = jsonDecode(response.body);
//       if (json['status'] == '1') {
//         final data = json['data'] as List<dynamic>;
//         for (var t in data) {
//           final slot = TimeSlot.fromJson(t);
//           final isDup = timeSlots.any((s) =>
//           s.mealType == slot.mealType &&
//               s.startTime == slot.startTime &&
//               s.endTime == slot.endTime);
//           if (!isDup) timeSlots.add(slot);
//         }
//         Get.snackbar('Success', 'Meal timings saved successfully',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white);
//       } else {
//         Get.snackbar(
//           'Error',
//           json['message'] ?? 'Failed to save timings',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Network error: $e',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       debugPrint('addMealTimings error: $e');
//     } finally {
//       isAddingTimings.value = false;
//     }
//   }
//
//   void removeTimeSlot(TimeSlot slot) => timeSlots.remove(slot);
//
//   List<TimeSlot> getSlotsByMeal(MealType meal) =>
//       timeSlots.where((e) => e.mealType == meal).toList();
//
//   // ==================== API: MENU ITEM ====================
//
//   Future<void> addFoodItem(MealType mealType, FoodItem item) async {
//     final id = restaurantId;
//     if (id == 0) return;
//
//     try {
//       isAddingMenuItem.value = true;
//
//       String? base64Image;
//       if (item.imageFile != null) {
//         base64Image = await _fileToBase64(item.imageFile!);
//       }
//
//       final body = <String, dynamic>{
//         'restaurant_id': id,
//         'meal_type': mealType.name,
//         'food_name': item.name,
//         'price': item.price,
//         'short_description': item.description,
//       };
//       if (base64Image != null) body['image'] = base64Image;
//
//       debugPrint(
//           'addFoodItem: id=$id, meal=${mealType.name}, name=${item.name}, price=${item.price}');
//
//       final response = await http.post(
//         Uri.parse('$_baseUrl/restaurant/menu-item'),
//         headers: _headers,
//         body: jsonEncode(body),
//       );
//
//       debugPrint('addFoodItem status: ${response.statusCode}');
//       debugPrint('addFoodItem body: ${response.body}');
//
//       final json = jsonDecode(response.body);
//       if (json['status'] == '1') {
//         final savedItem = FoodItem.fromJson(json['data']);
//         final menu = mealMenus.firstWhere((m) => m.mealType == mealType);
//         menu.foodItems.add(savedItem);
//         Get.snackbar('Success', 'Food item added successfully',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white);
//       } else {
//         Get.snackbar(
//           'Error',
//           json['message'] ?? 'Failed to add item',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Network error: $e',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       debugPrint('addFoodItem error: $e');
//     } finally {
//       isAddingMenuItem.value = false;
//     }
//   }
//
//   void removeFoodItemLocally(MealType mealType, FoodItem item) {
//     final menu = mealMenus.firstWhere((m) => m.mealType == mealType);
//     menu.foodItems.remove(item);
//   }
//
//   MealMenu getMealMenu(MealType mealType) =>
//       mealMenus.firstWhere((m) => m.mealType == mealType);
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../data/models/adminretaurant_menumodel.dart';

const String _baseUrl =
    'https://rasma.astradevelops.in/e_shoppyy/public/api';

class RestaurantmenuController extends GetxController {
  final _storage = GetStorage();

  // ---- Observables ----
  var mealMenus = <MealMenu>[].obs;
  var tableTypes = <TableType>[].obs;
  var timeSlots = <TimeSlot>[].obs;
  var seatingType = SeatingType.indoor.obs;
  var selectedMealType = Rx<MealType>(MealType.breakfast);

  var isLoadingPreview = false.obs;
  var isAddingTable = false.obs;
  var isAddingTimings = false.obs;
  var isAddingMenuItem = false.obs;
  var isDeletingTiming = false.obs;

  // ==================== TAB 1: TABLE CONTROLLERS ====================
  final tableTypeCtrl = TextEditingController();
  final capacityRangeCtrl = TextEditingController();
  final tableIdsCtrl = TextEditingController();

  // ==================== TAB 2: TIMING CONTROLLERS ====================
  final startCtrl = TextEditingController();
  final endCtrl = TextEditingController();
  final RxMap<MealType, List<TimeSlot>> pendingSlots =
      <MealType, List<TimeSlot>>{}.obs;

  // ==================== TAB 3: PER-MEAL CARD CONTROLLERS ====================
  final Map<MealType, TextEditingController> foodNameCtrls = {};
  final Map<MealType, TextEditingController> foodPriceCtrls = {};
  final Map<MealType, TextEditingController> descriptionCtrls = {};
  final Map<MealType, Rx<File?>> pickedImages = {};
  final Map<MealType, RxBool> expandedCards = {};

  final ImagePicker _picker = ImagePicker();

  // -------------------- AUTH --------------------

  String get authToken => _storage.read('auth_token') ?? '';

  int get restaurantId {
    final dynamic raw = _storage.read('restaurant_id');
    if (raw == null) {
      debugPrint('⚠️ restaurant_id not found in storage');
      Get.snackbar(
        'Session Error',
        'Restaurant ID not found. Please re-register.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return 0;
    }
    final id = raw is int ? raw : int.tryParse(raw.toString()) ?? 0;
    debugPrint('✅ restaurantId: $id');
    return id;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  // -------------------- INIT --------------------

  @override
  void onInit() {
    super.onInit();

    for (var mealType in MealType.values) {
      mealMenus.add(MealMenu(mealType: mealType));
    }

    for (var mealType in MealType.values) {
      foodNameCtrls[mealType] = TextEditingController();
      foodPriceCtrls[mealType] = TextEditingController();
      descriptionCtrls[mealType] = TextEditingController();
      pickedImages[mealType] = Rx<File?>(null);
      expandedCards[mealType] = false.obs;
    }

    fetchSetupPreview();
  }

  // -------------------- DISPOSE --------------------

  @override
  void onClose() {
    tableTypeCtrl.dispose();
    capacityRangeCtrl.dispose();
    tableIdsCtrl.dispose();
    startCtrl.dispose();
    endCtrl.dispose();

    for (var mealType in MealType.values) {
      foodNameCtrls[mealType]?.dispose();
      foodPriceCtrls[mealType]?.dispose();
      descriptionCtrls[mealType]?.dispose();
    }

    super.onClose();
  }

  // ==================== FORM HELPERS ====================

  void toggleCard(MealType mealType) =>
      expandedCards[mealType]!.value = !expandedCards[mealType]!.value;

  void clearFoodForm(MealType mealType) {
    foodNameCtrls[mealType]?.clear();
    foodPriceCtrls[mealType]?.clear();
    descriptionCtrls[mealType]?.clear();
    pickedImages[mealType]?.value = null;
  }

  // ✅ FIX: Convert 24h TimeOfDay to 12h AM/PM string for API
  String formatTimeTo12h(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }

  void addToPendingSlots() {
    if (startCtrl.text.isEmpty || endCtrl.text.isEmpty) {
      Get.snackbar(
        'Validation',
        'Please select start and end time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final mealType = selectedMealType.value;

    // ✅ FIX: Check if this meal type already has a saved slot (from API)
    final existingSaved = timeSlots.where((s) => s.mealType == mealType).toList();
    if (existingSaved.isNotEmpty) {
      Get.snackbar(
        'Already Exists',
        '${mealType.name.capitalizeFirst} timing already saved. Delete existing slot first to change it.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
      return;
    }

    // ✅ FIX: Check if this meal type already queued in pendingSlots
    if (pendingSlots.containsKey(mealType) &&
        pendingSlots[mealType]!.isNotEmpty) {
      Get.snackbar(
        'Already Queued',
        '${mealType.name.capitalizeFirst} is already in the queue. Save first or clear.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final slot = TimeSlot(
      mealType: mealType,
      startTime: startCtrl.text,
      endTime: endCtrl.text,
    );

    pendingSlots.update(
      mealType,
          (list) => [...list, slot],
      ifAbsent: () => [slot],
    );

    startCtrl.clear();
    endCtrl.clear();

    Get.snackbar(
      'Queued',
      '${mealType.name.capitalizeFirst} slot added to queue. Tap "Save Timings" to submit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void submitTableForm() {
    if (tableTypeCtrl.text.trim().isEmpty ||
        capacityRangeCtrl.text.trim().isEmpty ||
        tableIdsCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please fill all table fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    addTableType(
      tableTypeCtrl.text.trim(),
      capacityRangeCtrl.text.trim(),
      tableIdsCtrl.text.trim(),
      seatingType.value,
    );
    tableTypeCtrl.clear();
    capacityRangeCtrl.clear();
    tableIdsCtrl.clear();
  }

  Future<void> submitFoodItem(MealType mealType) async {
    final price = double.tryParse(foodPriceCtrls[mealType]!.text.trim());
    if (foodNameCtrls[mealType]!.text.trim().isEmpty || price == null) {
      Get.snackbar(
        'Validation',
        'Please enter food name and valid price',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    await addFoodItem(
      mealType,
      FoodItem(
        name: foodNameCtrls[mealType]!.text.trim(),
        price: price,
        imageFile: pickedImages[mealType]?.value,
        description: descriptionCtrls[mealType]!.text.trim(),
      ),
    );
    clearFoodForm(mealType);
  }

  // -------------------- IMAGE PICKER --------------------

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    return image != null ? File(image.path) : null;
  }

  Future<void> pickFoodImage(MealType mealType) async {
    final img = await pickImage();
    pickedImages[mealType]?.value = img;
  }

  Future<String?> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    final ext = file.path.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
    return 'data:$mime;base64,${base64Encode(bytes)}';
  }

  // ==================== API: FETCH PREVIEW ====================

  Future<void> fetchSetupPreview() async {
    final id = restaurantId;
    if (id == 0) return;

    try {
      isLoadingPreview.value = true;
      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/setup-preview'),
        headers: _headers,
        body: jsonEncode({'restaurant_id': id}),
      );

      debugPrint('fetchSetupPreview status: ${response.statusCode}');
      debugPrint('fetchSetupPreview body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == '1') {
          final data = json['data'];
          _loadTablesFromJson(data['tables'] ?? []);
          _loadTimingsFromJson(data['meal_timings'] ?? []);
          _loadMenuFromJson(data['menu_items'] ?? {});
        }
      }
    } catch (e) {
      debugPrint('fetchSetupPreview error: $e');
    } finally {
      isLoadingPreview.value = false;
    }
  }

  void _loadTablesFromJson(List<dynamic> tablesJson) {
    final tables = tablesJson.map((t) => TableType.fromJson(t)).toList();
    tableTypes.assignAll(tables);
  }

  void _loadTimingsFromJson(List<dynamic> timingsJson) {
    final seen = <String>{};
    final slots = <TimeSlot>[];
    for (var t in timingsJson) {
      final slot = TimeSlot.fromJson(t);
      final key = '${slot.mealType.name}|${slot.startTime}|${slot.endTime}';
      if (!seen.contains(key)) {
        seen.add(key);
        slots.add(slot);
      }
    }
    timeSlots.assignAll(slots);
  }

  void _loadMenuFromJson(Map<String, dynamic> menuJson) {
    for (var menu in mealMenus) {
      final items = menuJson[menu.mealType.name] as List<dynamic>? ?? [];
      menu.foodItems
          .assignAll(items.map((e) => FoodItem.fromJson(e)).toList());
    }
  }

  // ==================== API: ADD TABLE ====================

  Future<void> addTableType(
      String name,
      String capacityRange,
      String tableIds,
      SeatingType seating,
      ) async {
    final id = restaurantId;
    if (id == 0) return;

    final normalizedTableIds = tableIds
        .split(',')
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .join(',');

    if (normalizedTableIds.isEmpty) return;

    try {
      isAddingTable.value = true;

      final payload = {
        'restaurant_id': id,
        'table_type': name,
        'capacity_range': capacityRange,
        'table_name': normalizedTableIds,
        'seating_type': seating.name,
      };
      debugPrint('addTableType payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/add-restaurant-table'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      debugPrint('addTableType status: ${response.statusCode}');
      debugPrint('addTableType body: ${response.body}');

      final json = jsonDecode(response.body);
      if (json['status'] == '1') {
        final addedTable = TableType.fromJson(json['data']);

        final existing = tableTypes.firstWhereOrNull(
              (t) =>
          t.name == name &&
              t.capacityRange == capacityRange &&
              t.seatingType == seating,
        );

        if (existing != null) {
          final index = tableTypes.indexOf(existing);
          tableTypes[index] = TableType(
            id: existing.id,
            name: existing.name,
            capacityRange: existing.capacityRange,
            seatingType: existing.seatingType,
            availableTables: [
              ...existing.availableTables,
              ...addedTable.availableTables,
            ],
          );
        } else {
          tableTypes.add(addedTable);
        }

        Get.snackbar(
          'Success',
          '${addedTable.availableTables.length} table(s) added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          json['message'] ?? 'Failed to add tables',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('addTableType error: $e');
    } finally {
      isAddingTable.value = false;
    }
  }

  void removeTableTypeLocally(TableType table) => tableTypes.remove(table);

  // ==================== API: MEAL TIMINGS ====================

  Future<void> addMealTimings(Map<MealType, List<TimeSlot>> slots) async {
    final id = restaurantId;
    if (id == 0) return;

    final List<Map<String, String>> timingsPayload = [];
    for (final entry in slots.entries) {
      for (final slot in entry.value) {
        timingsPayload.add({
          'meal_type': entry.key.name,
          'start_time': slot.startTime,
          'end_time': slot.endTime,
        });
      }
    }
    if (timingsPayload.isEmpty) return;

    try {
      isAddingTimings.value = true;

      final payload = {
        'restaurant_id': id,
        'meal_timings': timingsPayload,
      };
      debugPrint('addMealTimings payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/meal-timings'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      debugPrint('addMealTimings status: ${response.statusCode}');
      debugPrint('addMealTimings body: ${response.body}');

      final json = jsonDecode(response.body);

      // ✅ FIX: Handle 409 Conflict — meal timing already exists
      if (response.statusCode == 409 ||
          (json['status_code'] != null &&
              json['status_code'].toString() == '409')) {
        final rawMsg = json['message'] as String? ?? 'Timing already exists';
        Get.snackbar(
          'Already Exists',
          '$rawMsg\n\nDelete the existing slot first, then re-add.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
        return;
      }

      if (json['status'] == '1') {
        final data = json['data'] as List<dynamic>;
        for (var t in data) {
          final slot = TimeSlot.fromJson(t);
          final isDup = timeSlots.any((s) =>
          s.mealType == slot.mealType &&
              s.startTime == slot.startTime &&
              s.endTime == slot.endTime);
          if (!isDup) timeSlots.add(slot);
        }
        Get.snackbar(
          'Success',
          'Meal timings saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // ✅ FIX: Also handle status == '0' with 409-like message
        final rawMsg = json['message'] as String? ?? 'Failed to save timings';
        final isConflict = rawMsg.toLowerCase().contains('already');
        Get.snackbar(
          isConflict ? 'Already Exists' : 'Error',
          isConflict
              ? '$rawMsg\n\nDelete the existing slot first, then re-add.'
              : rawMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
          isConflict ? Colors.orange.shade800 : Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: isConflict ? 5 : 3),
          icon: isConflict
              ? const Icon(Icons.warning_amber_rounded, color: Colors.white)
              : null,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('addMealTimings error: $e');
    } finally {
      isAddingTimings.value = false;
    }
  }

  // ✅ FIX: removeTimeSlot now calls delete API, not just local removal
  Future<void> removeTimeSlot(TimeSlot slot) async {
    final id = restaurantId;
    if (id == 0) return;

    // Optimistic local remove
    timeSlots.remove(slot);

    try {
      isDeletingTiming.value = true;

      final payload = {
        'restaurant_id': id,
        'meal_type': slot.mealType.name,
        'start_time': slot.startTime,
        'end_time': slot.endTime,
      };

      // ✅ Use slot.id if your model has it, otherwise send meal_type + times
      if (slot.id != null) {
        payload['id'] = slot.id.toString();
      }

      debugPrint('removeTimeSlot payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/delete-meal-timing'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      debugPrint('removeTimeSlot status: ${response.statusCode}');
      debugPrint('removeTimeSlot body: ${response.body}');

      final json = jsonDecode(response.body);

      if (json['status'] != '1') {
        // Rollback on failure
        timeSlots.add(slot);
        Get.snackbar(
          'Error',
          json['message'] ?? 'Failed to delete timing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Deleted',
          '${slot.mealType.name.capitalizeFirst} slot removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Rollback on network error
      timeSlots.add(slot);
      debugPrint('removeTimeSlot error: $e');
      Get.snackbar(
        'Error',
        'Network error while deleting: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeletingTiming.value = false;
    }
  }

  List<TimeSlot> getSlotsByMeal(MealType meal) =>
      timeSlots.where((e) => e.mealType == meal).toList();

  // ==================== API: MENU ITEM ====================

  Future<void> addFoodItem(MealType mealType, FoodItem item) async {
    final id = restaurantId;
    if (id == 0) return;

    try {
      isAddingMenuItem.value = true;

      String? base64Image;
      if (item.imageFile != null) {
        base64Image = await _fileToBase64(item.imageFile!);
      }

      final body = <String, dynamic>{
        'restaurant_id': id,
        'meal_type': mealType.name,
        'food_name': item.name,
        'price': item.price,
        'short_description': item.description,
      };
      if (base64Image != null) body['image'] = base64Image;

      debugPrint(
          'addFoodItem: id=$id, meal=${mealType.name}, name=${item.name}, price=${item.price}');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/menu-item'),
        headers: _headers,
        body: jsonEncode(body),
      );

      debugPrint('addFoodItem status: ${response.statusCode}');
      debugPrint('addFoodItem body: ${response.body}');

      final json = jsonDecode(response.body);
      if (json['status'] == '1') {
        final savedItem = FoodItem.fromJson(json['data']);
        final menu = mealMenus.firstWhere((m) => m.mealType == mealType);
        menu.foodItems.add(savedItem);
        Get.snackbar(
          'Success',
          'Food item added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          json['message'] ?? 'Failed to add item',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('addFoodItem error: $e');
    } finally {
      isAddingMenuItem.value = false;
    }
  }

  void removeFoodItemLocally(MealType mealType, FoodItem item) {
    final menu = mealMenus.firstWhere((m) => m.mealType == mealType);
    menu.foodItems.remove(item);
  }

  MealMenu getMealMenu(MealType mealType) =>
      mealMenus.firstWhere((m) => m.mealType == mealType);
}