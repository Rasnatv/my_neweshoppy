
import 'dart:io';
import 'package:get/get.dart';

class FoodItem {
  final int? id;
  final String name;
  final File? imageFile;
  final String? imageUrl;
  final double price;
  final String description;

  FoodItem({
    this.id,
    required this.name,
    required this.price,
    this.imageFile,
    this.imageUrl,
    required this.description,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'] is int
        ? json['id']
        : int.tryParse(json['id'].toString()),
    name: json['food_name'] ?? '',
    price: double.tryParse(json['price'].toString()) ?? 0.0,
    imageUrl: json['image'],
    description: json['short_description'] ?? '',
  );
}

// ==================== SEATING TYPE ====================

enum SeatingType { indoor, outdoor, both }

// ==================== TABLE TYPE ====================

class TableType {
  final int? id;
  final String name;
  final String capacityRange;
  final List<String> availableTables;
  final SeatingType seatingType;

  TableType({
    this.id,
    required this.name,
    required this.capacityRange,
    required this.availableTables,
    required this.seatingType,
  });

  factory TableType.fromJson(Map<String, dynamic> json) => TableType(
    id: json['id'] is int
        ? json['id']
        : int.tryParse(json['id'].toString()),
    name: json['table_type'] ?? '',
    capacityRange: json['capacity_range'] ?? '',

    // ✅ FIXED: API returns "T1,t2,t3" as a single comma-separated string
    // Split → trim → uppercase → filter empty
    availableTables: (json['table_name'] ?? '')
        .toString()
        .split(',')
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .toList(),

    seatingType: SeatingType.values.firstWhere(
          (e) => e.name == (json['seating_type'] ?? 'indoor'),
      orElse: () => SeatingType.indoor,
    ),
  );
}

// ==================== MEAL TYPE ====================

enum MealType { breakfast, lunch, dinner }

// ==================== TIME SLOT ====================

class TimeSlot {
  final int? id;
  final MealType mealType;
  final String startTime;
  final String endTime;
  final int breakDuration; // ← ADDED

  TimeSlot({
    this.id,
    required this.mealType,
    required this.startTime,
    required this.endTime,
    this.breakDuration = 0, // ← ADDED (defaults to 0 = no break)
  });

  String get displayTime => '$startTime - $endTime';

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    // API returns times like "10:00 AM" — keep as-is (no trimming to 5 chars)
    String safeTime(dynamic val) => (val ?? '').toString().trim();

    return TimeSlot(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()),
      mealType: MealType.values.firstWhere(
            (e) => e.name == (json['meal_type'] ?? 'breakfast'),
        orElse: () => MealType.breakfast,
      ),
      startTime: safeTime(json['start_time']),
      endTime: safeTime(json['end_time']),
      // ← ADDED: API returns break_duration as a string (e.g. "20"), parse safely
      breakDuration:
      int.tryParse(json['break_duration']?.toString() ?? '0') ?? 0,
    );
  }
}

// ==================== MEAL MENU ====================

class MealMenu {
  final MealType mealType;
  final RxList<FoodItem> foodItems = <FoodItem>[].obs;

  MealMenu({required this.mealType});
}