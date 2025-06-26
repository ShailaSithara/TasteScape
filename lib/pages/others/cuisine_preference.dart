import 'package:flutter/material.dart';
import 'package:taste_scape1/pages/others/diatory_preference.dart';

class CuisinePreferencePage extends StatefulWidget {
  const CuisinePreferencePage({super.key});

  @override
  State<CuisinePreferencePage> createState() => _CuisinePreferencePageState();
}

class _CuisinePreferencePageState extends State<CuisinePreferencePage> {
  // List of cuisines with images
  final List<Map<String, String>> _cuisines = [
    {"name": "Italian", "image": "assets/italian.jpg"},
    {"name": "Chinese", "image": "assets/chinese.jpg"},
    {"name": "Indian", "image": "assets/indian.jpg"},
    {"name": "Mexican", "image": "assets/mexican.jpg"},
    {"name": "Thai", "image": "assets/thai.jpg"},
    {"name": "Japanese", "image": "assets/japanese.jpg"},
    {"name": "French", "image": "assets/french.jpg"},
    {"name": "Greek", "image": "assets/greek.jpg"},
    {"name": "Spanish", "image": "assets/spanish.jpg"},
    {"name": "Mediterranean", "image": "assets/mediterranean.jpg"},
    {"name": "Korean", "image": "assets/korean.jpg"},
    {"name": "American", "image": "assets/american.jpg"},
  ];

  final List<String> _selectedCuisines = []; // Store selected cuisines

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        // title: Text(
        //   "Cuisine Preferences",
        //   style: TextStyle(
        //     fontSize: screenWidth * 0.05,
        //     color: Colors.black,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Select your preferred cuisines:",
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),

            // Subtitle
            Text(
              "Please select your cooking level for better recommendations, or you can skip it.",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Cuisine Options
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2, // Responsive grid
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenHeight * 0.02,
                  childAspectRatio: screenWidth > 600 ? 0.8 : 1, // Adjust for tablets
                ),
                itemCount: _cuisines.length,
                itemBuilder: (context, index) {
                  String cuisine = _cuisines[index]["name"]!;
                  String imagePath = _cuisines[index]["image"]!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedCuisines.contains(cuisine)) {
                          _selectedCuisines.remove(cuisine);
                        } else {
                          _selectedCuisines.add(cuisine);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedCuisines.contains(cuisine)
                            ? const Color(0xFFFF2045)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFFF2045),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cuisine Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imagePath,
                              width: screenWidth * 0.3,
                              height: screenWidth * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          // Cuisine Name
                          Text(
                            cuisine,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: _selectedCuisines.contains(cuisine)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Action Buttons (Continue & Skip)
            // Action Buttons (Continue & Skip)
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Skip Button
    Expanded(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DietaryPreference(),
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 253, 218, 223),
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
          if (_selectedCuisines.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DietaryPreference(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select at least one cuisine or skip."),
              ),
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
            fontWeight: FontWeight.bold,
            color: Colors.white,
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

