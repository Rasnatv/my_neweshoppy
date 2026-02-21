// ─── restaurant_update_model.dart ───────────────────────────────────────────

// ── Table Model ──────────────────────────────────────────────────────────────
class RestaurantTableModel {
  final int id;
  final int restaurantId;
  String tableType;
  String capacityRange;
  String tableName; // comma-separated IDs
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
  final String mealType; // "breakfast" | "lunch" | "dinner"
  String startTime; // "HH:mm"
  String endTime;

  MealTimingModel({
    required this.id,
    required this.restaurantId,
    required this.mealType,
    required this.startTime,
    required this.endTime,
  });

  factory MealTimingModel.fromJson(Map<String, dynamic> json) =>
      MealTimingModel(
        id: int.parse(json['id'].toString()),
        restaurantId: int.parse(json['restaurant_id'].toString()),
        mealType: json['meal_type'] ?? '',
        startTime: _trimSeconds(json['start_time'] ?? ''),
        endTime: _trimSeconds(json['end_time'] ?? ''),
      );

  static String _trimSeconds(String t) {
    // "08:00:00" → "08:00"
    if (t.length >= 5) return t.substring(0, 5);
    return t;
  }

  Map<String, dynamic> toUpdateJson() => {
    'id': id,
    'meal_type': mealType,
    'start_time': startTime,
    'end_time': endTime,
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

  // local — for image replacement (optional)
  dynamic imageFile; // File? in real usage

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