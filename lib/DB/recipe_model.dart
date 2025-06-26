import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0) // Unique type ID for this model
class Recipe extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int cookingTime;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final List<String> ingredients;

  @HiveField(6)
  final List<String> steps;

  @HiveField(7)
  String imagePath;

  @HiveField(8)
  bool isBookmarked;

  Recipe({
    required this.title,
    required this.description,
    required this.cookingTime,
    required this.type,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
    this.isBookmarked = false,
  });

  get calories => null;
}


@HiveType(typeId: 1)
class ShoppingItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  bool isPurchased;

  ShoppingItem({
    required this.name,
    required this.category,
    this.isPurchased = false,
  });
}

// Generated adapter part file

@HiveType(typeId: 33) // Ensure the typeId is unique across models
class MealPlan {
  @HiveField(0)
  String mealName;

  @HiveField(1)
  String category;

  @HiveField(2)
  String notes;

  @HiveField(3)
  String date;

  @HiveField(4)
  List<String> meals;

  @HiveField(5)
  String? time;

  MealPlan({
    required this.mealName,
    required this.category,
    required this.notes,
    required this.date,
    required this.meals,
    this.time,
  });

  get key => null;
}




@HiveType(typeId: 2)
class RecipeFix extends HiveObject {
  @HiveField(0)
  late final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String imageUrl; // Use URLs for fixed recipes

  @HiveField(3)
  final int cookingTime;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final List<String> ingredients;

  @HiveField(7)
  final List<String> steps;

  @HiveField(8)
  bool isBookmarked;

  RecipeFix({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTime,
    required this.type,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.isBookmarked = false,
  });

  get tags => null;
}