import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taste_scape1/db/recipe_model.dart';
import 'package:taste_scape1/features/meal_plan/meal_type.dart';

class EditMealPlanPage extends StatefulWidget {
  final MealPlan mealPlan;
  final List<String> recipeList;
  final VoidCallback onSave;

  const EditMealPlanPage({
    super.key,
    required this.mealPlan,
    required this.recipeList,
    required this.onSave,
  });

  @override
  State<EditMealPlanPage> createState() => _EditMealPlanPageState();
}

class _EditMealPlanPageState extends State<EditMealPlanPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  late String _mealName;
  late List<String> _selectedRecipes;
  late String _notes;
  late DateTime _selectedDate;
  late TimeOfDay? _selectedTime;
  late TextEditingController _mealNameController;
  late TextEditingController _notesController;
  final List<String> _categories = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.mealPlan.category;
    _mealName = widget.mealPlan.mealName;
    _selectedRecipes = List.from(widget.mealPlan.meals);
    _notes = widget.mealPlan.notes;
    _selectedDate = DateFormat.yMMMEd().parse(widget.mealPlan.date);
    _selectedTime = widget.mealPlan.time != null
        ? _parseTimeSafely(widget.mealPlan.time!)
        : null;
    _mealNameController = TextEditingController(text: _mealName);
    _notesController = TextEditingController(text: _notes);
  }

  TimeOfDay? _parseTimeSafely(String time) {
    try {
      final normalizedTime = time.replaceAll(RegExp(r'\s+'), ' ').trim();
      final parsedDateTime = DateFormat.jm().parse(normalizedTime);
      return TimeOfDay.fromDateTime(parsedDateTime);
    } catch (e) {
      print('Error parsing time "$time": $e');
      return null;
    }
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMealPlan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedMealPlan = MealPlan(
        mealName: _mealName,
        category: _selectedCategory,
        notes: _notes,
        date: DateFormat.yMMMEd().format(_selectedDate),
        meals: _selectedRecipes,
        time: _selectedTime?.format(context),
      );

      final box = Hive.box<MealPlan>('meal_plan_box');
      try {
        final index = widget.mealPlan.key;
        // Delete any existing entries with matching date, mealName, and category to avoid duplicates
        final matchingKeys = box.keys.where((key) {
          final plan = box.get(key);
          return plan != null &&
              plan.date == widget.mealPlan.date &&
              plan.mealName == widget.mealPlan.mealName &&
              plan.category == widget.mealPlan.category;
        }).toList();

        for (var key in matchingKeys) {
          if (key is String || key is int) {
            box.delete(key);
          }
        }

        // Save the updated meal plan
        if (index is String || index is int) {
          box.put(index, updatedMealPlan);
        } else {
          box.add(updatedMealPlan);
        }
      } catch (e) {
        print('Error saving meal plan: $e');
        box.add(updatedMealPlan); // Fallback to adding a new entry
      }
      widget.onSave();
      Navigator.pop(context);
    }
  }

  void _deleteMealPlan() {
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
                final index = widget.mealPlan.key;
                if (index is String || index is int) {
                  box.delete(index);
                }
                // Delete any matching entries to ensure cleanup
                final matchingKeys = box.keys.where((key) {
                  final plan = box.get(key);
                  return plan != null &&
                      plan.date == widget.mealPlan.date &&
                      plan.mealName == widget.mealPlan.mealName &&
                      plan.category == widget.mealPlan.category;
                }).toList();

                for (var key in matchingKeys) {
                  if (key is String || key is int) {
                    box.delete(key);
                  }
                }
              } catch (e) {
                print('Error deleting meal plan: $e');
              }
              widget.onSave();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit page
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Meal Plan'),
        backgroundColor: const Color(0xFFFF2045),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteMealPlan,
            tooltip: 'Delete Meal Plan',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ListTile(
                  title: Text(
                    _selectedDate != null
                        ? DateFormat.yMMMEd().format(_selectedDate)
                        : 'Select Date',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.utc(2020, 1, 1),
                      lastDate: DateTime.utc(2030, 12, 31),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select Time',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Meal Category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((type) {
                    final isSelected = _selectedCategory == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: getMealTypeColor(type).withOpacity(0.2),
                      checkmarkColor: getMealTypeColor(type),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  maxLines: 3,
                  onSaved: (value) {
                    _notes = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveMealPlan,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}