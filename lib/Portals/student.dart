import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sucarpooling/Student%20Portal/driver_register.dart';
import 'package:sucarpooling/Student%20Portal/home_student.dart';

import '../login.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          const StudentHomePage(),
          const CarRegister(),
          Container(
            color: Colors.green,
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
                  Get.offAll(const LoginPage());
                },
                child: const Text("Logout"),
              ),
            ),
          ),
        ],
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.apps),
            title: const Text('Home'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.drive_eta_rounded),
            title: const Text('Driver'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.feedback_outlined),
            title: const Text('Feedback'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
