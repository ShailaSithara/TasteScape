import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:taste_scape1/db/recipe_model.dart';

class QuickAddMealPlanBottomSheet extends StatefulWidget {
  final List<String> recipeList;
  final DateTime selectedDay;
  final VoidCallback onSave;

  const QuickAddMealPlanBottomSheet({
    required this.recipeList,
    required this.selectedDay,
    required this.onSave,
  });

  @override
  _QuickAddMealPlanBottomSheetState createState() => _QuickAddMealPlanBottomSheetState();
}

class _QuickAddMealPlanBottomSheetState extends State<QuickAddMealPlanBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Breakfast';
  String _mealName = '';
  List<String> _selectedRecipes = [];
  late TextEditingController _mealNameController;
  final List<String> _mealTypeFilters = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController();
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    super.dispose();
  }

  Color _getMealTypeColor(String mealType) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF2045),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Add Meal Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal Name
                    TextFormField(
                      controller: _mealNameController,
                      decoration: const InputDecoration(
                        labelText: 'Meal Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(Icons.restaurant_menu),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a meal name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _mealName = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Meal Category
                    const Text(
                      'Meal Category',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _mealTypeFilters.map((type) {
                        final isSelected = _selectedCategory == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: _getMealTypeColor(type).withOpacity(0.2),
                          checkmarkColor: _getMealTypeColor(type),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = type;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Recipes
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    widget.recipeList.isEmpty
                        ? const Text(
                            'No recipes available.',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.recipeList.map((recipeTitle) {
                              final isSelected = _selectedRecipes.contains(recipeTitle);
                              return FilterChip(
                                label: Text(recipeTitle),
                                selected: isSelected,
                                selectedColor: const Color(0xFFFF2045).withOpacity(0.2),
                                checkmarkColor: const Color(0xFFFF2045),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedRecipes.add(recipeTitle);
                                    } else {
                                      _selectedRecipes.remove(recipeTitle);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final mealPlan = MealPlan(
                        mealName: _mealName,
                        category: _selectedCategory,
                        notes: '', 
                        date: DateFormat.yMMMEd().format(widget.selectedDay),
                        meals: _selectedRecipes,
                        time: TimeOfDay.now().format(context),
                      );
                      final box = Hive.box<MealPlan>('meal_plan_box');
                      await box.add(mealPlan);
                      widget.onSave();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2045),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  child: const Text(
                    'Save Meal Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}