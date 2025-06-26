import 'package:flutter/material.dart';
import 'package:taste_scape1/pages/others/cuisine_preference.dart';

class CookingLevelPage extends StatefulWidget {
  const CookingLevelPage({super.key});

  @override
  State<CookingLevelPage> createState() => _CookingLevelPageState();
}

class _CookingLevelPageState extends State<CookingLevelPage> {
  String? _selectedLevel; // To store the selected cooking level

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set the scaffold background to white
      appBar: AppBar(
        elevation: 0, // Remove shadow for a cleaner look
        backgroundColor: Colors.white, // Pure white app bar
        iconTheme: const IconThemeData(color: Colors.black), // Dark icons for contrast
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "What is your cooking level?",
              style: TextStyle(
                fontSize: screenWidth * 0.076,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Dark text for contrast
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Subtitle
            Text(
              "Please select your cooking level for better recommendations:",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.grey[700], // Subtle grey for subtitles
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Cooking Level Options
            Expanded(
              child: ListView(
                children: [
                  _buildCookingLevelOption(
                    level: "Novice",
                    description:
                        "Basic understanding of kitchen tools and simple techniques such as boiling and frying.",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildCookingLevelOption(
                    level: "Intermediate",
                    description:
                        "Ability to follow recipes, prepare simple dishes, and basic knife skills.",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildCookingLevelOption(
                    level: "Advanced",
                    description:
                        "Understanding of cooking principles, creating recipes, and proficiency in techniques like baking, grilling, & roasting.",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildCookingLevelOption(
                    level: "Professional",
                    description:
                        "Progress from entry-level basics to mastery with increasing skill in cooking, management, and creativity.",
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLevel != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CuisinePreferencePage(
                          // cookingLevel: _selectedLevel!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a cooking level")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2045),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.3,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cooking level option builder
  Widget _buildCookingLevelOption({
    required String level,
    required String description,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedLevel == level
              ? const Color(0xFFFF2045)
              : Colors.white, // White background for unselected items
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF2045),
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: _selectedLevel == level ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              description,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: _selectedLevel == level ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Next Page Example
