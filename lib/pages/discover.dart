import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taste_scape1/features/my_recipe/recipe_details.dart';
import 'package:taste_scape1/db/recipe_model.dart'as dbModel;

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Desserts',
    'Snacks',
    'Drinks & Beverages',
  ];

  List<dbModel.Recipe> _filterRecipes(Box<dbModel.Recipe> box) {
  return box.values.where((recipe) {
    final title = recipe.title.toLowerCase();
    final description = recipe.description.toLowerCase();
    final category = recipe.category;

    final matchesSearch = title.contains(_searchQuery.toLowerCase()) ||
                          description.contains(_searchQuery.toLowerCase());

    final matchesCategory = _selectedCategory == 'All' || category == _selectedCategory;

    return matchesSearch && matchesCategory;
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: const Color(0xFFFF2045),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,         
                    ),
                  ),
                );
              },
            ),
          ),

          // Recipe List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<dbModel.Recipe>('recipes').listenable(),
              builder: (context, Box<dbModel.Recipe> box, _) {
                final filteredRecipes = _filterRecipes(box);

                if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No recipes found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(recipe: recipe, index: index),
                          ),
                        );
                      },
                      child: DiscoverRecipeCard(recipe: recipe),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class DiscoverRecipeCard extends StatelessWidget {
  final dbModel.Recipe recipe;

  const DiscoverRecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: recipe.imagePath.isNotEmpty
                        ? Image.file(
                            File(recipe.imagePath),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.fastfood,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFFFF2045),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Expanded(
                  flex: 1,
                  child: Text(
                    recipe.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}