import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taste_scape1/DB/add_recipe.dart';
import 'package:taste_scape1/DB/recipe_model.dart';
import 'package:taste_scape1/features/my_recipe/recipe_details.dart';
import 'package:taste_scape1/features/my_recipe/recipe_editing.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({Key? key}) : super(key: key);

  @override
  _MyRecipePageState createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  @override
  Widget build(BuildContext context) {
    final recipeBox =
        Hive.isBoxOpen('recipes') ? Hive.box<Recipe>('recipes') : null;

    if (recipeBox == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
        title: Text(
          'My Recipes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
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
        child: ValueListenableBuilder(
          valueListenable: recipeBox.listenable(),
          builder: (context, Box<Recipe> box, _) {
            if (box.isEmpty) {
              return Center(
                child: Text(
                  'No recipes added yet.',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final recipe = box.getAt(index);
                if (recipe == null) return const SizedBox();

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(
                        recipe: recipe,
                        index: index,
                      ),
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Card(
                      elevation: 0,
                      color: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: recipe.imagePath.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(recipe.imagePath),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.fastfood,
                                              size: 80,
                                              color: Color(0xFFFF3A44),
                                            ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.fastfood,
                                      size: 80,
                                      color: Color(0xFFFF3A44),
                                    ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Flexible(
                                      child: Text(
                                        recipe.description,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      recipe.isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: recipe.isBookmarked
                                          ? const Color(0xFFFF3A44)
                                          : Colors.grey,
                                    ),
                                    tooltip: 'Bookmark',
                                    onPressed: () {
                                      setState(() {
                                        recipe.isBookmarked = !recipe.isBookmarked;
                                        box.putAt(index, recipe);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            recipe.isBookmarked
                                                ? 'Recipe bookmarked!'
                                                : 'Recipe removed from bookmarks.',
                                            style: GoogleFonts.poppins(fontSize: 14),
                                          ),
                                          backgroundColor: const Color(0xFFFF3A44),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFFF3A44),
                                    ),
                                    tooltip: 'Edit',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditRecipePage(
                                          recipe: recipe,
                                          index: index,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFFFF3A44),
                                    ),
                                    tooltip: 'Delete',
                                    onPressed: () async {
                                      await box.deleteAt(index);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Recipe deleted.',
                                            style: GoogleFonts.poppins(fontSize: 14),
                                          ),
                                          backgroundColor: const Color(0xFFFF3A44),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipePage()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF3A44), Color(0xFFFF6F61)],
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
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}