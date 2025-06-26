import 'package:flutter/material.dart';
import 'package:taste_scape1/auth/login.dart';
import 'package:taste_scape1/auth/register_page.dart';
void main() {
  runApp(const SplashScreen4());
}

class SplashScreen4 extends StatefulWidget {
  const SplashScreen4({super.key});

  @override
  State<SplashScreen4> createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/image.png',
            fit: BoxFit.cover,
          ),
          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title Card
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.025),
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    image: const DecorationImage(
                      image: AssetImage("assets/p4.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Create an Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.142,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Register Button
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 49, 49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Login Prompt
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
