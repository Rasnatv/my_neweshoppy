
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
  // Each meal key maps to: { 'start': ctrl, 'end': ctrl, 'break': ctrl }
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

  // ── Auth ────────────────────────────────────────────────────────────────────
  String get authToken {
    final token = _storage.read('auth_token') ?? '';
    if (token.isEmpty) debugPrint('⚠️ auth_token is empty');
    return token;
  }

  Map<String, String> get _jsonHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  // ── Lifecycle ───────────────────────────────────────────────────────────────
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
      m['break']?.dispose(); // ← ADDED
    }
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FETCH
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
        tables.value =
            raw.map((e) => RestaurantTableModel.fromJson(e)).toList();
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
        timings.value =
            raw.map((e) => MealTimingModel.fromJson(e)).toList();
        _reinitTimingControllers();
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
        menuItems.value =
            raw.map((e) => MenuItemModel.fromJson(e)).toList();
      } else {
        _snack('Error', 'Failed to load menu items (${res.statusCode})');
      }
    } catch (e) {
      _snack('Error', 'Menu: $e');
    } finally {
      isLoadingMenuItems.value = false;
    }
  }

  // ── Re-init timing controllers (called after fetch & update) ────────────────
  void _reinitTimingControllers() {
    for (final t in timings) {
      if (!timingControllers.containsKey(t.mealType)) {
        // First time — create all 3 controllers
        timingControllers[t.mealType] = {
          'start': TextEditingController(text: t.startTime),
          'end':   TextEditingController(text: t.endTime),
          'break': TextEditingController(
              text: t.breakDuration > 0 ? t.breakDuration.toString() : ''), // ← ADDED
        };
      } else {
        // Already exists — just update text
        timingControllers[t.mealType]!['start']!.text = t.startTime;
        timingControllers[t.mealType]!['end']!.text   = t.endTime;
        // ← ADDED: sync break duration
        timingControllers[t.mealType]!['break']!.text =
        t.breakDuration > 0 ? t.breakDuration.toString() : '';
      }
    }
    debugPrint(
        '🕐 Timing controllers synced: ${timingControllers.keys.toList()}');
    for (final entry in timingControllers.entries) {
      debugPrint(
        '   ${entry.key}: start=${entry.value['start']?.text}'
            ' end=${entry.value['end']?.text}'
            ' break=${entry.value['break']?.text}', // ← ADDED
      );
    }
  }

  // ── Time helpers ─────────────────────────────────────────────────────────────

  /// TimeOfDay(14, 30) → "02:30 PM"
  String formatTimeTo12h(TimeOfDay time) {
    final hour        = time.hour;
    final minute      = time.minute.toString().padLeft(2, '0');
    final period      = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }

  /// "06:27 AM" or "14:30" → TimeOfDay
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

  // ═══════════════════════════════════════════════════════════════════════════
  // TABLE CRUD
  // ═══════════════════════════════════════════════════════════════════════════

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
      _snack('Validation', 'Please fill all table fields');
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

      debugPrint('📡 PUT /edit-restaurant-table: ${jsonEncode(payload)}');

      final res = await http.put(
        Uri.parse('$_baseUrl/edit-restaurant-table'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );

      debugPrint('📥 Table update [${res.statusCode}]: ${res.body}');

      if (!_isJson(res.body)) {
        _snack('Server Error', 'Unexpected response (${res.statusCode})');
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
  // TIMING CRUD
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> updateTimings() async {
    if (timings.isEmpty) {
      _snack('Info', 'No timings to update');
      return;
    }

    try {
      isUpdatingTimings.value = true;

      // Build payload — include break_duration from the text controller
      final payload = timings.map((t) {
        final ctrlMap  = timingControllers[t.mealType];
        final startVal = ctrlMap?['start']?.text.trim() ?? t.startTime;
        final endVal   = ctrlMap?['end']?.text.trim()   ?? t.endTime;
        // ← ADDED: parse break duration from controller (fallback to model value)
        final breakVal = int.tryParse(
            ctrlMap?['break']?.text.trim() ?? '') ??
            t.breakDuration;

        debugPrint(
          '📝 ${t.mealType}: id=${t.id}'
              ' start="$startVal" end="$endVal" break=$breakVal',
        );

        return {
          'id':             t.id.toString(),       // ← string to match API ("43")
          'restaurant_id':  restaurantId.toString(), // ← string to match API ("8")
          'meal_type':      t.mealType,
          'start_time':     startVal,
          'end_time':       endVal,
          'break_duration': breakVal,
        };
      }).toList();

      final bodyMap = {
        'restaurant_id': restaurantId,
        'meal_timings':  payload,
      };

      debugPrint('📤 PUT /meal-timings/update: ${jsonEncode(bodyMap)}');

      final res = await http.put(
        Uri.parse('$_baseUrl/meal-timings/update'),
        headers: _jsonHeaders,
        body: jsonEncode(bodyMap),
      );

      debugPrint('📥 Timings update [${res.statusCode}]: ${res.body}');

      if (!_isJson(res.body)) {
        _snack('Server Error', 'Unexpected response (${res.statusCode})');
        return;
      }

      final resBody = jsonDecode(res.body);

      if (res.statusCode == 200 && resBody['status'] == '1') {
        final dataRaw = resBody['data'];

        List<MealTimingModel> updatedList;

        if (dataRaw is Map && dataRaw.containsKey('meal_timings')) {
          // ✅ Normal path — nested { "restaurant_id": ..., "meal_timings": [...] }
          updatedList = (dataRaw['meal_timings'] as List).map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            // Inject restaurant_id if omitted in nested items
            map.putIfAbsent('restaurant_id', () => restaurantId.toString());
            return MealTimingModel.fromJson(map);
          }).toList();
        } else if (dataRaw is List) {
          // Fallback: flat list
          updatedList = (dataRaw).map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            map.putIfAbsent('restaurant_id', () => restaurantId.toString());
            return MealTimingModel.fromJson(map);
          }).toList();
        } else {
          // Unexpected shape — re-fetch to stay in sync
          debugPrint('⚠️ Unexpected data shape, re-fetching timings');
          await fetchTimings();
          _snack('Success', resBody['message'] ?? 'Timings updated',
              isError: false);
          return;
        }

        timings.value = updatedList;
        _reinitTimingControllers();
        timings.refresh();
        _snack('Success', resBody['message'] ?? 'Timings updated',
            isError: false);
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

  // ═══════════════════════════════════════════════════════════════════════════
  // MENU ITEM CRUD
  // ═══════════════════════════════════════════════════════════════════════════

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
    final xf =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
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

      if (pickedMenuImage.value != null) {
        final bytes = await pickedMenuImage.value!.readAsBytes();
        final ext =
        pickedMenuImage.value!.path.split('.').last.toLowerCase();
        final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
        payload['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
        debugPrint('📡 PUT /restaurant/menu-item/update (with base64 image)');
      } else {
        debugPrint('📡 PUT /restaurant/menu-item/update (no image)');
      }

      final res = await http.put(
        Uri.parse('$_baseUrl/restaurant/menu-item/update'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      );

      debugPrint('📥 Menu item update [${res.statusCode}]: ${res.body}');

      if (!_isJson(res.body)) {
        debugPrint(
          '❌ Non-JSON: ${res.body.substring(0, res.body.length.clamp(0, 300))}',
        );
        _snack('Server Error', 'Unexpected response (${res.statusCode})');
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
        _snack('Success', body['message'] ?? 'Menu item updated',
            isError: false);
      } else {
        _snack('Error',
            body['message'] ?? 'Menu update failed (${res.statusCode})');
      }
    } catch (e, stack) {
      debugPrint('❌ Menu item update: $e\n$stack');
      _snack('Error', 'Menu item update: $e');
    } finally {
      isUpdatingMenuItem.value = false;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
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
      backgroundColor:
      isError ? const Color(0xFFE05252) : const Color(0xFF1DA87A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
