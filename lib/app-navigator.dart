import 'package:flutter/material.dart';
import 'package:socials/screens/home/home.dart';
import 'package:socials/screens/post/create-post.dart';
import 'package:socials/screens/profile/profile.dart';

class ApplicationNavigation extends StatefulWidget {
  @override
  _ApplicationNavigationState createState() => _ApplicationNavigationState();
}

class _ApplicationNavigationState extends State<ApplicationNavigation> {
  int _selectedIndex = 0;

  // This method will be called whenever a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of widgets to display in each tab
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    CreatePost(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
       const   BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon:  Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange, // Custom background
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8), // Custom padding
                    child: const Icon(
                      Icons.add,
                      size: 35, // Custom icon size
                      color: Colors.white, // Custom icon color
                    ),
                  ),
              
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
