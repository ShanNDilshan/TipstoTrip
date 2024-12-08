import 'package:flutter/material.dart';
import 'package:prototype/pages/BlankPage.dart';
import 'package:prototype/pages/HomePage.dart';
import 'package:prototype/pages/Profile/ProfilePage.dart';
import 'package:prototype/pages/showbusinesstwo.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  List Pages = [
    const HomePage(),
    const ShowBusinesstwoPage(),
    const BlankPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        unselectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        selectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 7, 61, 106)),
        selectedLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        showSelectedLabels: true,
        unselectedLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home,
            ),
          ),
          const BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Icons.person_add,
            ),
          ),
          const BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Icons.people_alt_rounded,
            ),
          ),
          const BottomNavigationBarItem(
            label: "user",
            icon: Icon(
              Icons.person_2_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
