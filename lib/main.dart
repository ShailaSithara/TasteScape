import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:taste_scape1/DB/recipe_model.dart';
import 'package:taste_scape1/features/meal_plan/mealplanner.dart';
import 'package:taste_scape1/pages/others/splash_screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with app document directory
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive adapters
  try {
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(MealPlanAdapter());
    Hive.registerAdapter(RecipeFixAdapter());
    Hive.registerAdapter(ShoppingItemAdapter());
    print('All adapters registered successfully');
  } catch (e) {
    print('Error registering adapters: $e');
  }

  // Open the required Hive boxes
  try {
    await Future.wait([
      Hive.openBox<MealPlan>('mealPlanBox'),
      Hive.openBox<Recipe>('recipes'),
      Hive.openBox('userBox'),
      Hive.openBox<ShoppingItem>('shoppingList'),
      Hive.openBox<RecipeFix>('fixedrecipes'),
    ]);
    print('Boxes opened:');
    print('  mealPlanBox: ${Hive.box<MealPlan>('mealPlanBox').isOpen}');
    print('  recipes: ${Hive.box<Recipe>('recipes').isOpen}');
    print('  userBox: ${Hive.box('userBox').isOpen}');
    print('  shoppingList: ${Hive.box<ShoppingItem>('shoppingList').isOpen}');
    print('  fixedrecipes: ${Hive.box<RecipeFix>('fixedrecipes').isOpen}');
  } catch (e) {
    print('Error opening boxes: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF2045),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
      routes: {
        '/meal_planner': (context) => const MealPlannerPage(),
      },
    );
  }
}