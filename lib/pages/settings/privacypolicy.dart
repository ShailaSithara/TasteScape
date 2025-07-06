import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

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
          'Privacy Policy',
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
                          'Privacy Policy',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 22 : screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFF3A44),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'At TasteScape, we value your privacy. This Privacy Policy outlines how we collect, use, and protect your personal information:\n\n'
                          '1. Data Collection: We collect information you provide (e.g., username, recipes) and usage data (e.g., app interactions).\n'
                          '2. Data Usage: Your data is used to personalize your experience, improve our services, and provide recipe recommendations.\n'
                          '3. Data Protection: We implement security measures to protect your information from unauthorized access.\n'
                          '4. Third Parties: We do not share your personal data with third parties without your consent, except as required by law.\n'
                          '5. Contact Us: For questions about this policy, reach out to support@tastescape.com.\n\n'
                          'This is a placeholder policy. A full policy will be available soon.',
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