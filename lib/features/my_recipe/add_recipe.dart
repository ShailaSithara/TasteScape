import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taste_scape1/db/recipe_model.dart';
import 'package:taste_scape1/pages/tabs/home.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        primaryColor: const Color(0xFFFF3A44),
        scaffoldBackgroundColor: Colors.grey.shade100,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFFF3A44),
              width: 2,
            ),
          ),
          labelStyle: GoogleFonts.poppins(color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3A44),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: ResponsiveHomePage(),
    );
  }
}

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  File? _image;
  String? _selectedType;
  String? _selectedCategory;

  final List<String> _types = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Keto',
    'Gluten-Free',
    'Paleo',
    'Halal',
    'Kosher',
    'Low-Carb',
    'Organic',
    'Dairy-Free',
    'Nut-Free'
  ];
  final List<String> _categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Desserts',
    'Brunch',
    'Appetizers',
    'Drinks & Beverages'
  ];

  final List<String> _ingredients = [];
  final List<String> _steps = [];

  void _editIngredient(int index) {
    _ingredientsController.text = _ingredients[index];
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.9),
          title: Text(
            'Edit Ingredient',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            controller: _ingredientsController,
            decoration: InputDecoration(
              labelText: 'Ingredient',
              labelStyle: GoogleFonts.poppins(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFF3A44),
                  width: 2,
                ),
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ingredients[index] = _ingredientsController.text;
                  _ingredientsController.clear();
                });
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editStep(int index) {
    _stepsController.text = _steps[index];
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.9),
          title: Text(
            'Edit Step',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            controller: _stepsController,
            decoration: InputDecoration(
              labelText: 'Step',
              labelStyle: GoogleFonts.poppins(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFF3A44),
                  width: 2,
                ),
              ),
            ),
            maxLines: 3,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _steps[index] = _stepsController.text;
                  _stepsController.clear();
                });
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addIngredient() {
    if (_ingredientsController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientsController.text);
        _ingredientsController.clear();
      });
    }
  }

  void _addStep() {
    if (_stepsController.text.isNotEmpty) {
      setState(() {
        _steps.add(_stepsController.text);
        _stepsController.clear();
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate() && _image != null && _ingredients.isNotEmpty && _steps.isNotEmpty) {
      final box = Hive.box<Recipe>('recipes');
      final recipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        cookingTime: int.tryParse(_cookingTimeController.text) ?? 0,
        type: _selectedType!,
        category: _selectedCategory!,
        ingredients: _ingredients,
        steps: _steps,
        imagePath: _image!.path,
      );
      await box.add(recipe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recipe saved successfully!',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: const Color(0xFFFF3A44),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResponsiveHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete all fields, add an image, and include at least one ingredient and step.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF3A44), Color(0xFFFF6F61)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
    'Add Recipe',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  centerTitle: true,
          automaticallyImplyLeading: false,

        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF3A44).withOpacity(0.2),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    elevation: 0,
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color(0xFFFF3A44),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Add Recipe Photo',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFFF3A44),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _image!,
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Recipe Title',
                    prefixIcon: const Icon(
                      Icons.restaurant_menu,
                      color: Color(0xFFFF3A44),
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 16),
                  validator: (value) => value!.isEmpty ? 'Enter a recipe title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color(0xFFFF3A44),
                    ),
                  ),
                  maxLines: 3,
                  style: GoogleFonts.poppins(fontSize: 16),
                  validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cookingTimeController,
                  decoration: InputDecoration(
                    labelText: 'Cooking Time (minutes)',
                    prefixIcon: const Icon(
                      Icons.timer,
                      color: Color(0xFFFF3A44),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(fontSize: 16),
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter cooking time';
                    if (int.tryParse(value) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Recipe Type',
                    prefixIcon: const Icon(
                      Icons.category,
                      color: Color(0xFFFF3A44),
                    ),
                  ),
                  value: _selectedType,
                  items: _types
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedType = value),
                  validator: (value) => value == null ? 'Select a type' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(
                      Icons.breakfast_dining,
                      color: Color(0xFFFF3A44),
                    ),
                  ),
                  value: _selectedCategory,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  validator: (value) => value == null ? 'Select a category' : null,
                ),
                const SizedBox(height: 24),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    elevation: 0,
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF3A44),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ingredientsController,
                                  decoration: InputDecoration(
                                    labelText: 'Add Ingredient',
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Color(0xFFFF3A44),
                                      ),
                                      onPressed: _addIngredient,
                                    ),
                                  ),
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ..._ingredients.asMap().entries.map((entry) {
                            final index = entry.key;
                            final ingredient = entry.value;
                            return Card(
                              elevation: 0,
                              color: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    '${index + 1}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFFF3A44),
                                ),
                                title: Text(
                                  ingredient,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _editIngredient(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFFFF3A44),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _ingredients.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    elevation: 0,
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Steps',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF3A44),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _stepsController,
                                  decoration: InputDecoration(
                                    labelText: 'Add Step',
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Color(0xFFFF3A44),
                                      ),
                                      onPressed: _addStep,
                                    ),
                                  ),
                                  maxLines: 3,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ..._steps.asMap().entries.map((entry) {
                            final index = entry.key;
                            final step = entry.value;
                            return Card(
                              elevation: 0,
                              color: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    '${index + 1}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFFF3A44),
                                ),
                                title: Text(
                                  step,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _editStep(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFFFF3A44),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _steps.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: _saveRecipe,
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.white.withOpacity(0.2),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF3A44), Color(0xFFFF6F61)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3A44).withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        'Save Recipe',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}