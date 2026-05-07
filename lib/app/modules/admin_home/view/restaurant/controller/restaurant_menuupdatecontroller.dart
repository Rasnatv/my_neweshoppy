//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../../data/errors/api_error.dart';
// import '../../../../../data/models/admin_restarant_menuupdatemodel.dart';
// import '../../../../merchantlogin/widget/successwidget.dart';
//
//
// const _baseUrl = 'https://eshoppy.co.in/api';
//
// enum SeatingTypeUpdate { indoor, outdoor }
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
//   // ── Auth ────────────────────────────────────────────────────────────────────
//   String get authToken {
//     final token = _storage.read('auth_token') ?? '';
//     if (token.isEmpty) debugPrint('⚠️ auth_token is empty');
//     return token;
//   }
//
//   Map<String, String> get _jsonHeaders => {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $authToken',
//   };
//
//   // ── Lifecycle ───────────────────────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     debugPrint('🚀 MenuUpdateController init — restaurantId=$restaurantId');
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
//       m['break']?.dispose();
//     }
//     super.onClose();
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // FETCH
//   // ═══════════════════════════════════════════════════════════════════════════
//
//   Future<void> fetchAll() async {
//     await Future.wait([fetchTables(), fetchTimings(), fetchMenuItems()]);
//   }
//
//   Future<void> fetchTables() async {
//     try {
//       isLoadingTables.value = true;
//       final res = await http.post(
//         Uri.parse('$_baseUrl/restaurant-tables'),
//         headers: _jsonHeaders,
//         body: jsonEncode({'restaurant_id': restaurantId}),
//       );
//       debugPrint('📥 Tables [${res.statusCode}]: ${res.body}');
//
//       if (res.statusCode == 200 && _isJson(res.body)) {
//         final raw = (jsonDecode(res.body)['data'] ?? []) as List;
//         tables.value = raw.map((e) => RestaurantTableModel.fromJson(e)).toList();
//       } else {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(res));
//       }
//     }  catch (e) {
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//     } finally {
//       isLoadingTables.value = false;
//     }
//   }
//
//   Future<void> fetchTimings() async {
//     try {
//       isLoadingTimings.value = true;
//       final res = await http.post(
//         Uri.parse('$_baseUrl/meal-timings'),
//         headers: _jsonHeaders,
//         body: jsonEncode({'restaurant_id': restaurantId}),
//       );
//       debugPrint('📥 Timings [${res.statusCode}]: ${res.body}');
//
//       if (res.statusCode == 200 && _isJson(res.body)) {
//         final raw = (jsonDecode(res.body)['data'] ?? []) as List;
//         timings.value = raw.map((e) => MealTimingModel.fromJson(e)).toList();
//         _reinitTimingControllers();
//       } else {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(res));
//       }
//     } catch (e) {
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//     } finally {
//       isLoadingTimings.value = false;
//     }
//   }
//
//   Future<void> fetchMenuItems() async {
//     try {
//       isLoadingMenuItems.value = true;
//       final res = await http.post(
//         Uri.parse('$_baseUrl/menu-items'),
//         headers: _jsonHeaders,
//         body: jsonEncode({'restaurant_id': restaurantId}),
//       );
//       debugPrint('📥 Menu [${res.statusCode}]: ${res.body}');
//
//       if (res.statusCode == 200 && _isJson(res.body)) {
//         final raw = (jsonDecode(res.body)['data'] ?? []) as List;
//         menuItems.value = raw.map((e) => MenuItemModel.fromJson(e)).toList();
//       } else {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(res));
//       }
//     }  catch (e) {
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//     } finally {
//       isLoadingMenuItems.value = false;
//     }
//   }
//
//   // ── Re-init timing controllers ───────────────────────────────────────────────
//   void _reinitTimingControllers() {
//     for (final t in timings) {
//       if (!timingControllers.containsKey(t.mealType)) {
//         timingControllers[t.mealType] = {
//           'start': TextEditingController(text: t.startTime),
//           'end':   TextEditingController(text: t.endTime),
//           'break': TextEditingController(
//               text: t.breakDuration > 0 ? t.breakDuration.toString() : ''),
//         };
//       } else {
//         timingControllers[t.mealType]!['start']!.text = t.startTime;
//         timingControllers[t.mealType]!['end']!.text   = t.endTime;
//         timingControllers[t.mealType]!['break']!.text =
//         t.breakDuration > 0 ? t.breakDuration.toString() : '';
//       }
//     }
//     debugPrint('🕐 Timing controllers synced: ${timingControllers.keys.toList()}');
//   }
//
//   // ── Time helpers ─────────────────────────────────────────────────────────────
//   String formatTimeTo12h(TimeOfDay time) {
//     final hour        = time.hour;
//     final minute      = time.minute.toString().padLeft(2, '0');
//     final period      = hour >= 12 ? 'PM' : 'AM';
//     final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
//     return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
//   }
//
//   TimeOfDay parseTimeToTimeOfDay(String timeStr) {
//     try {
//       final clean  = timeStr.trim().toUpperCase();
//       final isPM   = clean.contains('PM');
//       final isAM   = clean.contains('AM');
//       final noAmPm = clean.replaceAll('AM', '').replaceAll('PM', '').trim();
//       final parts  = noAmPm.split(':');
//       int   hour   = int.tryParse(parts[0]) ?? 0;
//       final minute = parts.length >= 2 ? (int.tryParse(parts[1]) ?? 0) : 0;
//       if (isPM && hour != 12) hour += 12;
//       if (isAM && hour == 12) hour = 0;
//       return TimeOfDay(hour: hour, minute: minute);
//     } catch (_) {
//       return TimeOfDay.now();
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TABLE CRUD
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
//   void clearTableSelection() {
//     selectedTable.value = null;
//     tableTypeCtrl.clear();
//     capacityRangeCtrl.clear();
//     tableNameCtrl.clear();
//   }
//
//   Future<void> updateTable() async {
//     final t = selectedTable.value;
//     if (t == null) return;
//
//     if (tableTypeCtrl.text.trim().isEmpty ||
//         capacityRangeCtrl.text.trim().isEmpty ||
//         tableNameCtrl.text.trim().isEmpty) {
//       AppSnackbar.warning('Please fill all table fields'); // ← warning for validation
//       return;
//     }
//
//     try {
//       isUpdatingTable.value = true;
//
//       final payload = {
//         'table_id':       t.id,
//         'restaurant_id':  restaurantId,
//         'table_type':     tableTypeCtrl.text.trim(),
//         'capacity_range': capacityRangeCtrl.text.trim(),
//         'table_name':     tableNameCtrl.text.trim(),
//         'seating_type':   seatingTypeEdit.value.name,
//       };
//
//       debugPrint('📡 PUT /edit-restaurant-table: ${jsonEncode(payload)}');
//
//       final res = await http.put(
//         Uri.parse('$_baseUrl/edit-restaurant-table'),
//         headers: _jsonHeaders,
//         body: jsonEncode(payload),
//       );
//
//       debugPrint('📥 Table update [${res.statusCode}]: ${res.body}');
//
//       if (!_isJson(res.body)) {
//         AppSnackbar.error('Unexpected response (${res.statusCode})');
//         return;
//       }
//
//       final body = jsonDecode(res.body);
//       if (res.statusCode == 200 && body['status'] == '1') {
//         t.tableType     = tableTypeCtrl.text.trim();
//         t.capacityRange = capacityRangeCtrl.text.trim();
//         t.tableName     = tableNameCtrl.text.trim();
//         t.seatingType   = seatingTypeEdit.value.name;
//         final idx = tables.indexWhere((tb) => tb.id == t.id);
//         if (idx >= 0) tables[idx] = t;
//         tables.refresh();
//         selectedTable.value = null;
//         AppSnackbar.success(body['message'] ?? 'Table updated');
//       } else {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(res));
//       }
//     }  catch (e, stack) {
//       debugPrint('❌ Table update: $e\n$stack');
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//     } finally {
//       isUpdatingTable.value = false;
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TIMING CRUD
//   // ═══════════════════════════════════════════════════════════════════════════
//
//   Future<void> updateTimings() async {
//     if (timings.isEmpty) {
//       AppSnackbar.warning('No timings to update');
//       return;
//     }
//
//     try {
//       isUpdatingTimings.value = true;
//
//       final payload = timings.map((t) {
//         final ctrlMap  = timingControllers[t.mealType];
//         final startVal = ctrlMap?['start']?.text.trim() ?? t.startTime;
//         final endVal   = ctrlMap?['end']?.text.trim()   ?? t.endTime;
//         final breakVal = int.tryParse(
//             ctrlMap?['break']?.text.trim() ?? '') ??
//             t.breakDuration;
//
//         return {
//           'id':             t.id.toString(),
//           'restaurant_id':  restaurantId.toString(),
//           'meal_type':      t.mealType,
//           'start_time':     startVal,
//           'end_time':       endVal,
//           'break_duration': breakVal,
//         };
//       }).toList();
//
//       final bodyMap = {
//         'restaurant_id': restaurantId,
//         'meal_timings':  payload,
//       };
//
//       debugPrint('📤 PUT /meal-timings/update: ${jsonEncode(bodyMap)}');
//
//       final res = await http.put(
//         Uri.parse('$_baseUrl/meal-timings/update'),
//         headers: _jsonHeaders,
//         body: jsonEncode(bodyMap),
//       );
//
//       debugPrint('📥 Timings update [${res.statusCode}]: ${res.body}');
//
//       if (!_isJson(res.body)) {
//         AppSnackbar.error('Unexpected response (${res.statusCode})');
//         return;
//       }
//
//       final resBody = jsonDecode(res.body);
//
//       if (res.statusCode == 200 && resBody['status'] == '1') {
//         final dataRaw = resBody['data'];
//         List<MealTimingModel> updatedList;
//
//         if (dataRaw is Map && dataRaw.containsKey('meal_timings')) {
//           updatedList = (dataRaw['meal_timings'] as List).map((e) {
//             final map = Map<String, dynamic>.from(e as Map);
//             map.putIfAbsent('restaurant_id', () => restaurantId.toString());
//             return MealTimingModel.fromJson(map);
//           }).toList();
//         } else if (dataRaw is List) {
//           updatedList = (dataRaw).map((e) {
//             final map = Map<String, dynamic>.from(e as Map);
//             map.putIfAbsent('restaurant_id', () => restaurantId.toString());
//             return MealTimingModel.fromJson(map);
//           }).toList();
//         } else {
//           debugPrint('⚠️ Unexpected data shape, re-fetching timings');
//           await fetchTimings();
//           AppSnackbar.success(resBody['message'] ?? 'Timings updated');
//           return;
//         }
//
//         timings.value = updatedList;
//         _reinitTimingControllers();
//         timings.refresh();
//         AppSnackbar.success(resBody['message'] ?? 'Timings updated');
//       } else {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(res));
//       }
//     }  catch (e, stack) {
//       debugPrint('❌ Timing update: $e\n$stack');
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//     } finally {
//       isUpdatingTimings.value = false;
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // MENU ITEM CRUD
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
//   void clearMenuItemSelection() {
//     selectedMenuItem.value = null;
//     pickedMenuImage.value  = null;
//     menuNameCtrl.clear();
//     menuPriceCtrl.clear();
//     menuDescCtrl.clear();
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
//       AppSnackbar.warning('Name and price are required'); // ← warning for validation
//       return;
//     }
//
//     try {
//       isUpdatingMenuItem.value = true;
//
//       final payload = <String, dynamic>{
//         'id':                item.id,
//         'restaurant_id':     restaurantId,
//         'meal_type':         item.mealType,
//         'food_name':         menuNameCtrl.text.trim(),
//         'price':             double.tryParse(menuPriceCtrl.text.trim()) ?? item.price,
//         'short_description': menuDescCtrl.text.trim(),
//       };
//
//       if (pickedMenuImage.value != null) {
//         final bytes = await pickedMenuImage.value!.readAsBytes();
//         final ext   = pickedMenuImage.value!.path.split('.').last.toLowerCase();
//         final mime  = ext == 'png' ? 'image/png' : 'image/jpeg';
//         payload['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
//         debugPrint('📡 PUT /restaurant/menu-item/update (with base64 image)');
//       } else {
//         debugPrint('📡 PUT /restaurant/menu-item/update (no image)');
//       }
//
//       final res = await http.put(
//         Uri.parse('$_baseUrl/restaurant/menu-item/update'),
//         headers: _jsonHeaders,
//         body: jsonEncode(payload),
//       );
//
//       debugPrint('📥 Menu item update [${res.statusCode}]: ${res.body}');
//
//       if (!_isJson(res.body)) {
//         AppSnackbar.error('Unexpected response (${res.statusCode})');
//         return;
//       }
//
//       final body = jsonDecode(res.body);
//       if ((res.statusCode == 200 || res.statusCode == 201) &&
//           body['status'] == '1') {
//         final updated = MenuItemModel.fromJson(body['data']);
//         final idx = menuItems.indexWhere((m) => m.id == item.id);
//         if (idx >= 0) menuItems[idx] = updated;
//         menuItems.refresh();
//         selectedMenuItem.value = null;
//         pickedMenuImage.value  = null;
//         AppSnackbar.success(body['message'] ?? 'Menu item updated');
//       } else {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(res));
//       }
//     }  catch (e, stack) {
//       debugPrint('❌ Menu item update: $e\n$stack');
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//     } finally {
//       isUpdatingMenuItem.value = false;
//     }
//   }
//
//   // ── Helpers ─────────────────────────────────────────────────────────────────
//   List<MenuItemModel> getMenuItemsByMeal(String mealType) =>
//       menuItems.where((m) => m.mealType == mealType).toList();
//
//   MealTimingModel? getTimingByMeal(String mealType) =>
//       timings.firstWhereOrNull((t) => t.mealType == mealType);
//
//   bool _isJson(String str) {
//     try {
//       jsonDecode(str);
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../data/errors/api_error.dart';
import '../../../../../data/models/admin_restarant_menuupdatemodel.dart';
import '../../../../merchantlogin/widget/successwidget.dart';

const _baseUrl = 'https://eshoppy.co.in/api';

enum SeatingTypeUpdate { indoor, outdoor }

/// Mode toggle for each tab — view/edit existing OR add new
enum TabMode { existing, addNew }

class RestaurantMenuUpdateController extends GetxController {
  final int restaurantId;
  RestaurantMenuUpdateController({required this.restaurantId});

  final _storage = GetStorage();

  // ── Tab Modes ────────────────────────────────────────────────────────────────
  final tableTabMode  = TabMode.existing.obs;
  final timingTabMode = TabMode.existing.obs;
  final menuTabMode   = TabMode.existing.obs;

  // ── Loading States ────────────────────────────────────────────────────────────
  final isLoadingTables    = false.obs;
  final isLoadingTimings   = false.obs;
  final isLoadingMenuItems = false.obs;
  final isUpdatingTable    = false.obs;
  final isUpdatingTimings  = false.obs;
  final isUpdatingMenuItem = false.obs;
  final isAddingTable      = false.obs;
  final isAddingTimings    = false.obs;
  final isAddingMenuItem   = false.obs;
  final isDeletingTiming   = false.obs;

  // ── Existing Data ─────────────────────────────────────────────────────────────
  final tables    = <RestaurantTableModel>[].obs;
  final timings   = <MealTimingModel>[].obs;
  final menuItems = <MenuItemModel>[].obs;

  // ── Selected items for editing ────────────────────────────────────────────────
  final selectedTable    = Rxn<RestaurantTableModel>();
  final selectedMenuItem = Rxn<MenuItemModel>();

  // ── TABLE — edit controllers ──────────────────────────────────────────────────
  final tableTypeCtrl     = TextEditingController();
  final capacityRangeCtrl = TextEditingController();
  final tableNameCtrl     = TextEditingController();
  final seatingTypeEdit   = SeatingTypeUpdate.indoor.obs;

  // ── TABLE — add controllers ───────────────────────────────────────────────────
  final addTableTypeCtrl     = TextEditingController();
  final addCapacityRangeCtrl = TextEditingController();
  final addTableIdsCtrl      = TextEditingController();
  final addSeatingType       = SeatingTypeUpdate.indoor.obs;

  // ── TIMING — existing edit controllers ───────────────────────────────────────
  final timingControllers = <String, Map<String, TextEditingController>>{};

  // ── TIMING — add new controllers ─────────────────────────────────────────────
  final addStartCtrl         = TextEditingController();
  final addEndCtrl           = TextEditingController();
  final addBreakCtrl         = TextEditingController();
  final addSelectedMeal      = 'breakfast'.obs;
  final RxMap<String, List<_PendingSlot>> pendingSlots =
      <String, List<_PendingSlot>>{}.obs;

  // ── MENU — edit controllers ───────────────────────────────────────────────────
  final menuNameCtrl    = TextEditingController();
  final menuPriceCtrl   = TextEditingController();
  final menuDescCtrl    = TextEditingController();
  final pickedMenuImage = Rxn<File>();

  // ── MENU — add new controllers (per meal) ────────────────────────────────────
  final Map<String, TextEditingController> addFoodNameCtrls    = {};
  final Map<String, TextEditingController> addFoodPriceCtrls   = {};
  final Map<String, TextEditingController> addFoodDescCtrls    = {};
  final Map<String, Rx<File?>>             addFoodImages       = {};

  // ── Expand/collapse for menu sections ────────────────────────────────────────
  final expandedMeals = <String, RxBool>{
    'breakfast': false.obs,
    'lunch':     false.obs,
    'dinner':    false.obs,
  };

  final _picker = ImagePicker();

  // ── Auth ──────────────────────────────────────────────────────────────────────
  String get authToken {
    final token = _storage.read('auth_token') ?? '';
    if (token.isEmpty) debugPrint('⚠️ auth_token is empty');
    return token;
  }

  Map<String, String> get _jsonHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  // ── Lifecycle ─────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    for (final m in ['breakfast', 'lunch', 'dinner']) {
      addFoodNameCtrls[m]  = TextEditingController();
      addFoodPriceCtrls[m] = TextEditingController();
      addFoodDescCtrls[m]  = TextEditingController();
      addFoodImages[m]     = Rx<File?>(null);
    }
    fetchAll();
  }

  @override
  void onClose() {
    tableTypeCtrl.dispose();
    capacityRangeCtrl.dispose();
    tableNameCtrl.dispose();
    addTableTypeCtrl.dispose();
    addCapacityRangeCtrl.dispose();
    addTableIdsCtrl.dispose();
    menuNameCtrl.dispose();
    menuPriceCtrl.dispose();
    menuDescCtrl.dispose();
    addStartCtrl.dispose();
    addEndCtrl.dispose();
    addBreakCtrl.dispose();
    for (final m in timingControllers.values) {
      m['start']?.dispose();
      m['end']?.dispose();
      m['break']?.dispose();
    }
    for (final m in ['breakfast', 'lunch', 'dinner']) {
      addFoodNameCtrls[m]?.dispose();
      addFoodPriceCtrls[m]?.dispose();
      addFoodDescCtrls[m]?.dispose();
    }
    super.onClose();
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // FETCH
  // ══════════════════════════════════════════════════════════════════════════════

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
      if (res.statusCode == 200 && _isJson(res.body)) {
        final raw = (jsonDecode(res.body)['data'] ?? []) as List;
        tables.value = raw.map((e) => RestaurantTableModel.fromJson(e)).toList();
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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
      if (res.statusCode == 200 && _isJson(res.body)) {
        final raw = (jsonDecode(res.body)['data'] ?? []) as List;
        timings.value = raw.map((e) => MealTimingModel.fromJson(e)).toList();
        _reinitTimingControllers();
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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
      if (res.statusCode == 200 && _isJson(res.body)) {
        final raw = (jsonDecode(res.body)['data'] ?? []) as List;
        menuItems.value = raw.map((e) => MenuItemModel.fromJson(e)).toList();
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingMenuItems.value = false;
    }
  }

  // ── Timing controller sync ────────────────────────────────────────────────────
  void _reinitTimingControllers() {
    for (final t in timings) {
      if (!timingControllers.containsKey(t.mealType)) {
        timingControllers[t.mealType] = {
          'start': TextEditingController(text: t.startTime),
          'end':   TextEditingController(text: t.endTime),
          'break': TextEditingController(
              text: t.breakDuration > 0 ? t.breakDuration.toString() : ''),
        };
      } else {
        timingControllers[t.mealType]!['start']!.text = t.startTime;
        timingControllers[t.mealType]!['end']!.text   = t.endTime;
        timingControllers[t.mealType]!['break']!.text =
        t.breakDuration > 0 ? t.breakDuration.toString() : '';
      }
    }
  }

  // ── Time helpers ──────────────────────────────────────────────────────────────
  String formatTimeTo12h(TimeOfDay time) {
    final hour        = time.hour;
    final minute      = time.minute.toString().padLeft(2, '0');
    final period      = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }

  TimeOfDay parseTimeToTimeOfDay(String timeStr) {
    try {
      final clean  = timeStr.trim().toUpperCase();
      final isPM   = clean.contains('PM');
      final isAM   = clean.contains('AM');
      final noAmPm = clean.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts  = noAmPm.split(':');
      int   hour   = int.tryParse(parts[0]) ?? 0;
      final minute = parts.length >= 2 ? (int.tryParse(parts[1]) ?? 0) : 0;
      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return TimeOfDay.now();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // TABLE — EDIT EXISTING
  // ══════════════════════════════════════════════════════════════════════════════

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

  void clearTableSelection() {
    selectedTable.value = null;
    tableTypeCtrl.clear();
    capacityRangeCtrl.clear();
    tableNameCtrl.clear();
  }

  Future<void> updateTable() async {
    final t = selectedTable.value;
    if (t == null) return;
    if (tableTypeCtrl.text.trim().isEmpty ||
        capacityRangeCtrl.text.trim().isEmpty ||
        tableNameCtrl.text.trim().isEmpty) {
      AppSnackbar.warning('Please fill all table fields');
      return;
    }
    try {
      isUpdatingTable.value = true;
      final payload = {
        'table_id':       t.id,
        'restaurant_id':  restaurantId,
        'table_type':     tableTypeCtrl.text.trim(),
        'capacity_range': capacityRangeCtrl.text.trim(),
        'table_name':     tableNameCtrl.text.trim(),
        'seating_type':   seatingTypeEdit.value.name,
      };
      final res = await http.put(
        Uri.parse('$_baseUrl/edit-restaurant-table'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );
      if (!_isJson(res.body)) {
        AppSnackbar.error('Unexpected response (${res.statusCode})');
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
        AppSnackbar.success(body['message'] ?? 'Table updated');
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdatingTable.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // TABLE — ADD NEW
  // ══════════════════════════════════════════════════════════════════════════════

  Future<void> submitAddTable() async {
    if (addTableTypeCtrl.text.trim().isEmpty ||
        addCapacityRangeCtrl.text.trim().isEmpty ||
        addTableIdsCtrl.text.trim().isEmpty) {
      AppSnackbar.warning('Please fill all table fields');
      return;
    }
    final normalizedIds = addTableIdsCtrl.text
        .split(',')
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .join(',');
    try {
      isAddingTable.value = true;
      final payload = {
        'restaurant_id':  restaurantId,
        'table_type':     addTableTypeCtrl.text.trim(),
        'capacity_range': addCapacityRangeCtrl.text.trim(),
        'table_name':     normalizedIds,
        'seating_type':   addSeatingType.value.name,
      };
      final res = await http.post(
        Uri.parse('$_baseUrl/add-restaurant-table'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );
      if (!_isJson(res.body)) {
        AppSnackbar.error('Unexpected response (${res.statusCode})');
        return;
      }
      final body = jsonDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          body['status'] == '1') {
        AppSnackbar.success('Table added successfully');
        addTableTypeCtrl.clear();
        addCapacityRangeCtrl.clear();
        addTableIdsCtrl.clear();
        await fetchTables();
      } else {
        AppSnackbar.warning(body['message']?.toString() ?? 'Failed to add table');
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isAddingTable.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // TIMING — EDIT EXISTING
  // ══════════════════════════════════════════════════════════════════════════════

  Future<void> updateTimings() async {
    if (timings.isEmpty) {
      AppSnackbar.warning('No timings to update');
      return;
    }
    try {
      isUpdatingTimings.value = true;
      final payload = timings.map((t) {
        final ctrlMap  = timingControllers[t.mealType];
        final startVal = ctrlMap?['start']?.text.trim() ?? t.startTime;
        final endVal   = ctrlMap?['end']?.text.trim()   ?? t.endTime;
        final breakVal = int.tryParse(
            ctrlMap?['break']?.text.trim() ?? '') ?? t.breakDuration;
        return {
          'id':             t.id.toString(),
          'restaurant_id':  restaurantId.toString(),
          'meal_type':      t.mealType,
          'start_time':     startVal,
          'end_time':       endVal,
          'break_duration': breakVal,
        };
      }).toList();
      final bodyMap = {'restaurant_id': restaurantId, 'meal_timings': payload};
      final res = await http.put(
        Uri.parse('$_baseUrl/meal-timings/update'),
        headers: _jsonHeaders,
        body: jsonEncode(bodyMap),
      );
      if (!_isJson(res.body)) {
        AppSnackbar.error('Unexpected response (${res.statusCode})');
        return;
      }
      final resBody = jsonDecode(res.body);
      if (res.statusCode == 200 && resBody['status'] == '1') {
        final dataRaw = resBody['data'];
        List<MealTimingModel> updatedList;
        if (dataRaw is Map && dataRaw.containsKey('meal_timings')) {
          updatedList = (dataRaw['meal_timings'] as List).map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            map.putIfAbsent('restaurant_id', () => restaurantId.toString());
            return MealTimingModel.fromJson(map);
          }).toList();
        } else if (dataRaw is List) {
          updatedList = (dataRaw).map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            map.putIfAbsent('restaurant_id', () => restaurantId.toString());
            return MealTimingModel.fromJson(map);
          }).toList();
        } else {
          await fetchTimings();
          AppSnackbar.success(resBody['message'] ?? 'Timings updated');
          return;
        }
        timings.value = updatedList;
        _reinitTimingControllers();
        timings.refresh();
        AppSnackbar.success(resBody['message'] ?? 'Timings updated');
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdatingTimings.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // TIMING — ADD NEW
  // ══════════════════════════════════════════════════════════════════════════════

  void addToPendingSlots() {
    if (addStartCtrl.text.isEmpty || addEndCtrl.text.isEmpty) {
      AppSnackbar.warning('Please select start and end time');
      return;
    }
    final meal = addSelectedMeal.value;
    final existingSaved = timings.where((t) => t.mealType == meal).toList();
    if (existingSaved.isNotEmpty) {
      AppSnackbar.warning(
        '${meal.capitalizeFirst} timing already saved. Update existing or delete first.',
      );
      return;
    }
    if (pendingSlots.containsKey(meal) && pendingSlots[meal]!.isNotEmpty) {
      AppSnackbar.warning('${meal.capitalizeFirst} already queued. Save first.');
      return;
    }
    final breakMins = int.tryParse(addBreakCtrl.text.trim()) ?? 0;
    pendingSlots.update(
      meal,
          (list) => [...list, _PendingSlot(addStartCtrl.text, addEndCtrl.text, breakMins)],
      ifAbsent: () => [_PendingSlot(addStartCtrl.text, addEndCtrl.text, breakMins)],
    );
    addStartCtrl.clear();
    addEndCtrl.clear();
    addBreakCtrl.clear();
    AppSnackbar.success('${meal.capitalizeFirst} slot queued. Tap Save to submit.');
  }

  Future<void> submitAddTimings() async {
    if (pendingSlots.isEmpty ||
        pendingSlots.values.every((v) => v.isEmpty)) {
      AppSnackbar.warning('No slots queued');
      return;
    }
    try {
      isAddingTimings.value = true;
      final timingsPayload = <Map<String, dynamic>>[];
      for (final entry in pendingSlots.entries) {
        for (final slot in entry.value) {
          timingsPayload.add({
            'meal_type':      entry.key,
            'start_time':     slot.start,
            'end_time':       slot.end,
            'break_duration': slot.breakMins,
          });
        }
      }
      final res = await http.post(
        Uri.parse('$_baseUrl/restaurant/meal-timings'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'restaurant_id': restaurantId,
          'meal_timings':  timingsPayload,
        }),
      );
      if (!_isJson(res.body)) {
        AppSnackbar.error('Unexpected response (${res.statusCode})');
        return;
      }
      final body = jsonDecode(res.body);
      if (res.statusCode == 409 || body['status_code']?.toString() == '409') {
        AppSnackbar.warning(
          (body['message']?.toString() ?? 'Timing already exists') +
              '\n\nUpdate or delete the existing slot first.',
        );
        return;
      }
      if (body['status'] == '1') {
        pendingSlots.clear();
        AppSnackbar.success('Meal timings saved successfully');
        await fetchTimings();
      } else {
        AppSnackbar.warning(body['message']?.toString() ?? 'Failed to save timings');
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isAddingTimings.value = false;
    }
  }

  Future<void> deleteTimingSlot(MealTimingModel timing) async {
    timings.remove(timing); // optimistic
    try {
      isDeletingTiming.value = true;
      final payload = {
        'restaurant_id': restaurantId,
        'meal_type':     timing.mealType,
        'id':            timing.id.toString(),
      };
      final res = await http.post(
        Uri.parse('$_baseUrl/restaurant/delete-meal-timing'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );
      final body = _isJson(res.body) ? jsonDecode(res.body) : {};
      if (body['status'] == '1') {
        AppSnackbar.success('${timing.mealType.capitalizeFirst} timing deleted');
        _reinitTimingControllers();
      } else {
        timings.add(timing); // rollback
        AppSnackbar.error(body['message']?.toString() ?? 'Failed to delete');
      }
    } catch (e) {
      timings.add(timing); // rollback
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDeletingTiming.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // MENU ITEM — EDIT EXISTING
  // ══════════════════════════════════════════════════════════════════════════════

  void selectMenuItemForEdit(MenuItemModel item) {
    selectedMenuItem.value = item;
    menuNameCtrl.text      = item.foodName;
    menuPriceCtrl.text     = item.price.toStringAsFixed(2);
    menuDescCtrl.text      = item.shortDescription;
    pickedMenuImage.value  = null;
  }

  void clearMenuItemSelection() {
    selectedMenuItem.value = null;
    pickedMenuImage.value  = null;
    menuNameCtrl.clear();
    menuPriceCtrl.clear();
    menuDescCtrl.clear();
  }

  Future<void> pickMenuImage() async {
    final xf = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (xf != null) pickedMenuImage.value = File(xf.path);
  }

  Future<void> updateMenuItem() async {
    final item = selectedMenuItem.value;
    if (item == null) return;
    if (menuNameCtrl.text.trim().isEmpty || menuPriceCtrl.text.trim().isEmpty) {
      AppSnackbar.warning('Name and price are required');
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
      if (pickedMenuImage.value != null) {
        final bytes = await pickedMenuImage.value!.readAsBytes();
        final ext   = pickedMenuImage.value!.path.split('.').last.toLowerCase();
        final mime  = ext == 'png' ? 'image/png' : 'image/jpeg';
        payload['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
      }
      final res = await http.put(
        Uri.parse('$_baseUrl/restaurant/menu-item/update'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );
      if (!_isJson(res.body)) {
        AppSnackbar.error('Unexpected response (${res.statusCode})');
        return;
      }
      final body = jsonDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          body['status'] == '1') {
        final updated = MenuItemModel.fromJson(body['data']);
        final idx = menuItems.indexWhere((m) => m.id == item.id);
        if (idx >= 0) menuItems[idx] = updated;
        menuItems.refresh();
        selectedMenuItem.value = null;
        pickedMenuImage.value  = null;
        AppSnackbar.success(body['message'] ?? 'Menu item updated');
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdatingMenuItem.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // MENU ITEM — ADD NEW
  // ══════════════════════════════════════════════════════════════════════════════

  Future<void> pickAddFoodImage(String meal) async {
    final xf = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (xf != null) addFoodImages[meal]!.value = File(xf.path);
  }

  Future<void> submitAddFoodItem(String mealType) async {
    final nameCtrl  = addFoodNameCtrls[mealType]!;
    final priceCtrl = addFoodPriceCtrls[mealType]!;
    final descCtrl  = addFoodDescCtrls[mealType]!;
    final imgRx     = addFoodImages[mealType]!;
    final price     = double.tryParse(priceCtrl.text.trim());
    if (nameCtrl.text.trim().isEmpty || price == null) {
      AppSnackbar.warning('Please enter food name and valid price');
      return;
    }
    try {
      isAddingMenuItem.value = true;
      final body = <String, dynamic>{
        'restaurant_id':     restaurantId,
        'meal_type':         mealType,
        'food_name':         nameCtrl.text.trim(),
        'price':             price,
        'short_description': descCtrl.text.trim(),
      };
      if (imgRx.value != null) {
        final bytes = await imgRx.value!.readAsBytes();
        final ext   = imgRx.value!.path.split('.').last.toLowerCase();
        final mime  = ext == 'png' ? 'image/png' : 'image/jpeg';
        body['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
      }
      final res = await http.post(
        Uri.parse('$_baseUrl/restaurant/menu-item'),
        headers: _jsonHeaders,
        body: jsonEncode(body),
      );
      if (!_isJson(res.body)) {
        AppSnackbar.error('Unexpected response (${res.statusCode})');
        return;
      }
      final resBody = jsonDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          resBody['status'] == '1') {
        AppSnackbar.success('Food item added successfully');
        nameCtrl.clear();
        priceCtrl.clear();
        descCtrl.clear();
        imgRx.value = null;
        await fetchMenuItems();
      } else {
        AppSnackbar.warning(resBody['message']?.toString() ?? 'Failed to add item');
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isAddingMenuItem.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  List<MenuItemModel> getMenuItemsByMeal(String mealType) =>
      menuItems.where((m) => m.mealType == mealType).toList();

  MealTimingModel? getTimingByMeal(String mealType) =>
      timings.firstWhereOrNull((t) => t.mealType == mealType);

  bool _isJson(String str) {
    try { jsonDecode(str); return true; } catch (_) { return false; }
  }
}

/// Simple pending slot model (internal only)
class _PendingSlot {
  final String start;
  final String end;
  final int    breakMins;
  _PendingSlot(this.start, this.end, this.breakMins);
  String get display =>
      '$start → $end${breakMins > 0 ? '  (${breakMins}m break)' : ''}';
}