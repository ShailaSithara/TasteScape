import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taste_scape1/DB/recipe_model.dart';

class ViewMealPlanPage extends StatelessWidget {
  final MealPlan mealPlan;

  const ViewMealPlanPage({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meal Plan Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFFF2045),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category: ${mealPlan.category}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Date: ${mealPlan.date}'),
            const SizedBox(height: 8),
            Text('Time: ${mealPlan.time ?? "Not set"}'),
            const SizedBox(height: 8),
            Text('MealPlan Name: ${mealPlan.mealName}'),
            const SizedBox(height: 8),
            Text(
              'Recipes: ${mealPlan.meals.isNotEmpty ? mealPlan.meals.join(", ") : "None"}',
            ),
            const SizedBox(height: 8),
            Text('Notes: ${mealPlan.notes.isNotEmpty ? mealPlan.notes : "None"}'),
          ],
        ),
      ),
    );
  }
}