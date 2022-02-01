// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List studentList = [];
  List facultyList = [];
  var mail, password;
  var table;

  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getStudentData();
    getFacultyData();
    super.initState();
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    getStudentData();
  }

  Future<void> refreshList02() async {
    await Future.delayed(const Duration(seconds: 1));
    getFacultyData();
  }

  getStudentData() async {
    String url = "https://guam-monoliths.000webhostapp.com/student_data.php";
    var res = await http.get(Uri.parse(url));
    try {
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            studentList = jsonDecode(res.body);
          });
        }

        return studentList;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "\n No Login Issue for Student \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  getFacultyData() async {
    String url02 = "https://guam-monoliths.000webhostapp.com/faculty_data.php";
    var res02 = await http.post(Uri.parse(url02));
    try {
      if (res02.statusCode == 200) {
        if (mounted) {
          setState(() {
            facultyList = jsonDecode(res02.body);
          });
        }

        return facultyList;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "\n No Login Issue for Faculty \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  passwordReset() async {
    String url02 =
        "https://guam-monoliths.000webhostapp.com/password_reset.php";
    var data = {"email": mail, "table": table};
    var res02 = await http.post(Uri.parse(url02), body: data);

    if (jsonDecode(res02.body) == "Password Reset") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "\n Password Reset\n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "\n Unable to Reset \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent.shade700,
          toolbarHeight: 15,
          elevation: 20,
          titleSpacing: 20,
          bottom: const TabBar(
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.people),
                text: "Student",
              ),
              Tab(
                icon: Icon(Icons.people),
                text: "Faculty",
              ),
              Tab(
                icon: Icon(Icons.drive_eta_rounded),
                text: "Driver",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          studentPage(context),
          facultyPage(context),
          driverPage(context),
        ]),
      ),
    );
  }

  Widget studentPage(BuildContext context) => Scaffold(
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshList();
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name : " + studentList[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "E-Mail ID : " +
                                          studentList[index]['email'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    MaterialButton(
                                      highlightColor: Colors.red,
                                      highlightElevation: 10,
                                      color: Colors.pinkAccent.shade100,
                                      elevation: 10,
                                      child: const Text(
                                        "Reset Password",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          mail = studentList[index]["email"];
                                          table = "Student";
                                        });
                                        setState(() {
                                          password =
                                              studentList[index]['password'];
                                        });
                                        passwordReset();
                                        refreshList();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }),
          ),
        ),
      );
  Widget facultyPage(BuildContext context) => Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshList02();
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: facultyList.length,
                itemBuilder: (context, index) {
                  if (facultyList.isEmpty) {
                    return const Center(
                      child: Text("No Data"),
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 2),
                          child: Card(
                            elevation: 10,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name : " + facultyList[index]['name'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "E-Mail ID : " +
                                            facultyList[index]['email'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      MaterialButton(
                                        highlightColor: Colors.red,
                                        highlightElevation: 10,
                                        color: Colors.pinkAccent.shade100,
                                        elevation: 10,
                                        child: const Text(
                                          "Reset Password",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            mail = facultyList[index]["email"];
                                            table = "Faculty";
                                          });
                                          setState(() {
                                            password =
                                                facultyList[index]['password'];
                                          });
                                          passwordReset();
                                          refreshList02();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                }),
          ),
        ),
      );
  Widget driverPage(BuildContext context) => const Center(
        child: Text("Driver Page"),
      );
}
