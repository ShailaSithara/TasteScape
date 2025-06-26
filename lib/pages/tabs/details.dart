import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailsPage({required this.recipe, required title, required image, required description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeInfo(),
                  SizedBox(height: 20),
                  _buildSectionTitle('Ingredients'),
                  _buildIngredients(),
                  SizedBox(height: 20),
                  _buildSectionTitle('Instructions'),
                  _buildInstructions(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recipe added to bookmarks')),
          );
        },
        child: Icon(Icons.bookmark_add),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          recipe['title'] ?? 'Unknown Recipe',
          style: TextStyle(
            color: Colors.white,
            shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
          ),
        ),
        background: Stack(
          children: [
            recipe['image'] != null
                ? Image.asset(recipe['image'], fit: BoxFit.cover)
                : Container(color: Colors.grey), // Placeholder if image is null
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoCard(Icons.timer, '${recipe['time'] ?? 'N/A'} mins'),
            _buildInfoCard(Icons.straighten, recipe['difficulty'] ?? 'Unknown'),
            _buildInfoCard(Icons.star, '${recipe['rating'] ?? 0}'),
          ],
        ),
        SizedBox(height: 16),
        Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(
          recipe['description'] ?? 'No description available.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.deepOrange),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildIngredients() {
    final ingredients = recipe['ingredients'] as List<String>? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, size: 12.0, color: Colors.deepOrange),
              SizedBox(width: 8),
              Expanded(child: Text(ingredient, style: TextStyle(fontSize: 16))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstructions() {
    final instructions = recipe['instructions'] as List<String>? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.deepOrange,
                child: Text('${entry.key + 1}', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 12),
              Expanded(child: Text(entry.value, style: TextStyle(fontSize: 16))),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Example usage
void main() {
  runApp(MaterialApp(
    home: RecipeDetailsPage(
      recipe: {
        'title': 'Spaghetti Carbonara',
        'image': 'assets/image/spaghetti.jpg',
        'time': 30,
        'difficulty': 'Easy',
        'rating': 4.5,
        'description': 'A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.',
        'ingredients': ['200g spaghetti', '100g pancetta', '2 large eggs', '50g pecorino cheese', 'Black pepper'],
        'instructions': [
          'Boil the spaghetti in salted water.',
          'Cook the pancetta until crispy.',
          'Whisk eggs with grated cheese.',
          'Combine spaghetti, pancetta, and egg mixture.',
          'Serve with extra cheese and pepper on top.',
        ],
      }, title: null, image: null, description: null,
    ),
  ));
}
