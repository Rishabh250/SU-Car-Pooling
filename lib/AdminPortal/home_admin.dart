// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  var studentLength, facultyLength;
  String fN = "Faculty has";
  String sN = "Student has";
  String stdText = "Getting Info ...";
  String ftText = "Getting Info ...";
  String finalName = "";
  List studentList = [];
  List facultyList = [];

  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    getData();
    getStudentData();
    getFacultyData();
    super.initState();
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    getStudentData();
    getFacultyData();
    getData();
  }

  getStudentData() async {
    String url = "https://guam-monoliths.000webhostapp.com/student_data.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      if (mounted) {
        setState(() {
          studentList = jsonDecode(res.body);
        });
      }

      Timer(const Duration(seconds: 2), () {
        setState(() {
          stdText = "$studentLength $sN Login Issue";
        });
      });

      studentLength = studentList.length;
      if (studentLength > 1) {
        setState(() {
          sN = "Students have";
        });
      } else {
        setState(() {
          sN = "Student has";
        });
      }

      return studentList;
    }
  }

  getFacultyData() async {
    String url02 = "https://guam-monoliths.000webhostapp.com/faculty_data.php";
    var res02 = await http.post(Uri.parse(url02));
    if (res02.statusCode == 200) {
      if (mounted) {
        setState(() {
          facultyList = jsonDecode(res02.body);
        });
      }
      facultyLength = facultyList.length;
      if (facultyLength > 1) {
        setState(() {
          fN = "Faculties have";
        });
      } else {
        setState(() {
          fN = "Faculty has";
        });
      }

      Timer(const Duration(seconds: 2), () {
        setState(() {
          ftText = "$facultyLength $fN Login Issue";
        });
      });

      return facultyList;
    }
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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  refreshList();
                },
                icon: const Icon(Icons.refresh_outlined)),
          ],
          title: Text(
            "Hi, $finalName",
            style: GoogleFonts.salsa(
              fontSize: 25,
            ),
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Student Login Issue",
                                    style: GoogleFonts.salsa(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (studentLength == 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Text(
                                      "No Pending Issues",
                                      style: GoogleFonts.salsa(
                                          fontSize: 18, color: Colors.green),
                                    ),
                                  ),
                                if (studentLength != 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Text(
                                      stdText,
                                      style: GoogleFonts.salsa(
                                          fontSize: 18, color: Colors.red),
                                    ),
                                  )
                              ],
                            ),
                          );
                        })),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Faculty Login Issue",
                                    style: GoogleFonts.salsa(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (facultyLength == 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Text(
                                      "No Pending Issues",
                                      style: GoogleFonts.salsa(
                                          fontSize: 18, color: Colors.green),
                                    ),
                                  ),
                                if (facultyLength != 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Text(
                                      ftText,
                                      style: GoogleFonts.salsa(
                                          fontSize: 18, color: Colors.red),
                                    ),
                                  )
                              ],
                            ),
                          );
                        })),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Faculty Login Issue",
                                    style: GoogleFonts.salsa(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (facultyLength == 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Text(
                                      "No Pending Issues",
                                      style: GoogleFonts.salsa(
                                          fontSize: 18, color: Colors.green),
                                    ),
                                  ),
                                if (facultyLength != 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Text(
                                      ftText,
                                      style: GoogleFonts.salsa(
                                          fontSize: 18, color: Colors.red),
                                    ),
                                  )
                              ],
                            ),
                          );
                        })),
              ),
            ),
          ],
        ));
  }
}
