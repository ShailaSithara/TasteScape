import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taste_scape1/pages/others/splash_screens/splash_screen1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    // Set the duration for the splash screen
    var duration = Duration(seconds: 3);
    // Navigate to the next screen after the duration
    Timer(duration, route);
  }

  route() {
    // Navigate to the next screen (SplashScreen1)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/image.png',
            fit: BoxFit.cover,
          ),
          // Centered logo/image
          Center(
            child: Image.asset(
              'assets/image1.png',
              width: 300,
            ),
          ),
        ],
      ),
    );
  }
}
