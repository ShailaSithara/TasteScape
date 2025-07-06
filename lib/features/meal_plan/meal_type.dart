  import 'dart:ui';

import 'package:flutter/material.dart';

Color getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return const Color(0xFFFFB74D);
      case 'Lunch':
        return const Color(0xFF4CAF50);
      case 'Dinner':
        return const Color(0xFF7E57C2);
      case 'Snack':
        return const Color(0xFFFF7043);
      default:
        return const Color(0xFFFF2045);
    }
  }

 
  IconData getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }