// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../../data/models/admin_restarant_menuupdatemodel.dart';
//
// const _baseUrl = 'https://rasma.astradevelops.in/e_shoppyy/public/api';
//
// enum SeatingTypeUpdate { indoor, outdoor, rooftop, balcony }
//
// class RestaurantMenuUpdateController extends GetxController {
//   final int restaurantId;
//
//   RestaurantMenuUpdateController({required this.restaurantId});
//
//   final _storage = GetStorage();
//
//   // ── Loading States ──────────────────────────────────────────────────────────
//   final isLoadingTables    = false.obs;
//   final isLoadingTimings   = false.obs;
//   final isLoadingMenuItems = false.obs;
//   final isUpdatingTable    = false.obs;
//   final isUpdatingTimings  = false.obs;
//   final isUpdatingMenuItem = false.obs;
//
//   // ── Data ────────────────────────────────────────────────────────────────────
//   final tables    = <RestaurantTableModel>[].obs;
//   final timings   = <MealTimingModel>[].obs;
//   final menuItems = <MenuItemModel>[].obs;
//
//   final selectedTable    = Rxn<RestaurantTableModel>();
//   final selectedMenuItem = Rxn<MenuItemModel>();
//
//   // ── Table edit controllers ──────────────────────────────────────────────────
//   final tableTypeCtrl     = TextEditingController();
//   final capacityRangeCtrl = TextEditingController();
//   final tableNameCtrl     = TextEditingController();
//   final seatingTypeEdit   = SeatingTypeUpdate.indoor.obs;
//
//   // ── Timing controllers ──────────────────────────────────────────────────────
//   final timingControllers = <String, Map<String, TextEditingController>>{};
//
//   // ── Menu item edit controllers ───────────────────────────────────────────────
//   final menuNameCtrl    = TextEditingController();
//   final menuPriceCtrl   = TextEditingController();
//   final menuDescCtrl    = TextEditingController();
//   final pickedMenuImage = Rxn<File>();
//
//   final _picker = ImagePicker();
//
//   final expandedMeals = <String, RxBool>{
//     'breakfast': false.obs,
//     'lunch':     false.obs,
//     'dinner':    false.obs,
//   };
//
//   // ── Auth Token ──────────────────────────────────────────────────────────────
//   String get authToken {
//     final token = _storage.read('auth_token') ?? '';
//     if (token.isEmpty) {
//       debugPrint('⚠️ WARNING: auth_token is empty in GetStorage');
//     } else {
//       debugPrint('✅ Auth token found: ${token.substring(0, token.length.clamp(0, 20))}...');
//     }
//     return token;
//   }
//
//   Map<String, String> get _authHeaders => {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $authToken',
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//     debugPrint('🚀 RestaurantMenuUpdateController init with restaurantId=$restaurantId');
//     fetchAll();
//   }
//
//   @override
//   void onClose() {
//     tableTypeCtrl.dispose();
//     capacityRangeCtrl.dispose();
//     tableNameCtrl.dispose();
//     menuNameCtrl.dispose();
//     menuPriceCtrl.dispose();
//     menuDescCtrl.dispose();
//     for (final m in timingControllers.values) {
//       m['start']?.dispose();
//       m['end']?.dispose();
//     }
//     super.onClose();
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // FETCH
//   // ═══════════════════════════════════════════════════════════════════════════
//
//   Future<void> fetchAll() async {
//     await Future.wait([
//       fetchTables(),
//       fetchTimings(),
//       fetchMenuItems(),
//     ]);
//   }
//
//   Future<void> fetchTables() async {
//     try {
//       isLoadingTables.value = true;
//       debugPrint('📡 Fetching tables for restaurantId=$restaurantId...');
//
//       final res = await http.post(
//         Uri.parse('$_baseUrl/restaurant-tables'),
//         headers: _authHeaders,
//         body: jsonEncode({'restaurant_id': restaurantId}),
//       );
//
//       debugPrint('📥 Tables status: ${res.statusCode}');
//       debugPrint('📥 Tables body: ${res.body}');
//
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         final List raw = body['data'] ?? [];
//         debugPrint('📦 Total tables from API: ${raw.length}');
//         tables.value = raw.map((e) => RestaurantTableModel.fromJson(e)).toList();
//         debugPrint('✅ Tables loaded: ${tables.length}');
//       } else {
//         debugPrint('❌ Tables failed: ${res.statusCode} ${res.body}');
//         _snack('Error', 'Failed to load tables (${res.statusCode})');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Tables exception: $e\n$stack');
//       _snack('Error', 'Tables: $e');
//     } finally {
//       isLoadingTables.value = false;
//     }
//   }
//
//   Future<void> fetchTimings() async {
//     try {
//       isLoadingTimings.value = true;
//       debugPrint('📡 Fetching timings for restaurantId=$restaurantId...');
//
//       final res = await http.post(
//         Uri.parse('$_baseUrl/meal-timings'),
//         headers: _authHeaders,
//         body: jsonEncode({'restaurant_id': restaurantId}),
//       );
//
//       debugPrint('📥 Timings status: ${res.statusCode}');
//       debugPrint('📥 Timings body: ${res.body}');
//
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         final List raw = body['data'] ?? [];
//         debugPrint('📦 Total timings from API: ${raw.length}');
//         timings.value = raw.map((e) => MealTimingModel.fromJson(e)).toList();
//         debugPrint('✅ Timings loaded: ${timings.length}');
//         _initTimingControllers();
//       } else {
//         debugPrint('❌ Timings failed: ${res.statusCode} ${res.body}');
//         _snack('Error', 'Failed to load timings (${res.statusCode})');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Timings exception: $e\n$stack');
//       _snack('Error', 'Timings: $e');
//     } finally {
//       isLoadingTimings.value = false;
//     }
//   }
//
//   Future<void> fetchMenuItems() async {
//     try {
//       isLoadingMenuItems.value = true;
//       debugPrint('📡 Fetching menu items for restaurantId=$restaurantId...');
//
//       final res = await http.post(
//         Uri.parse('$_baseUrl/menu-items'),
//         headers: _authHeaders,
//         body: jsonEncode({'restaurant_id': restaurantId}),
//       );
//
//       debugPrint('📥 Menu status: ${res.statusCode}');
//       debugPrint('📥 Menu body: ${res.body}');
//
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         final List raw = body['data'] ?? [];
//         debugPrint('📦 Total menu items from API: ${raw.length}');
//         menuItems.value = raw.map((e) => MenuItemModel.fromJson(e)).toList();
//         debugPrint('✅ Menu items loaded: ${menuItems.length}');
//       } else {
//         debugPrint('❌ Menu failed: ${res.statusCode} ${res.body}');
//         _snack('Error', 'Failed to load menu items (${res.statusCode})');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Menu exception: $e\n$stack');
//       _snack('Error', 'Menu: $e');
//     } finally {
//       isLoadingMenuItems.value = false;
//     }
//   }
//
//   void _initTimingControllers() {
//     for (final t in timings) {
//       if (!timingControllers.containsKey(t.mealType)) {
//         timingControllers[t.mealType] = {
//           'start': TextEditingController(text: t.startTime),
//           'end':   TextEditingController(text: t.endTime),
//         };
//       } else {
//         timingControllers[t.mealType]!['start']!.text = t.startTime;
//         timingControllers[t.mealType]!['end']!.text   = t.endTime;
//       }
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TABLE UPDATE
//   // ═══════════════════════════════════════════════════════════════════════════
//
//   void selectTableForEdit(RestaurantTableModel table) {
//     selectedTable.value    = table;
//     tableTypeCtrl.text     = table.tableType;
//     capacityRangeCtrl.text = table.capacityRange;
//     tableNameCtrl.text     = table.tableName;
//     seatingTypeEdit.value  = SeatingTypeUpdate.values.firstWhere(
//           (e) => e.name == table.seatingType,
//       orElse: () => SeatingTypeUpdate.indoor,
//     );
//   }
//
//   Future<void> updateTable() async {
//     final t = selectedTable.value;
//     if (t == null) return;
//
//     if (tableTypeCtrl.text.trim().isEmpty ||
//         capacityRangeCtrl.text.trim().isEmpty ||
//         tableNameCtrl.text.trim().isEmpty) {
//       _snack('Validation', 'Please fill all table fields');
//       return;
//     }
//
//     try {
//       isUpdatingTable.value = true;
//
//       t.tableType     = tableTypeCtrl.text.trim();
//       t.capacityRange = capacityRangeCtrl.text.trim();
//       t.tableName     = tableNameCtrl.text.trim();
//       t.seatingType   = seatingTypeEdit.value.name;
//
//       // Ensure restaurantId is injected into the update payload
//       final payload = {
//         ...t.toUpdateJson(),
//         'restaurant_id': restaurantId,
//       };
//
//       debugPrint('📡 Updating table: ${jsonEncode(payload)}');
//
//       final res = await http.put(
//         Uri.parse('$_baseUrl/edit-restaurant-table'),
//         headers: _authHeaders,
//         body: jsonEncode(payload),
//       );
//
//       debugPrint('📥 Update table status: ${res.statusCode} body: ${res.body}');
//
//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200 && body['status'] == '1') {
//         final idx = tables.indexWhere((tb) => tb.id == t.id);
//         if (idx >= 0) tables[idx] = t;
//         tables.refresh();
//         selectedTable.value = null;
//         _snack('Success', body['message'] ?? 'Table updated', isError: false);
//       } else {
//         _snack('Error', body['message'] ?? 'Update failed');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Table update exception: $e\n$stack');
//       _snack('Error', 'Table update: $e');
//     } finally {
//       isUpdatingTable.value = false;
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TIMING UPDATE
//   // ═══════════════════════════════════════════════════════════════════════════
//
//   Future<void> updateTimings() async {
//     if (timings.isEmpty) {
//       _snack('Info', 'No timings to update');
//       return;
//     }
//
//     final payload = timings.map((t) {
//       final ctrlMap = timingControllers[t.mealType];
//       return {
//         'id':         t.id,
//         'meal_type':  t.mealType,
//         'start_time': ctrlMap?['start']?.text ?? t.startTime,
//         'end_time':   ctrlMap?['end']?.text   ?? t.endTime,
//       };
//     }).toList();
//
//     try {
//       isUpdatingTimings.value = true;
//
//       debugPrint('📡 Updating timings: ${jsonEncode(payload)}');
//
//       final res = await http.post(
//         Uri.parse('$_baseUrl/meal-timings/update'),
//         headers: _authHeaders,
//         body: jsonEncode({
//           'restaurant_id': restaurantId,
//           'meal_timings':  payload,
//         }),
//       );
//
//       debugPrint('📥 Update timings status: ${res.statusCode} body: ${res.body}');
//
//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200 && body['status'] == '1') {
//         _snack('Success', 'Timings updated successfully', isError: false);
//         await fetchTimings();
//       } else {
//         _snack('Error', body['message'] ?? 'Timing update failed');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Timing update exception: $e\n$stack');
//       _snack('Error', 'Timing update: $e');
//     } finally {
//       isUpdatingTimings.value = false;
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // MENU ITEM UPDATE
//   // ═══════════════════════════════════════════════════════════════════════════
//
//   void selectMenuItemForEdit(MenuItemModel item) {
//     selectedMenuItem.value = item;
//     menuNameCtrl.text      = item.foodName;
//     menuPriceCtrl.text     = item.price.toStringAsFixed(2);
//     menuDescCtrl.text      = item.shortDescription;
//     pickedMenuImage.value  = null;
//   }
//
//   Future<void> pickMenuImage() async {
//     final xf = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (xf != null) pickedMenuImage.value = File(xf.path);
//   }
//
//   Future<void> updateMenuItem() async {
//     final item = selectedMenuItem.value;
//     if (item == null) return;
//
//     if (menuNameCtrl.text.trim().isEmpty || menuPriceCtrl.text.trim().isEmpty) {
//       _snack('Validation', 'Name and price are required');
//       return;
//     }
//
//     try {
//       isUpdatingMenuItem.value = true;
//
//       item.foodName         = menuNameCtrl.text.trim();
//       item.price            = double.tryParse(menuPriceCtrl.text.trim()) ?? item.price;
//       item.shortDescription = menuDescCtrl.text.trim();
//
//       http.Response? res;
//
//       if (pickedMenuImage.value != null) {
//         final req = http.MultipartRequest(
//           'POST',
//           Uri.parse('$_baseUrl/restaurant/menu-item/update'),
//         )
//           ..headers.addAll({'Authorization': 'Bearer $authToken'})
//           ..fields.addAll({
//             'id':                item.id.toString(),
//             'restaurant_id':     restaurantId.toString(),
//             'meal_type':         item.mealType,
//             'food_name':         item.foodName,
//             'price':             item.price.toString(),
//             'short_description': item.shortDescription,
//           })
//           ..files.add(await http.MultipartFile.fromPath(
//             'image',
//             pickedMenuImage.value!.path,
//           ));
//
//         debugPrint('📡 Updating menu item with image...');
//         final streamed = await req.send();
//         res = await http.Response.fromStream(streamed);
//       } else {
//         final payload = {
//           ...item.toUpdateJson(),
//           'restaurant_id': restaurantId,
//         };
//         debugPrint('📡 Updating menu item: ${jsonEncode(payload)}');
//         res = await http.post(
//           Uri.parse('$_baseUrl/restaurant/menu-item/update'),
//           headers: _authHeaders,
//           body: jsonEncode(payload),
//         );
//       }
//
//       debugPrint('📥 Update menu item status: ${res.statusCode} body: ${res.body}');
//
//       final body = jsonDecode(res.body);
//       if ((res.statusCode == 200 || res.statusCode == 201) && body['status'] == '1') {
//         final idx = menuItems.indexWhere((m) => m.id == item.id);
//         if (idx >= 0) menuItems[idx] = item;
//         menuItems.refresh();
//         selectedMenuItem.value = null;
//         pickedMenuImage.value  = null;
//         _snack('Success', body['message'] ?? 'Menu item updated', isError: false);
//       } else {
//         _snack('Error', body['message'] ?? 'Menu update failed');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Menu item update exception: $e\n$stack');
//       _snack('Error', 'Menu item update: $e');
//     } finally {
//       isUpdatingMenuItem.value = false;
//     }
//   }
//
//   void clearMenuItemSelection() {
//     selectedMenuItem.value = null;
//     pickedMenuImage.value  = null;
//     menuNameCtrl.clear();
//     menuPriceCtrl.clear();
//     menuDescCtrl.clear();
//   }
//
//   void clearTableSelection() {
//     selectedTable.value = null;
//     tableTypeCtrl.clear();
//     capacityRangeCtrl.clear();
//     tableNameCtrl.clear();
//   }
//
//   // ── Helpers ────────────────────────────────────────────────────────────────
//   List<MenuItemModel> getMenuItemsByMeal(String mealType) =>
//       menuItems.where((m) => m.mealType == mealType).toList();
//
//   MealTimingModel? getTimingByMeal(String mealType) =>
//       timings.firstWhereOrNull((t) => t.mealType == mealType);
//
//   void _snack(String title, String msg, {bool isError = true}) {
//     Get.snackbar(
//       title,
//       msg,
//       backgroundColor: isError ? const Color(0xFFE05252) : const Color(0xFF1DA87A),
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//       margin: const EdgeInsets.all(16),
//       borderRadius: 12,
//       duration: const Duration(seconds: 3),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../data/models/admin_restarant_menuupdatemodel.dart';

const _baseUrl = 'https://rasma.astradevelops.in/e_shoppyy/public/api';

enum SeatingTypeUpdate { indoor, outdoor }

class RestaurantMenuUpdateController extends GetxController {
  final int restaurantId;

  RestaurantMenuUpdateController({required this.restaurantId});

  final _storage = GetStorage();

  // ── Loading States ──────────────────────────────────────────────────────────
  final isLoadingTables    = false.obs;
  final isLoadingTimings   = false.obs;
  final isLoadingMenuItems = false.obs;
  final isUpdatingTable    = false.obs;
  final isUpdatingTimings  = false.obs;
  final isUpdatingMenuItem = false.obs;

  // ── Data ────────────────────────────────────────────────────────────────────
  final tables    = <RestaurantTableModel>[].obs;
  final timings   = <MealTimingModel>[].obs;
  final menuItems = <MenuItemModel>[].obs;

  final selectedTable    = Rxn<RestaurantTableModel>();
  final selectedMenuItem = Rxn<MenuItemModel>();

  // ── Table edit controllers ──────────────────────────────────────────────────
  final tableTypeCtrl     = TextEditingController();
  final capacityRangeCtrl = TextEditingController();
  final tableNameCtrl     = TextEditingController();
  final seatingTypeEdit   = SeatingTypeUpdate.indoor.obs;

  // ── Timing controllers ──────────────────────────────────────────────────────
  final timingControllers = <String, Map<String, TextEditingController>>{};

  // ── Menu item edit controllers ───────────────────────────────────────────────
  final menuNameCtrl    = TextEditingController();
  final menuPriceCtrl   = TextEditingController();
  final menuDescCtrl    = TextEditingController();
  final pickedMenuImage = Rxn<File>();

  final _picker = ImagePicker();

  final expandedMeals = <String, RxBool>{
    'breakfast': false.obs,
    'lunch':     false.obs,
    'dinner':    false.obs,
  };

  // ── Auth Token ──────────────────────────────────────────────────────────────
  String get authToken {
    final token = _storage.read('auth_token') ?? '';
    if (token.isEmpty) debugPrint('⚠️ auth_token is empty');
    return token;
  }

  Map<String, String> get _jsonHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 MenuUpdateController init — restaurantId=$restaurantId');
    fetchAll();
  }

  @override
  void onClose() {
    tableTypeCtrl.dispose();
    capacityRangeCtrl.dispose();
    tableNameCtrl.dispose();
    menuNameCtrl.dispose();
    menuPriceCtrl.dispose();
    menuDescCtrl.dispose();
    for (final m in timingControllers.values) {
      m['start']?.dispose();
      m['end']?.dispose();
    }
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FETCH  (all use POST with restaurant_id body)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> fetchAll() async {
    await Future.wait([fetchTables(), fetchTimings(), fetchMenuItems()]);
  }

  Future<void> fetchTables() async {
    try {
      isLoadingTables.value = true;
      final res = await http.post(
        Uri.parse('$_baseUrl/restaurant-tables'),
        headers: _jsonHeaders,
        body: jsonEncode({'restaurant_id': restaurantId}),
      );
      debugPrint('📥 Tables [${res.statusCode}]: ${res.body}');
      if (res.statusCode == 200 && _isJson(res.body)) {
        final raw = (jsonDecode(res.body)['data'] ?? []) as List;
        tables.value = raw.map((e) => RestaurantTableModel.fromJson(e)).toList();
      } else {
        _snack('Error', 'Failed to load tables (${res.statusCode})');
      }
    } catch (e) {
      _snack('Error', 'Tables: $e');
    } finally {
      isLoadingTables.value = false;
    }
  }

  Future<void> fetchTimings() async {
    try {
      isLoadingTimings.value = true;
      final res = await http.post(
        Uri.parse('$_baseUrl/meal-timings'),
        headers: _jsonHeaders,
        body: jsonEncode({'restaurant_id': restaurantId}),
      );
      debugPrint('📥 Timings [${res.statusCode}]: ${res.body}');
      if (res.statusCode == 200 && _isJson(res.body)) {
        final raw = (jsonDecode(res.body)['data'] ?? []) as List;
        timings.value = raw.map((e) => MealTimingModel.fromJson(e)).toList();
        _initTimingControllers();
      } else {
        _snack('Error', 'Failed to load timings (${res.statusCode})');
      }
    } catch (e) {
      _snack('Error', 'Timings: $e');
    } finally {
      isLoadingTimings.value = false;
    }
  }

  Future<void> fetchMenuItems() async {
    try {
      isLoadingMenuItems.value = true;
      final res = await http.post(
        Uri.parse('$_baseUrl/menu-items'),
        headers: _jsonHeaders,
        body: jsonEncode({'restaurant_id': restaurantId}),
      );
      debugPrint('📥 Menu [${res.statusCode}]: ${res.body}');
      if (res.statusCode == 200 && _isJson(res.body)) {
        final raw = (jsonDecode(res.body)['data'] ?? []) as List;
        menuItems.value = raw.map((e) => MenuItemModel.fromJson(e)).toList();
      } else {
        _snack('Error', 'Failed to load menu items (${res.statusCode})');
      }
    } catch (e) {
      _snack('Error', 'Menu: $e');
    } finally {
      isLoadingMenuItems.value = false;
    }
  }

  void _initTimingControllers() {
    for (final t in timings) {
      if (!timingControllers.containsKey(t.mealType)) {
        timingControllers[t.mealType] = {
          'start': TextEditingController(text: t.startTime),
          'end':   TextEditingController(text: t.endTime),
        };
      } else {
        timingControllers[t.mealType]!['start']!.text = t.startTime;
        timingControllers[t.mealType]!['end']!.text   = t.endTime;
      }
    }
  }



  void selectTableForEdit(RestaurantTableModel table) {
    selectedTable.value    = table;
    tableTypeCtrl.text     = table.tableType;
    capacityRangeCtrl.text = table.capacityRange;
    tableNameCtrl.text     = table.tableName;
    seatingTypeEdit.value  = SeatingTypeUpdate.values.firstWhere(
          (e) => e.name == table.seatingType,
      orElse: () => SeatingTypeUpdate.indoor,
    );
  }

  Future<void> updateTable() async {
    final t = selectedTable.value;
    if (t == null) return;

    if (tableTypeCtrl.text.trim().isEmpty ||
        capacityRangeCtrl.text.trim().isEmpty ||
        tableNameCtrl.text.trim().isEmpty) {
      _snack('Validation', 'Please fill all table fields');
      return;
    }

    try {
      isUpdatingTable.value = true;

      final payload = {
        'table_id':       t.id,           // ← "table_id" as per API spec
        'restaurant_id':  restaurantId,
        'table_type':     tableTypeCtrl.text.trim(),
        'capacity_range': capacityRangeCtrl.text.trim(),
        'table_name':     tableNameCtrl.text.trim(),
        'seating_type':   seatingTypeEdit.value.name,
      };

      debugPrint('📡 PUT /edit-restaurant-table: ${jsonEncode(payload)}');

      final res = await http.put(
        Uri.parse('$_baseUrl/edit-restaurant-table'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );

      debugPrint('📥 Table update [${res.statusCode}]: ${res.body}');

      if (!_isJson(res.body)) {
        _snack('Server Error', 'Unexpected server response (${res.statusCode})');
        return;
      }

      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body['status'] == '1') {
        t.tableType     = tableTypeCtrl.text.trim();
        t.capacityRange = capacityRangeCtrl.text.trim();
        t.tableName     = tableNameCtrl.text.trim();
        t.seatingType   = seatingTypeEdit.value.name;
        final idx = tables.indexWhere((tb) => tb.id == t.id);
        if (idx >= 0) tables[idx] = t;
        tables.refresh();
        selectedTable.value = null;
        _snack('Success', body['message'] ?? 'Table updated', isError: false);
      } else {
        _snack('Error', body['message'] ?? 'Table update failed');
      }
    } catch (e, stack) {
      debugPrint('❌ Table update: $e\n$stack');
      _snack('Error', 'Table update: $e');
    } finally {
      isUpdatingTable.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TIMING UPDATE — POST /meal-timings/update
  // ═══════════════════════════════════════════════════════════════════════════
// Replace ONLY the updateTimings method in your RestaurantMenuUpdateController
// Also add _trimTime helper at the bottom of the class

  Future<void> updateTimings() async {
    if (timings.isEmpty) {
      _snack('Info', 'No timings to update');
      return;
    }

    try {
      isUpdatingTimings.value = true;

      final payload = timings.map((t) {
        final ctrlMap = timingControllers[t.mealType];
        final startRaw = ctrlMap?['start']?.text ?? t.startTime;
        final endRaw   = ctrlMap?['end']?.text   ?? t.endTime;

        return {
          'id':         int.tryParse(t.id.toString()) ?? t.id, // int not String
          'meal_type':  t.mealType,
          'start_time': _trimTime(startRaw), // "08:00:00" → "08:00"
          'end_time':   _trimTime(endRaw),   // "08:00:00" → "08:00"
        };
      }).toList();

      final body = {
        'restaurant_id': restaurantId, // already int from constructor
        'meal_timings':  payload,
      };

      debugPrint('📤 POST /meal-timings/update body: ${jsonEncode(body)}');

      final res = await http.post(
        Uri.parse('$_baseUrl/meal-timings/update'),
        headers: _jsonHeaders,
        body: jsonEncode(body),
      );

      debugPrint('📥 Timings update [${res.statusCode}]: ${res.body}');

      if (!_isJson(res.body)) {
        debugPrint('❌ Non-JSON: ${res.body.substring(0, res.body.length.clamp(0, 300))}');
        _snack('Server Error', 'Unexpected server response (${res.statusCode})');
        return;
      }

      final resBody = jsonDecode(res.body);
      if (res.statusCode == 200 && resBody['status'] == '1') {
        _snack('Success', 'Timings updated successfully', isError: false);
        await fetchTimings();
      } else {
        _snack('Error', resBody['message'] ?? 'Timing update failed');
      }
    } catch (e, stack) {
      debugPrint('❌ Timing update: $e\n$stack');
      _snack('Error', 'Timing update: $e');
    } finally {
      isUpdatingTimings.value = false;
    }
  }

  // Strips seconds from time string: "08:00:00" → "08:00", "08:00" → "08:00"
  String _trimTime(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return time;
  }

  void selectMenuItemForEdit(MenuItemModel item) {
    selectedMenuItem.value = item;
    menuNameCtrl.text      = item.foodName;
    menuPriceCtrl.text     = item.price.toStringAsFixed(2);
    menuDescCtrl.text      = item.shortDescription;
    pickedMenuImage.value  = null;
  }

  Future<void> pickMenuImage() async {
    final xf = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (xf != null) pickedMenuImage.value = File(xf.path);
  }

  Future<void> updateMenuItem() async {
    final item = selectedMenuItem.value;
    if (item == null) return;

    if (menuNameCtrl.text.trim().isEmpty || menuPriceCtrl.text.trim().isEmpty) {
      _snack('Validation', 'Name and price are required');
      return;
    }

    try {
      isUpdatingMenuItem.value = true;

      final payload = <String, dynamic>{
        'id':                item.id,
        'restaurant_id':     restaurantId,
        'meal_type':         item.mealType,
        'food_name':         menuNameCtrl.text.trim(),
        'price':             double.tryParse(menuPriceCtrl.text.trim()) ?? item.price,
        'short_description': menuDescCtrl.text.trim(),
      };

      // If image picked, encode as base64 and add to payload
      if (pickedMenuImage.value != null) {
        final bytes = await pickedMenuImage.value!.readAsBytes();
        payload['image'] = base64Encode(bytes);
        debugPrint('📡 PUT /restaurant/menu-item/update (with base64 image)');
      } else {
        debugPrint('📡 PUT /restaurant/menu-item/update (no image)');
      }

      debugPrint('📦 Payload keys: ${payload.keys.toList()}');

      final res = await http.put(
        Uri.parse('$_baseUrl/restaurant/menu-item/update'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );

      debugPrint('📥 Menu item update [${res.statusCode}]: ${res.body}');

      if (!_isJson(res.body)) {
        debugPrint('❌ Non-JSON response: ${res.body.substring(0, res.body.length.clamp(0, 300))}');
        _snack('Server Error', 'Unexpected server response (${res.statusCode})');
        return;
      }

      final body = jsonDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201) && body['status'] == '1') {
        // Replace local item with fresh data from response
        final updated = MenuItemModel.fromJson(body['data']);
        final idx = menuItems.indexWhere((m) => m.id == item.id);
        if (idx >= 0) menuItems[idx] = updated;
        menuItems.refresh();
        selectedMenuItem.value = null;
        pickedMenuImage.value  = null;
        _snack('Success', body['message'] ?? 'Menu item updated', isError: false);
      } else {
        _snack('Error', body['message'] ?? 'Menu update failed (${res.statusCode})');
      }
    } catch (e, stack) {
      debugPrint('❌ Menu item update: $e\n$stack');
      _snack('Error', 'Menu item update: $e');
    } finally {
      isUpdatingMenuItem.value = false;
    }
  }

  // ── Clear selections ────────────────────────────────────────────────────────
  void clearMenuItemSelection() {
    selectedMenuItem.value = null;
    pickedMenuImage.value  = null;
    menuNameCtrl.clear();
    menuPriceCtrl.clear();
    menuDescCtrl.clear();
  }

  void clearTableSelection() {
    selectedTable.value = null;
    tableTypeCtrl.clear();
    capacityRangeCtrl.clear();
    tableNameCtrl.clear();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  List<MenuItemModel> getMenuItemsByMeal(String mealType) =>
      menuItems.where((m) => m.mealType == mealType).toList();

  MealTimingModel? getTimingByMeal(String mealType) =>
      timings.firstWhereOrNull((t) => t.mealType == mealType);

  bool _isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _snack(String title, String msg, {bool isError = true}) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: isError ? const Color(0xFFE05252) : const Color(0xFF1DA87A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}