import 'package:flutter/material.dart';
import 'package:taste_scape1/features/my_recipe/add_recipe.dart';
import 'package:taste_scape1/features/my_recipe/my_recipe.dart';
import 'package:taste_scape1/pages/discover.dart';
import 'package:taste_scape1/pages/profile.dart';

class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({Key? key}) : super(key: key);

  @override
  State<ResponsiveHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<ResponsiveHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const DiscoverPage(),
    AddRecipePage(),
    const MyRecipePage(), 
    ProfilePage(),
  ];
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
  title: const Text(
    'TasteScape',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 26,
    ),
  ),
  centerTitle: true,
  backgroundColor: const Color(0xFFFF2045),
  automaticallyImplyLeading: false,
),


      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, 
        onTap: _onTabTapped, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor:  const Color(0xFFFF2045),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}


