import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taste_scape1/DB/recipe_model.dart';
import 'package:image_picker/image_picker.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;
  final int index;

  const EditRecipePage({Key? key, required this.recipe, required this.index})
      : super(key: key);

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cookingTimeController;
  late TextEditingController _ingredientController;
  late TextEditingController _stepController;
  late String _imagePath;
  String? _selectedType;
  String? _selectedCategory;
  List<String> _ingredients = [];
  List<String> _steps = [];

  final ImagePicker _picker = ImagePicker();

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController =
        TextEditingController(text: widget.recipe.description);
    _cookingTimeController =
        TextEditingController(text: widget.recipe.cookingTime.toString());
    _ingredientController = TextEditingController();
    _stepController = TextEditingController();
    _imagePath = widget.recipe.imagePath;
    _selectedType = widget.recipe.type;
    _selectedCategory = widget.recipe.category;
    _ingredients = List.from(widget.recipe.ingredients);
    _steps = List.from(widget.recipe.steps);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cookingTimeController.dispose();
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  void _editIngredient(int index) {
    _ingredientController.text = _ingredients[index];
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
            controller: _ingredientController,
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
                  _ingredients[index] = _ingredientController.text;
                  _ingredientController.clear();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3A44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
    _stepController.text = _steps[index];
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
            controller: _stepController,
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
                  _steps[index] = _stepController.text;
                  _stepController.clear();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3A44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text);
        _ingredientController.clear();
      });
    }
  }

  void _addStep() {
    if (_stepController.text.isNotEmpty) {
      setState(() {
        _steps.add(_stepController.text);
        _stepController.clear();
      });
    }
  }

  void _saveChanges() {
    final recipeBox = Hive.box<Recipe>('recipes');
    final updatedRecipe = Recipe(
      title: _titleController.text,
      description: _descriptionController.text,
      cookingTime:
          int.tryParse(_cookingTimeController.text) ?? widget.recipe.cookingTime,
      imagePath: _imagePath,
      ingredients: _ingredients,
      steps: _steps,
      type: _selectedType ?? widget.recipe.type,
      category: _selectedCategory ?? widget.recipe.category,
    );

    recipeBox.putAt(widget.index, updatedRecipe);
    Navigator.pop(context);
  }

  Future<void> _updateImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF3A44),
        title: Text(
          'Edit Recipe',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      onTap: _updateImage,
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
                        child: _imagePath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(_imagePath),
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color(0xFFFF3A44),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Change Recipe Photo',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFFF3A44),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: const Icon(
                      Icons.restaurant_menu,
                      color: Color(0xFFFF3A44),
                    ),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color(0xFFFF3A44),
                    ),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cookingTimeController,
                  decoration: InputDecoration(
                    labelText: 'Cooking Time (minutes)',
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: const Icon(
                      Icons.timer,
                      color: Color(0xFFFF3A44),
                    ),
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
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Recipe Type',
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: const Icon(
                      Icons.category,
                      color: Color(0xFFFF3A44),
                    ),
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
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: const Icon(
                      Icons.breakfast_dining,
                      color: Color(0xFFFF3A44),
                    ),
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
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ingredientController,
                                  decoration: InputDecoration(
                                    labelText: 'Add Ingredient',
                                    labelStyle:
                                        GoogleFonts.poppins(color: Colors.black54),
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
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _stepController,
                                  decoration: InputDecoration(
                                    labelText: 'Add Step',
                                    labelStyle:
                                        GoogleFonts.poppins(color: Colors.black54),
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
                  onTap: _saveChanges,
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
                        'Save Changes',
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