import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taste_scape1/DB/recipe_model.dart';
import 'package:taste_scape1/features/my_recipe/recipe_details.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final recipeBox = Hive.box<Recipe>('recipes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookmarks' ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
        backgroundColor: const Color(0xFFFF2045),
        elevation: 2,
      ),
      body: ValueListenableBuilder(
        valueListenable: recipeBox.listenable(),
        builder: (context, Box<Recipe> box, _) {
          final bookmarkedRecipes = box.values.where((recipe) => recipe.isBookmarked).toList();

          if (bookmarkedRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarked recipes yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bookmark your favorite recipes to find them here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarkedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = bookmarkedRecipes[index];
              // Find the index in the original box
              final originalIndex = box.values.toList().indexOf(recipe);
              
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(recipe: recipe, index: index),
                  ),
                ),
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      recipe.imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.file(
                                File(recipe.imagePath),
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: Icon(Icons.fastfood, size: 60, color: Colors.orange[800]),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    recipe.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark,
                                color: Colors.orange,
                                size: 28,
                              ),
                              onPressed: () {
                                // Update the recipe to remove bookmark
                                recipe.isBookmarked = false;
                                box.putAt(originalIndex, recipe);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed ${recipe.title} from bookmarks'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () {
                                        recipe.isBookmarked = true;
                                        box.putAt(originalIndex, recipe);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Recipe details row at the bottom
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.cookingTime} min',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                const Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.ingredients.length} ingredients',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}