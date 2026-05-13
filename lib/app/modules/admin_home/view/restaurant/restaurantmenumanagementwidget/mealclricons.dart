import 'package:flutter/material.dart';

import '../../../../../data/models/adminretaurant_menumodel.dart';


Color mealColorszz(MealType m) {
  switch (m) {
    case MealType.breakfast: return const Color(0xFFE07B00);
    case MealType.lunch:     return const Color(0xFF0AA0A0);
    case MealType.dinner:    return const Color(0xFF7B4FA6);
  }
}

IconData mealIconszz(MealType m) {
  switch (m) {
    case MealType.breakfast: return Icons.free_breakfast_outlined;
    case MealType.lunch:     return Icons.lunch_dining_outlined;
    case MealType.dinner:    return Icons.dinner_dining_outlined;
  }
}