import 'package:flutter/material.dart';
import 'package:taste_scape1/db/recipe_model.dart';

class WeeklyMealPlanStats extends StatelessWidget {
  final List<MealPlan> mealPlans;

  const WeeklyMealPlanStats({super.key, required this.mealPlans});

  @override
  Widget build(BuildContext context) {  
    int totalBreakfasts = mealPlans.where((plan) => plan.category == 'Breakfast').length;
    int totalLunches = mealPlans.where((plan) => plan.category == 'Lunch').length;
    int totalDinners = mealPlans.where((plan) => plan.category == 'Dinner').length;
    int totalSnacks = mealPlans.where((plan) => plan.category == 'Snack').length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF2045),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Breakfast', totalBreakfasts, const Color(0xFFFFB74D)),
                _buildStatItem('Lunch', totalLunches, const Color(0xFF4CAF50)),
                _buildStatItem('Dinner', totalDinners, const Color(0xFF7E57C2)),
                _buildStatItem('Snack', totalSnacks, const Color(0xFFFF7043)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}