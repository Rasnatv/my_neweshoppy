
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../data/errors/api_error.dart';
import '../../../../../data/models/adminretaurant_menumodel.dart';
import '../../../../merchantlogin/widget/successwidget.dart';

const String _baseUrl = 'https://eshoppy.co.in/api';

class RestaurantmenuController extends GetxController {
  final _storage = GetStorage();

  // ---- Observables ----
  var mealMenus        = <MealMenu>[].obs;
  var tableTypes       = <TableType>[].obs;
  var timeSlots        = <TimeSlot>[].obs;
  var seatingType      = SeatingType.indoor.obs;
  var selectedMealType = Rx<MealType>(MealType.breakfast);

  var isLoadingPreview = false.obs;
  var isAddingTable    = false.obs;
  var isAddingTimings  = false.obs;
  var isAddingMenuItem = false.obs;
  var isDeletingTiming = false.obs;

  // ==================== TAB 1: TABLE CONTROLLERS ====================
  final tableTypeCtrl     = TextEditingController();
  final capacityRangeCtrl = TextEditingController();
  final tableIdsCtrl      = TextEditingController();

  // ==================== TAB 2: TIMING CONTROLLERS ====================
  final startCtrl         = TextEditingController();
  final endCtrl           = TextEditingController();
  final breakDurationCtrl = TextEditingController();
  final RxMap<MealType, List<TimeSlot>> pendingSlots =
      <MealType, List<TimeSlot>>{}.obs;

  // ==================== TAB 3: PER-MEAL CARD CONTROLLERS ====================
  final Map<MealType, TextEditingController> foodNameCtrls    = {};
  final Map<MealType, TextEditingController> foodPriceCtrls   = {};
  final Map<MealType, TextEditingController> descriptionCtrls = {};
  final Map<MealType, Rx<File?>>  pickedImages  = {};
  final Map<MealType, RxBool>     expandedCards = {};

  final ImagePicker _picker = ImagePicker();

  // -------------------- AUTH --------------------

  String get authToken => _storage.read('auth_token') ?? '';

  int get restaurantId {
    final dynamic raw = _storage.read('restaurant_id');
    if (raw == null) {
      debugPrint('⚠️ restaurant_id not found in storage');
      AppSnackbar.error('Restaurant ID not found. Please re-register.');
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
      foodNameCtrls[mealType]    = TextEditingController();
      foodPriceCtrls[mealType]   = TextEditingController();
      descriptionCtrls[mealType] = TextEditingController();
      pickedImages[mealType]     = Rx<File?>(null);
      expandedCards[mealType]    = false.obs;
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
    breakDurationCtrl.dispose();
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

  String formatTimeTo12h(TimeOfDay time) {
    final hour        = time.hour;
    final minute      = time.minute.toString().padLeft(2, '0');
    final period      = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }

  // ==================== PENDING SLOTS ====================

  void addToPendingSlots() {
    if (startCtrl.text.isEmpty || endCtrl.text.isEmpty) {
      AppSnackbar.warning('Please select start and end time');
      return;
    }

    final mealType      = selectedMealType.value;
    final existingSaved = timeSlots.where((s) => s.mealType == mealType).toList();

    if (existingSaved.isNotEmpty) {
      AppSnackbar.warning(
        '${mealType.name.capitalizeFirst} timing already saved. Delete existing slot first to change it.',
      );
      return;
    }

    if (pendingSlots.containsKey(mealType) &&
        pendingSlots[mealType]!.isNotEmpty) {
      AppSnackbar.warning(
        '${mealType.name.capitalizeFirst} is already in the queue. Save first or clear.',
      );
      return;
    }

    final breakMins = int.tryParse(breakDurationCtrl.text.trim()) ?? 0;
    final slot = TimeSlot(
      mealType:      mealType,
      startTime:     startCtrl.text,
      endTime:       endCtrl.text,
      breakDuration: breakMins,
    );

    pendingSlots.update(
      mealType,
          (list) => [...list, slot],
      ifAbsent: () => [slot],
    );

    startCtrl.clear();
    endCtrl.clear();
    breakDurationCtrl.clear();

    AppSnackbar.success(
      '${mealType.name.capitalizeFirst} slot added to queue. Tap "Save Timings" to submit.',
    );
  }

  // ==================== TABLE FORM ====================

  void submitTableForm() {
    if (tableTypeCtrl.text.trim().isEmpty ||
        capacityRangeCtrl.text.trim().isEmpty ||
        tableIdsCtrl.text.trim().isEmpty) {
      AppSnackbar.warning('Please fill all table fields');
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

  // ==================== FOOD ITEM FORM ====================

  Future<void> submitFoodItem(MealType mealType) async {
    final price = double.tryParse(foodPriceCtrls[mealType]!.text.trim());
    if (foodNameCtrls[mealType]!.text.trim().isEmpty || price == null) {
      AppSnackbar.warning('Please enter food name and valid price');
      return;
    }
    await addFoodItem(
      mealType,
      FoodItem(
        name:        foodNameCtrls[mealType]!.text.trim(),
        price:       price,
        imageFile:   pickedImages[mealType]?.value,
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
    final ext   = file.path.split('.').last.toLowerCase();
    final mime  = ext == 'png' ? 'image/png' : 'image/jpeg';
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
      debugPrint('fetchSetupPreview body:   ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == '1') {
          final data = json['data'];
          _loadTablesFromJson(data['tables'] ?? []);
          _loadTimingsFromJson(data['meal_timings'] ?? []);
          _loadMenuFromJson(data['menu_items']);   // ← pass raw value (may be [] or {})
        } else {
          AppSnackbar.warning(
            json['message']?.toString() ?? 'Failed to load preview',
          );
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      debugPrint('fetchSetupPreview error: $e');
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingPreview.value = false;
    }
  }

  void _loadTablesFromJson(List<dynamic> tablesJson) {
    tableTypes.assignAll(tablesJson.map((t) => TableType.fromJson(t)).toList());
  }

  void _loadTimingsFromJson(List<dynamic> timingsJson) {
    final seen  = <String>{};
    final slots = <TimeSlot>[];
    for (var t in timingsJson) {
      final slot = TimeSlot.fromJson(t);
      final key  = '${slot.mealType.name}|${slot.startTime}|${slot.endTime}';
      if (!seen.contains(key)) {
        seen.add(key);
        slots.add(slot);
      }
    }
    timeSlots.assignAll(slots);
  }

  /// Safely handles both [] (empty list from API) and {"breakfast":[...]} (map with data).
  void _loadMenuFromJson(dynamic rawMenuJson) {
    // When no menu items exist, the API returns [] instead of {}
    // Guard against that so we never crash with a cast error.
    if (rawMenuJson == null || rawMenuJson is! Map) {
      debugPrint('_loadMenuFromJson: received non-Map (${rawMenuJson.runtimeType}), skipping.');
      return;
    }
    final menuJson = rawMenuJson as Map<String, dynamic>;
    for (var menu in mealMenus) {
      final items = menuJson[menu.mealType.name] as List<dynamic>? ?? [];
      menu.foodItems.assignAll(items.map((e) => FoodItem.fromJson(e)).toList());
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
        'table_type':    name,
        'capacity_range': capacityRange,
        'table_name':    normalizedTableIds,
        'seating_type':  seating.name,
      };
      debugPrint('addTableType payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/add-restaurant-table'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      debugPrint('addTableType status: ${response.statusCode}');
      debugPrint('addTableType body:   ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (json['status'] == '1') {
          final addedTable = TableType.fromJson(json['data']);
          final existing   = tableTypes.firstWhereOrNull(
                (t) =>
            t.name == name &&
                t.capacityRange == capacityRange &&
                t.seatingType == seating,
          );

          if (existing != null) {
            final index = tableTypes.indexOf(existing);
            tableTypes[index] = TableType(
              id:              existing.id,
              name:            existing.name,
              capacityRange:   existing.capacityRange,
              seatingType:     existing.seatingType,
              availableTables: [
                ...existing.availableTables,
                ...addedTable.availableTables,
              ],
            );
          } else {
            tableTypes.add(addedTable);
          }

          AppSnackbar.success(
            '${addedTable.availableTables.length} table(s) added successfully',
          );
        } else {
          AppSnackbar.warning(
            json['message']?.toString() ?? 'Failed to add tables',
          );
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      debugPrint('addTableType error: $e');
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isAddingTable.value = false;
    }
  }

  void removeTableTypeLocally(TableType table) => tableTypes.remove(table);

  // ==================== API: MEAL TIMINGS ====================

  Future<void> addMealTimings(Map<MealType, List<TimeSlot>> slots) async {
    final id = restaurantId;
    if (id == 0) return;

    final List<Map<String, dynamic>> timingsPayload = [];
    for (final entry in slots.entries) {
      for (final slot in entry.value) {
        timingsPayload.add({
          'meal_type':      entry.key.name,
          'start_time':     slot.startTime,
          'end_time':       slot.endTime,
          'break_duration': slot.breakDuration,
        });
      }
    }
    if (timingsPayload.isEmpty) return;

    try {
      isAddingTimings.value = true;

      final payload = {
        'restaurant_id': id,
        'meal_timings':  timingsPayload,
      };
      debugPrint('addMealTimings payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/meal-timings'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      debugPrint('addMealTimings status: ${response.statusCode}');
      debugPrint('addMealTimings body:   ${response.body}');

      final json = jsonDecode(response.body);

      // ── 409 Conflict ──────────────────────────────────────────────
      if (response.statusCode == 409 ||
          json['status_code']?.toString() == '409') {
        final msg = json['message']?.toString() ?? 'Timing already exists';
        AppSnackbar.warning('$msg\n\nDelete the existing slot first, then re-add.');
        return;
      }

      if (json['status'] == '1') {
        final data = json['data'] as List<dynamic>;
        for (var t in data) {
          final slot  = TimeSlot.fromJson(t);
          final isDup = timeSlots.any((s) =>
          s.mealType  == slot.mealType &&
              s.startTime == slot.startTime &&
              s.endTime   == slot.endTime);
          if (!isDup) timeSlots.add(slot);
        }
        AppSnackbar.success('Meal timings saved successfully');
      } else {
        final msg        = json['message']?.toString() ?? 'Failed to save timings';
        final isConflict = msg.toLowerCase().contains('already');
        isConflict
            ? AppSnackbar.warning('$msg\n\nDelete the existing slot first, then re-add.')
            : AppSnackbar.error(msg);
      }
    } catch (e) {
      debugPrint('addMealTimings error: $e');
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isAddingTimings.value = false;
    }
  }

  // ==================== API: DELETE TIMING ====================

  Future<void> removeTimeSlot(TimeSlot slot) async {
    final id = restaurantId;
    if (id == 0) return;

    timeSlots.remove(slot); // optimistic remove

    try {
      isDeletingTiming.value = true;

      final Map<String, dynamic> payload = {
        'restaurant_id': id,
        'meal_type':     slot.mealType.name,
        'start_time':    slot.startTime,
        'end_time':      slot.endTime,
      };
      if (slot.id != null) payload['id'] = slot.id.toString();

      debugPrint('removeTimeSlot payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/delete-meal-timing'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      debugPrint('removeTimeSlot status: ${response.statusCode}');
      debugPrint('removeTimeSlot body:   ${response.body}');

      final json = jsonDecode(response.body);

      if (json['status'] == '1') {
        AppSnackbar.success(
          '${slot.mealType.name.capitalizeFirst} slot removed',
        );
      } else {
        timeSlots.add(slot); // rollback
        AppSnackbar.error(
          json['message']?.toString() ?? 'Failed to delete timing',
        );
      }
    } catch (e) {
      timeSlots.add(slot); // rollback
      debugPrint('removeTimeSlot error: $e');
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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
        'restaurant_id':     id,
        'meal_type':         mealType.name,
        'food_name':         item.name,
        'price':             item.price,
        'short_description': item.description,
      };
      if (base64Image != null) body['image'] = base64Image;

      debugPrint(
        'addFoodItem: id=$id, meal=${mealType.name}, name=${item.name}, price=${item.price}',
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant/menu-item'),
        headers: _headers,
        body: jsonEncode(body),
      );

      debugPrint('addFoodItem status: ${response.statusCode}');
      debugPrint('addFoodItem body:   ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (json['status'] == '1') {
          final savedItem = FoodItem.fromJson(json['data']);
          final menu      = mealMenus.firstWhere((m) => m.mealType == mealType);
          menu.foodItems.add(savedItem);
          AppSnackbar.success('Food item added successfully');
        } else {
          AppSnackbar.warning(
            json['message']?.toString() ?? 'Failed to add item',
          );
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      debugPrint('addFoodItem error: $e');
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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