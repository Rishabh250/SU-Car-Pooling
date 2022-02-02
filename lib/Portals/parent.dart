import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sucarpooling/Map/main_map.dart';
import 'package:sucarpooling/ParentPortal/home_parent.dart';

import '../login.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({Key? key}) : super(key: key);

  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  int _currentIndex = 0;

  List listofBody = [
    ParentHomePage(),
    Container(
      color: Colors.blue,
    ),
    Scaffold(
      body: MainMap(),
    ),
    Container(
      color: Colors.yellow,
      child: Center(
        child: MaterialButton(
          onPressed: () async {
            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            sharedPreferences.remove("email");
            sharedPreferences.remove("page");
            Get.offAll(LoginPage());
          },
          child: const Text("Logout"),
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listofBody[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.transparent,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.apps),
            title: const Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.people),
            title: const Text('Student'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.track_changes),
            title: const Text(
              'Live Tracking',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
