import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taste_scape1/features/bookmark.dart';
import 'package:taste_scape1/features/meal_plan/mealplanner.dart';
import 'package:taste_scape1/features/my_recipe/my_recipe.dart';
import 'package:taste_scape1/pages/others/cooking_level.dart';
import 'package:taste_scape1/pages/others/splash_screens/splash_screen4.dart';

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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  String? _profileImagePath;
  bool _isPickingImage = false; // Flag to prevent multiple image picker calls

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box('userBox');
    _usernameController = TextEditingController(text: userBox.get('username') ?? 'Guest');
    _profileImagePath = userBox.get('profileImagePath');
    if (_profileImagePath != null && !File(_profileImagePath!).existsSync()) {
      userBox.delete('profileImagePath');
      _profileImagePath = null;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userBox = Hive.box('userBox');
      userBox.put('username', _usernameController.text);
      if (_profileImagePath != null && File(_profileImagePath!).existsSync()) {
        userBox.put('profileImagePath', _profileImagePath);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width * 0.035),
          ),
          backgroundColor: const Color(0xFFFF3A44),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _pickImage() async {
    if (_isPickingImage) return; // Prevent multiple calls
    setState(() {
      _isPickingImage = true;
    });
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('Picked image path: ${pickedFile.path}');
        final directory = await getApplicationDocumentsDirectory();
        final fileName = pickedFile.path.split('/').last;
        final savedImage = await File(pickedFile.path).copy('${directory.path}/$fileName');
        print('Saved image path: ${savedImage.path}');
        setState(() {
          _profileImagePath = savedImage.path;
        });
        final userBox = Hive.box('userBox');
        userBox.put('profileImagePath', _profileImagePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Image saved successfully!',
              style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width * 0.035),
            ),
            backgroundColor: const Color(0xFFFF3A44),
          ),
        );
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'already_active') {
        print('Image picker already active, ignoring call');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error picking image: $e',
              style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width * 0.035),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

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
          'Edit Profile',
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
          child: Form(
            key: _formKey,
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
                        children: [
                          GestureDetector(
                            onTap: _isPickingImage ? null : _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.01),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey, width: 2),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: isTablet ? screenWidth * 0.15 : screenWidth * 0.12,
                                    backgroundImage: _profileImagePath != null &&
                                            File(_profileImagePath!).existsSync()
                                        ? FileImage(File(_profileImagePath!))
                                        : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                  if (_isPickingImage)
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF3A44)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Text(
                            'Tap to change profile picture',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16 : screenWidth * 0.035,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(0xFFFF3A44),
                                fontSize: isTablet ? 18 : screenWidth * 0.04,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFFFF3A44), width: 2),
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18 : screenWidth * 0.04,
                              color: Colors.black87,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                                    side: const BorderSide(color: Color(0xFFFF3A44), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 18 : screenWidth * 0.04,
                                      color: const Color(0xFFFF3A44),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                    ),
                                    backgroundColor: const Color(0xFFFF3A44),
                                  ),
                                  child: Text(
                                    'Save',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 18 : screenWidth * 0.04,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

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