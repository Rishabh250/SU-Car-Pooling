import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sucarpooling/Map/mymap.dart';

import 'package:sucarpooling/responsive.dart';
import '../login.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  String finalName = "";
  var userID;
  var userID2;

  @override
  void initState() {
    getData();
    getCurrentLocation();
    getLiveLocation();
    super.initState();
  }

  getCurrentLocation() {
    FirebaseFirestore.instance
        .collection('location')
        .doc("Rishabh")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userID = documentSnapshot.id;
      }
    });
  }

  getLiveLocation() {
    FirebaseFirestore.instance
        .collection('location')
        .doc("2021302586")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userID2 = documentSnapshot.id;
      }
    });
  }

  getData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.getString("email");
    final SharedPreferences sharedPreferences03 =
        await SharedPreferences.getInstance();
    sharedPreferences03.getString("table");

    String url = "https://guam-monoliths.000webhostapp.com/fetch_data.php";
    var data = {
      "email": sharedPreferences.getString("email"),
      "table": sharedPreferences03.getString("table")
    };

    var res = await http.post(Uri.parse(url), body: data);
    var responseBody = jsonDecode(res.body);
    setState(() {
      finalName = responseBody;
    });
    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.grey.shade300,
          actions: [
            IconButton(
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();

                  sharedPreferences.remove("email");
                  sharedPreferences.remove("page");
                  Get.offAll(const LoginPage());
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
          title: Text(
            "Hi, $finalName",
            style: TextStyle(
                color: Colors.black,
                fontSize: Responsive.isSmallMobile(context) ? 20 : 25),
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        body: SizedBox(
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(20)),
                        width: _width * 0.9,
                        height: 200,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      getCurrentLocation();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyMap(userID)));
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20)),
                          width: _width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Text(
                                  "Track Current Location",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                const Icon(Icons.directions),
                              ],
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      getLiveLocation();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyMap(userID2)));
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20)),
                          width: _width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Text(
                                  "Track Live Location",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                const Icon(Icons.directions),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            )));
  }
}
