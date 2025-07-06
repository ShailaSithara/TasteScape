import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

