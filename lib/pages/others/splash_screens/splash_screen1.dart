import 'package:flutter/material.dart';
import 'package:taste_scape1/pages/others/splash_screens/splash_screen2.dart';

void main() {
  runApp(SplashScreen1());
}

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen1> {
  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Navigate to SplashScreen2 on tap
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen2()),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: screenHeight * 0.1), // 10% top padding
                  child: Container(
                    height: screenHeight * 0.7, // 70% of screen height
                    width: screenWidth * 0.85, // 85% of screen width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth *
                          0.05), // Border radius: 5% of screen width
                      image: const DecorationImage(
                        image: AssetImage("assets/p1.jpg"), // Background image
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Make Your Diet Plan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth *
                              0.1, // Font size: 10% of screen width
                          fontWeight: FontWeight.bold,
                          shadows: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
