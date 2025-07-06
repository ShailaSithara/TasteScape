import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        flexibleSpace: Container(
          color: const Color(0xFFFF3A44),
        ),
        title: Text(
          'About',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 26 : screenWidth * 0.055,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: ListView(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About TasteScape',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 22 : screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFF3A44),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'TasteScape is your ultimate recipe companion, designed to help you create, share, and discover delicious meals. Whether you\'re a beginner or a seasoned chef, our app offers tools to manage your recipes, plan meals, and explore new culinary ideas.\n\n'
                          '**Version**: 1.0.0\n'
                          '**Developed by**: TasteScape Team\n'
                          '**Contact**: support@tastescape.com\n\n'
                          'This is a placeholder. More details about the app will be added soon.',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 18 : screenWidth * 0.04,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}