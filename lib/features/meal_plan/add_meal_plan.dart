import 'package:flutter/material.dart';

class AddMealPlanPage extends StatefulWidget {
  final List<String> recipeList; // Pass your existing recipes here

  const AddMealPlanPage({super.key, required this.recipeList});

  @override
  State<AddMealPlanPage> createState() => _AddMealPlanPageState();
}

class _AddMealPlanPageState extends State<AddMealPlanPage> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'Breakfast';
  String? selectedRecipe;
  final TextEditingController _noteController = TextEditingController();

  List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  List<Map<String, String>> mealItems = [];

  void _addMealItem() {
    if (selectedRecipe != null) {
      setState(() {
        mealItems.add({
          'category': selectedCategory,
          'recipe': selectedRecipe!,
          'note': _noteController.text,
        });
        selectedRecipe = null;
        _noteController.clear();
      });
    }
  }

  void _saveMealPlan() {
    if (mealItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one meal item')),
      );
      return;
    }
    // Save logic here (Hive, sqflite, etc.)
    print("Saved Meal Plan: $mealItems");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Meal Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedRecipe,
                    items: widget.recipeList
                        .map((recipe) => DropdownMenuItem(
                            value: recipe, child: Text(recipe)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedRecipe = val;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Recipe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _addMealItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Meal Plan'),
                  ),
                ],
              ),
            ),
            const Divider(height: 30),
            const Text('Meal Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: mealItems.length,
                itemBuilder: (context, index) {
                  final item = mealItems[index];
                  return ListTile(
                    title: Text('${item['recipe']} (${item['category']})'),
                    subtitle:
                        item['note']!.isNotEmpty ? Text(item['note']!) : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          mealItems.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveMealPlan,
              child: const Text('Save Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }}