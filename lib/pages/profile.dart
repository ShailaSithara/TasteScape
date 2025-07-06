import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taste_scape1/features/bookmark.dart';
import 'package:taste_scape1/features/meal_plan/mealplanner.dart';
import 'package:taste_scape1/features/my_recipe/my_recipe.dart';
import 'package:taste_scape1/pages/editprofile.dart';
import 'package:taste_scape1/pages/others/cooking_level.dart';
import 'package:taste_scape1/pages/others/splash_screens/splash_screen4.dart';
import 'package:taste_scape1/pages/settings/settings.dart';

// Ensure Hive is initialized in main.dart
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MyApp());
}
*/

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final userBox = Hive.box('userBox');
    final username = userBox.get('username') ?? 'Guest';
    userBox.get('recipesUploaded', defaultValue: 0);
    userBox.get('bookmarks', defaultValue: 0);
    userBox.get('mealPlans', defaultValue: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isTablet ? screenHeight * 0.35 : screenHeight * 0.3,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFFF3A44), // Simplified: Replaced gradient
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.01),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: isTablet ? screenWidth * 0.15 : screenWidth * 0.12,
                        backgroundImage: userBox.get('profileImagePath') != null &&
                                File(userBox.get('profileImagePath')).existsSync()
                            ? FileImage(File(userBox.get('profileImagePath')))
                            : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      username,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isTablet ? 30 : screenWidth * 0.065,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white, size: isTablet ? 30 : screenWidth * 0.06),
                tooltip: 'Edit Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white, size: isTablet ? 30 : screenWidth * 0.06),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          _buildProfileCard(
            context,
            icon: Icons.restaurant,
            label: 'Cooking Level',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CookingLevelPage()),
              );
            },
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildProfileCard(
            context,
            icon: Icons.book,
            label: 'My Recipes',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyRecipePage()),
              );
            },
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildProfileCard(
            context,
            icon: Icons.calendar_today,
            label: 'Meal Plans',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MealPlannerPage()),
              );
            },
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildProfileCard(
            context,
            icon: Icons.bookmark,
            label: 'Bookmark',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkPage()),
              );
            },
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                children: [
                  _buildOutlinedButton(
                    'Logout',
                    Icons.logout,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SplashScreen4()),
                      );
                    },
                    screenWidth: screenWidth,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double screenWidth,
    required bool isTablet,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(1.0),
            child: Card(
              elevation: 0,
              color: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
              ),
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  color: Colors.white.withOpacity(0.7),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.025),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3A44),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: isTablet ? 28 : screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18 : screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required double screenWidth,
    required bool isTablet,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(
          icon,
          color: const Color(0xFFFF3A44),
          size: isTablet ? 24 : screenWidth * 0.05,
        ),
        label: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 18 : screenWidth * 0.04,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFF3A44),
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.05),
          side: const BorderSide(color: Color(0xFFFF3A44), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          backgroundColor: Colors.white.withOpacity(0.1),
        ),
        onPressed: onPressed,
      ),
    );
  }
}