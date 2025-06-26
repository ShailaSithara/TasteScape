import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taste_scape1/auth/login.dart';
import 'package:taste_scape1/pages/tabs/home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    // Getting screen size for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF2045)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: ListView(
            children: [
              // Title
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF2045),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03), // Responsive spacing

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username field
                    _buildTextField(
                      controller: _usernameController,
                      label: "Username",
                      icon: Icons.person,
                      isPasswordField: false,
                    ),
                    SizedBox(height: screenHeight * 0.02), // Responsive spacing

                    // Email field
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      isPasswordField: false,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Password field
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      isPasswordField: true,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Confirm Password field
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      icon: Icons.lock_outline,
                      isPasswordField: true,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Register button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String username = _usernameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          // Open Hive box
                          var userBox = await Hive.openBox('userBox');

                          // Check if the email already exists
                          bool emailExists = userBox
                              .containsKey(email); // Using email as the key

                          if (emailExists) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Email already in use. Please use a different email.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Save new user to Hive with email as key
                            userBox.put(email, {
                              'username': username,
                              'email': email,
                              'password': password,
                            });

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User registered successfully!'),
                                backgroundColor: Color.fromARGB(255, 36, 134, 39),
                              ),
                            );

                            // Navigate to the next page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResponsiveHomePage()),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2045),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.3,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account? ",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFFFF2045),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build TextField widget for username, email, password, etc.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPasswordField,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordField ? _isPasswordHidden : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF2045)),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  isPasswordField
                      ? (_isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : Icons.visibility,
                  color: const Color(0xFFFF2045),
                ),
                onPressed: () {
                  setState(() {
                    if (isPasswordField) _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF2045)),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }

        if (label == "Username") {
          if (!RegExp(r'^[a-zA-Z0-9_]{3,15}$').hasMatch(value)) {
            return 'Username must be 3–15 characters long and contain only letters, numbers, or underscores.';
          }
        }

        if (label == "Email") {
          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value)) {
            return 'Enter a valid email address.';
          }
        }

        if (label == "Password") {
          if (value.length < 8 ||
              !RegExp(r'[A-Z]').hasMatch(value) || // Uppercase letter
              !RegExp(r'[a-z]').hasMatch(value) || // Lowercase letter
              !RegExp(r'\d').hasMatch(value) || // Digit
              !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
            // Special character
            return 'Password must be at least 8 characters long and include an uppercase letter, lowercase letter, a number, and a special character.';
          }
        }

        if (label == "Confirm Password") {
          if (value != _passwordController.text) {
            return 'Passwords do not match.';
          }
        }

        return null;
      },
    );
  }
}
