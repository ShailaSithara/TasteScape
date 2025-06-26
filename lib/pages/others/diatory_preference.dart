import 'package:flutter/material.dart';
import 'package:taste_scape1/pages/tabs/home.dart';

class DietaryPreference extends StatefulWidget {
  const DietaryPreference({super.key});

  @override
  State<DietaryPreference> createState() => _DietaryPreferenceState();
}

class _DietaryPreferenceState extends State<DietaryPreference> {
  List<String> selectedPreferences = [];

  final List<Map<String, String>> dietaryPreferences = [
    {"title": "Vegetarian", "image": "assets/vegetarian.jpg", "desc": "No meat, fish, or poultry."},
    {"title": "Vegan", "image": "assets/vegan.jpg", "desc": "Plant-based foods only."},
    {"title": "Pescatarian", "image": "assets/pescatarian.jpg", "desc": "Includes fish but no meat."},
    {"title": "Keto", "image": "assets/keto.jpg", "desc": "Low carbs, high fats."},
    {"title": "Gluten-Free", "image": "assets/gluten_free.jpg", "desc": "No gluten-containing foods."},
    {"title": "Paleo", "image": "assets/paleo.jpg", "desc": "Based on ancient eating habits."},
    {"title": "Halal", "image": "assets/halal.jpg", "desc": "Permitted foods per Islamic law."},
    {"title": "Kosher", "image": "assets/kosher.jpg", "desc": "Foods prepared according to Jewish law."},
    {"title": "Low-Carb", "image": "assets/low_carb.jpg", "desc": "Low carbohydrate intake."},
    {"title": "Organic", "image": "assets/organic.jpg", "desc": "Free from synthetic substances."},
    {"title": "Dairy-Free", "image": "assets/dairy_free.jpg", "desc": "No dairy products."},
    {"title": "Nut-Free", "image": "assets/nut_free.jpg", "desc": "Safe for nut allergies."},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to pure white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "What are your dietary preferences?",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Subtitle
            Text(
              "Please select your dietary preferences for better recommendations, or you can skip this step.",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Dietary Preferences Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.03, 
                  mainAxisSpacing: screenHeight * 0.02,
                ),
                itemCount: dietaryPreferences.length,
                itemBuilder: (context, index) {
                  final item = dietaryPreferences[index];
                  final isSelected = selectedPreferences.contains(item['title']);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedPreferences.remove(item['title']);
                        } else {
                          selectedPreferences.add(item['title']!);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFF2045) : Colors.white,
                        border: Border.all(
                          color: const Color(0xFFFF2045),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['image']!,
                            height: screenHeight * 0.08,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            item['title']!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            item['desc']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: isSelected ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>ResponsiveHomePage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 229, 232),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: const Color(0xFFFF2045),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05), // Space between buttons
                // Continue Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedPreferences.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponsiveHomePage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select at least one preference or skip.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF2045),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


