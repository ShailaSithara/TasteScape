import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:taste_scape1/db/recipe_model.dart';
import 'package:taste_scape1/features/my_recipe/recipe_editing.dart';
import 'package:taste_scape1/features/shopping_list.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final int index;

  const RecipeDetailPage({Key? key, required this.recipe, required this.index})
      : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.recipe.isBookmarked;
  }

  void _toggleBookmark() {
    final recipeBox = Hive.box<Recipe>('recipes');
    setState(() {
      _isBookmarked = !_isBookmarked;
      widget.recipe.isBookmarked = _isBookmarked;
    });

    recipeBox.putAt(widget.index, widget.recipe);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Recipe bookmarked!'
              : 'Recipe removed from bookmarks!',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        backgroundColor: const Color(0xFFFF3A44),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.recipe.title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 26 : screenWidth * 0.055,
          ),
        ),
        backgroundColor: const Color(0xFFFF3A44),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Recipe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipePage(
                    recipe: widget.recipe,
                    index: widget.index,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            tooltip: _isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
            onPressed: _toggleBookmark,
          ),
        ],
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
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListView(
                children: [
                  _buildImageCard(screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTitle(screenWidth, isTablet),
                  SizedBox(height: screenHeight * 0.02),
                  _buildDescription(screenWidth, screenHeight, isTablet),
                  SizedBox(height: screenHeight * 0.02),
                  _buildIngredients(screenWidth, screenHeight, isTablet),
                  SizedBox(height: screenHeight * 0.02),
                  _buildSteps(screenWidth, screenHeight, isTablet),
                  SizedBox(height: screenHeight * 0.04),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildFAB(screenHeight, screenWidth, isTablet),
    );
  }

  Widget _buildImageCard(double screenHeight, double screenWidth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.recipe.imagePath.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  child: Image.file(
                    File(widget.recipe.imagePath),
                    height: screenHeight * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: screenHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(Icons.fastfood,
                        size: 100, color: Color(0xFFFF3A44)),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTitle(double screenWidth, bool isTablet) {
    return Center(
      child: Text(
        widget.recipe.title,
        style: GoogleFonts.poppins(
          fontSize: isTablet ? 32 : screenWidth * 0.07,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDescription(
      double screenWidth, double screenHeight, bool isTablet) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📄 Description',
                style: GoogleFonts.poppins(
                    fontSize: isTablet ? 24 : screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF3A44))),
            SizedBox(height: screenHeight * 0.01),
            Text(widget.recipe.description,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18 : screenWidth * 0.04,
                  color: Colors.black87,
                )),
            SizedBox(height: screenHeight * 0.015),
            Text('⏱ Cooking Time: ${widget.recipe.cookingTime} mins',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18 : screenWidth * 0.04,
                  color: Colors.black87,
                )),
            Text('🍽 Type: ${widget.recipe.type}',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18 : screenWidth * 0.04,
                  color: Colors.black87,
                )),
            Text('🏷 Category: ${widget.recipe.category}',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18 : screenWidth * 0.04,
                  color: Colors.black87,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredients(
      double screenWidth, double screenHeight, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🧂 Ingredients',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 26 : screenWidth * 0.055,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF3A44),
            )),
        SizedBox(height: screenHeight * 0.015),
        ...List.generate(widget.recipe.ingredients.length, (index) {
          return Card(
            elevation: 0,
            color: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. ',
                      style: GoogleFonts.poppins(
                          fontSize: isTablet ? 18 : screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF3A44))),
                  Expanded(
                    child: Text(widget.recipe.ingredients[index],
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 18 : screenWidth * 0.04,
                          color: Colors.black87,
                        )),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSteps(
      double screenWidth, double screenHeight, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('👨‍🍳 Steps',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 26 : screenWidth * 0.055,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF3A44),
            )),
        SizedBox(height: screenHeight * 0.015),
        ...List.generate(widget.recipe.steps.length, (index) {
          return Card(
            elevation: 0,
            color: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. ',
                      style: GoogleFonts.poppins(
                          fontSize: isTablet ? 18 : screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF3A44))),
                  Expanded(
                    child: Text(widget.recipe.steps[index],
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 18 : screenWidth * 0.04,
                          color: Colors.black87,
                        )),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFAB(
      double screenHeight, double screenWidth, bool isTablet) {
    return Container(
      margin:
          EdgeInsets.only(bottom: screenHeight * 0.02, right: screenWidth * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF3A44), Color(0xFFFF6F61)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3A44).withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingListPage()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.shopping_cart_outlined,
          size: isTablet ? 32 : screenWidth * 0.07,
          color: Colors.white,
        ),
        shape: const CircleBorder(),
      ),
    );
  }
}