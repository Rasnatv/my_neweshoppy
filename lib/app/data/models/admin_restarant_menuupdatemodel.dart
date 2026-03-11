//
// class RestaurantTableModel {
//   final int id;
//   final int restaurantId;
//   String tableType;
//   String capacityRange;
//   String tableName;
//   String seatingType;
//
//   RestaurantTableModel({
//     required this.id,
//     required this.restaurantId,
//     required this.tableType,
//     required this.capacityRange,
//     required this.tableName,
//     required this.seatingType,
//   });
//
//   factory RestaurantTableModel.fromJson(Map<String, dynamic> json) =>
//       RestaurantTableModel(
//         id: int.parse(json['id'].toString()),
//         restaurantId: int.parse(json['restaurant_id'].toString()),
//         tableType: json['table_type'] ?? '',
//         capacityRange: json['capacity_range'] ?? '',
//         tableName: json['table_name'] ?? '',
//         seatingType: json['seating_type'] ?? 'indoor',
//       );
//
//   Map<String, dynamic> toUpdateJson() => {
//     'table_id': id,
//     'restaurant_id': restaurantId,
//     'table_type': tableType,
//     'capacity_range': capacityRange,
//     'table_name': tableName,
//     'seating_type': seatingType,
//   };
//
//   List<String> get tableIds =>
//       tableName.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
// }
//
// // ── Meal Timing Model ─────────────────────────────────────────────────────────
// class MealTimingModel {
//   final int id;
//   final int restaurantId;
//   final String mealType;
//   String startTime;
//   String endTime;
//
//   MealTimingModel({
//     required this.id,
//     required this.restaurantId,
//     required this.mealType,
//     required this.startTime,
//     required this.endTime,
//   });
//
//   factory MealTimingModel.fromJson(Map<String, dynamic> json) =>
//       MealTimingModel(
//         id: int.parse(json['id'].toString()),
//         // ✅ FIX: update response omits restaurant_id in nested items → was crashing
//         restaurantId: int.tryParse(json['restaurant_id']?.toString() ?? '0') ?? 0,
//         mealType: json['meal_type'] ?? '',
//         startTime: _trimSeconds(json['start_time'] ?? ''),
//         endTime: _trimSeconds(json['end_time'] ?? ''),
//       );
//
//   static String _trimSeconds(String t) {
//     final trimmed = t.trim();
//     final match = RegExp(r'^(\d{1,2}:\d{2}):\d{2}(\s*[APap][Mm])?$').firstMatch(trimmed);
//     if (match != null) {
//       final timePart = match.group(1)!;
//       final period   = match.group(2) ?? '';
//       return '$timePart$period'.trim();
//     }
//     return trimmed;
//   }
//
//   Map<String, dynamic> toUpdateJson() => {
//     'id': id,
//     'meal_type': mealType,
//     'start_time': startTime,
//     'end_time': endTime,
//   };
//
//   String get displayLabel =>
//       '${mealType[0].toUpperCase()}${mealType.substring(1)}: $startTime – $endTime';
// }
//
// // ── Menu Item Model ───────────────────────────────────────────────────────────
// class MenuItemModel {
//   final int id;
//   final int restaurantId;
//   final String mealType;
//   String foodName;
//   double price;
//   String shortDescription;
//   String imageUrl;
//   dynamic imageFile;
//
//   MenuItemModel({
//     required this.id,
//     required this.restaurantId,
//     required this.mealType,
//     required this.foodName,
//     required this.price,
//     required this.shortDescription,
//     required this.imageUrl,
//     this.imageFile,
//   });
//
//   factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
//     id: int.parse(json['id'].toString()),
//     restaurantId: int.parse(json['restaurant_id'].toString()),
//     mealType: json['meal_type'] ?? '',
//     foodName: json['food_name'] ?? '',
//     price: double.parse(json['price'].toString()),
//     shortDescription: json['short_description'] ?? '',
//     imageUrl: json['image'] ?? '',
//   );
//
//   Map<String, dynamic> toUpdateJson() => {
//     'id': id,
//     'restaurant_id': restaurantId,
//     'meal_type': mealType,
//     'food_name': foodName,
//     'price': price,
//     'short_description': shortDescription,
//   };
// }
// ── Restaurant Table Model ────────────────────────────────────────────────────
class RestaurantTableModel {
  final int id;
  final int restaurantId;
  String tableType;
  String capacityRange;
  String tableName;
  String seatingType;

  RestaurantTableModel({
    required this.id,
    required this.restaurantId,
    required this.tableType,
    required this.capacityRange,
    required this.tableName,
    required this.seatingType,
  });

  factory RestaurantTableModel.fromJson(Map<String, dynamic> json) =>
      RestaurantTableModel(
        id: int.parse(json['id'].toString()),
        restaurantId: int.parse(json['restaurant_id'].toString()),
        tableType: json['table_type'] ?? '',
        capacityRange: json['capacity_range'] ?? '',
        tableName: json['table_name'] ?? '',
        seatingType: json['seating_type'] ?? 'indoor',
      );

  Map<String, dynamic> toUpdateJson() => {
    'table_id': id,
    'restaurant_id': restaurantId,
    'table_type': tableType,
    'capacity_range': capacityRange,
    'table_name': tableName,
    'seating_type': seatingType,
  };

  List<String> get tableIds =>
      tableName.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

// ── Meal Timing Model ─────────────────────────────────────────────────────────
class MealTimingModel {
  final int id;
  final int restaurantId;
  final String mealType;
  String startTime;
  String endTime;
  int breakDuration; // ← ADDED

  MealTimingModel({
    required this.id,
    required this.restaurantId,
    required this.mealType,
    required this.startTime,
    required this.endTime,
    this.breakDuration = 0, // ← ADDED (defaults to 0)
  });

  factory MealTimingModel.fromJson(Map<String, dynamic> json) =>
      MealTimingModel(
        id: int.parse(json['id'].toString()),
        // ✅ update response omits restaurant_id in nested items → safe parse
        restaurantId:
        int.tryParse(json['restaurant_id']?.toString() ?? '0') ?? 0,
        mealType: json['meal_type'] ?? '',
        startTime: _trimSeconds(json['start_time'] ?? ''),
        endTime: _trimSeconds(json['end_time'] ?? ''),
        // ← ADDED: API returns break_duration as a string ("20") → parse safely
        breakDuration:
        int.tryParse(json['break_duration']?.toString() ?? '0') ?? 0,
      );

  static String _trimSeconds(String t) {
    final trimmed = t.trim();
    final match =
    RegExp(r'^(\d{1,2}:\d{2}):\d{2}(\s*[APap][Mm])?$').firstMatch(trimmed);
    if (match != null) {
      final timePart = match.group(1)!;
      final period = match.group(2) ?? '';
      return '$timePart$period'.trim();
    }
    return trimmed;
  }

  Map<String, dynamic> toUpdateJson() => {
    'id': id,
    'meal_type': mealType,
    'start_time': startTime,
    'end_time': endTime,
    'break_duration': breakDuration, // ← ADDED
  };

  String get displayLabel =>
      '${mealType[0].toUpperCase()}${mealType.substring(1)}: $startTime – $endTime';
}

// ── Menu Item Model ───────────────────────────────────────────────────────────
class MenuItemModel {
  final int id;
  final int restaurantId;
  final String mealType;
  String foodName;
  double price;
  String shortDescription;
  String imageUrl;
  dynamic imageFile;

  MenuItemModel({
    required this.id,
    required this.restaurantId,
    required this.mealType,
    required this.foodName,
    required this.price,
    required this.shortDescription,
    required this.imageUrl,
    this.imageFile,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
    id: int.parse(json['id'].toString()),
    restaurantId: int.parse(json['restaurant_id'].toString()),
    mealType: json['meal_type'] ?? '',
    foodName: json['food_name'] ?? '',
    price: double.parse(json['price'].toString()),
    shortDescription: json['short_description'] ?? '',
    imageUrl: json['image'] ?? '',
  );

  Map<String, dynamic> toUpdateJson() => {
    'id': id,
    'restaurant_id': restaurantId,
    'meal_type': mealType,
    'food_name': foodName,
    'price': price,
    'short_description': shortDescription,
  };
}