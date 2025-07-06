import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taste_scape1/db/recipe_model.dart';
import 'package:taste_scape1/features/meal_plan/edit_mealplan.dart';
import 'package:taste_scape1/features/meal_plan/meal_type.dart';

class ViewMealPlanPage extends StatelessWidget {
  final MealPlan mealPlan;

  const ViewMealPlanPage({super.key, required this.mealPlan});

  void _editMealPlan(BuildContext context) {
    final recipeBox = Hive.box<Recipe>('recipes');
    final List<String> recipeList = recipeBox.values.isEmpty
        ? []
        : [for (var recipe in recipeBox.values) recipe.title];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMealPlanPage(
          mealPlan: mealPlan,
          recipeList: recipeList,
          onSave: () {
            Navigator.pop(context); // Pop back to ViewMealPlanPage
          },
        ),
      ),
    );
  }

  void _deleteMealPlan(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal Plan'),
        content: const Text('Are you sure you want to delete this meal plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final box = Hive.box<MealPlan>('meal_plan_box');
              try {
                final index = mealPlan.key;
                if (index is String || index is int) {
                  box.delete(index);
                }
                // Delete any matching entries to ensure cleanup
                final matchingKeys = box.keys.where((key) {
                  final plan = box.get(key);
                  return plan != null &&
                      plan.date == mealPlan.date &&
                      plan.mealName == mealPlan.mealName &&
                      plan.category == mealPlan.category;
                }).toList();

                for (var key in matchingKeys) {
                  if (key is String || key is int) {
                    box.delete(key);
                  }
                }
              } catch (e) {
                print('Error deleting meal plan: $e');
              }
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Pop back to MealPlannerPage
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealColor = getMealTypeColor(mealPlan.category);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan Details'),
        backgroundColor: const Color(0xFFFF2045),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editMealPlan(context),
            tooltip: 'Edit Meal Plan',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteMealPlan(context),
            tooltip: 'Delete Meal Plan',
            color: Colors.red,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: mealColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Icon(getMealTypeIcon(mealPlan.category), color: mealColor),
                    const SizedBox(width: 8),
                    Text(
                      mealPlan.category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mealColor,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Meal Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mealPlan.mealName.isNotEmpty ? mealPlan.mealName : 'No meal name',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mealPlan.date,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mealPlan.time ?? 'Not set',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Recipes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mealPlan.meals.isNotEmpty ? mealPlan.meals.join(", ") : 'None',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mealPlan.notes.isNotEmpty ? mealPlan.notes : 'None',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}