import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({Key? key}) : super(key: key);

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
          'Help Center',
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
                          'Help Center',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 22 : screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFF3A44),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Welcome to the TasteScape Help Center. Here are some common questions:\n\n'
                          '1. **How do I add a recipe?**\n'
                          '   Navigate to the "Add Recipe" page, fill in the details, and save.\n'
                          '2. **How do I bookmark a recipe?**\n'
                          '   On the recipe details page, tap the bookmark icon in the AppBar.\n'
                          '3. **How do I contact support?**\n'
                          '   Reach out to support@tastescape.com for assistance.\n\n'
                          'This is a placeholder. More FAQs and support options will be added soon.',
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