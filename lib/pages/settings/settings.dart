import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taste_scape1/pages/settings/about.dart';
import 'package:taste_scape1/pages/settings/helpcenter.dart';
import 'package:taste_scape1/pages/settings/privacypolicy.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          'Settings',
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
                          'General',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 22 : screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFF3A44),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ListTile(
                          leading: Icon(
                            Icons.privacy_tip,
                            color: const Color(0xFFFF3A44),
                            size: isTablet ? 28 : screenWidth * 0.06,
                          ),
                          title: Text(
                            'Privacy Policy',
                            style: GoogleFonts.poppins(fontSize: isTablet ? 18 : screenWidth * 0.04),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: const Color(0xFFFF3A44),
                            size: isTablet ? 18 : screenWidth * 0.04,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.help_center,
                            color: const Color(0xFFFF3A44),
                            size: isTablet ? 28 : screenWidth * 0.06,
                          ),
                          title: Text(
                            'Help Center',
                            style: GoogleFonts.poppins(fontSize: isTablet ? 18 : screenWidth * 0.04),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: const Color(0xFFFF3A44),
                            size: isTablet ? 18 : screenWidth * 0.04,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpCenterPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: const Color(0xFFFF3A44),
                            size: isTablet ? 28 : screenWidth * 0.06,
                          ),
                          title: Text(
                            'About',
                            style: GoogleFonts.poppins(fontSize: isTablet ? 18 : screenWidth * 0.04),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: const Color(0xFFFF3A44),
                            size: isTablet ? 18 : screenWidth * 0.04,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AboutPage()),
                            );
                          },
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