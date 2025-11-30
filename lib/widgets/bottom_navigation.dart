import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/pages/favorites_page.dart';
import 'package:dine_ease/pages/home_screen.dart';
import 'package:dine_ease/pages/reservation_page.dart';
import 'package:dine_ease/pages/search_page.dart';
import 'package:dine_ease/pages/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentTabIndex = 0;

  List<Widget> pages = const [
    HomeScreen(),
    SearchPage(),
    ReservationPage(),
    FavouritePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        buttonBackgroundColor: const Color.fromARGB(221, 0, 0, 0),
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        color: const Color.fromARGB(255, 17, 36, 55),
        backgroundColor: const Color.fromARGB(148, 84, 60, 34),
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(
            Icons.restaurant_menu,
            color: Colors.white70,
            size: 21,
          ),
          Icon(
            Icons.search,
            color: Colors.white70,
            size: 21,
          ),
          Icon(
            Icons.room_service,
            color: Colors.white70,
            size: 21,
          ),
          Icon(
            Icons.favorite_outline,
            color: Colors.white70,
            size: 21,
          ),
          Icon(
            Icons.person,
            color: Colors.white70,
            size: 21,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
