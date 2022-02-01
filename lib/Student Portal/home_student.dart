import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:sucarpooling/Student%20Portal/driver_info.dart';
import 'package:sucarpooling/components/bsr_car.dart';
import 'package:sucarpooling/components/city_info.dart';
import 'package:sucarpooling/components/delhi_cars.dart';
import 'package:sucarpooling/components/nodia_cars.dart';
import 'package:sucarpooling/components/sk_car.dart';
import 'package:sucarpooling/responsive.dart';
import '../login.dart';
import 'package:hexcolor/hexcolor.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  String finalName = "";
  int _cars = 0;
  int hometown = 0;
  var city, car;
  List carDetails = [];
  List cityList = [];
  final List<String> _homeTown = [
    "Bulandshahr",
    "Sikandrabad",
    "Nodia",
    "Delhi"
  ];

  List bsrCarList = [];

  final List<Image> _homeImage = [
    Image.asset(
      "images/dl.jpg",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "images/gn.jpg",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "images/bsr.jpg",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "images/skn.jpg",
      fit: BoxFit.cover,
    ),
  ];

  @override
  void initState() {
    getData();
    carDetails = getDelhiCars;
    cityList = cityInfo;

    super.initState();
  }

  carChange() {
    if (hometown == 0) {
      carDetails = getDelhiCars;
    }
    if (hometown == 1) {
      carDetails = getNoidaCars;
    }
    if (hometown == 2) {
      carDetails = getBSRCars;
    }
    if (hometown == 3) {
      carDetails = getSKCars;
    }
  }

  void carPageReset() {
    _pageController.jumpToPage(0);
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
      body: SingleChildScrollView(
        physics: Responsive.isSmallMobile(context)
            ? null
            : const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Home Town",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Responsive.isSmallMobile(context) ? 25 : 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Swiper(
                  pagination:
                      const SwiperPagination(alignment: Alignment.bottomRight),
                  viewportFraction: 1,
                  onIndexChanged: (int index) => setState(() {
                    hometown = index;
                    carChange();
                    carPageReset();
                  }),
                  itemCount: cityList.length,
                  itemWidth: MediaQuery.of(context).size.width * 0.9,
                  layout: SwiperLayout.STACK,
                  itemBuilder: (_, i) {
                    return Card(
                      color: Colors.transparent,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.24,
                              width: MediaQuery.of(context).size.width * 0.9,
                              color: Colors.black,
                              child:
                                  Opacity(opacity: 0.25, child: _homeImage[i])),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 10, right: 10, bottom: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cityList[i].cityName,
                                  style: GoogleFonts.salsa(
                                      fontSize:
                                          Responsive.isSmallMobile(context)
                                              ? 23
                                              : 30,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: Responsive.isSmallMobile(context)
                                      ? 10
                                      : 30,
                                ),
                                Text(
                                  cityList[i].aboutCity,
                                  maxLines: 5,
                                  style: GoogleFonts.salsa(
                                      fontSize:
                                          Responsive.isSmallMobile(context)
                                              ? 9
                                              : 14,
                                      color: Colors.white38),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Available Cars",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Responsive.isSmallMobile(context) ? 25 : 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    itemCount: carDetails.length,
                    controller: _pageController,
                    itemBuilder: (index, j) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  HexColor("D5D0E5"),
                                  HexColor("F3E6E8"),
                                ])),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 20, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        carDetails[j].driverCar! + " : ",
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 15
                                                : 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        carDetails[j].carNumber!,
                                        maxLines: 2,
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 15
                                                : 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                          Icons.verified_user,
                                          color: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    carDetails[j].driverName!,
                                    style: GoogleFonts.salsa(
                                        color: Colors.black,
                                        fontSize:
                                            Responsive.isSmallMobile(context)
                                                ? 16
                                                : 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Total Seats : ",
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 16
                                                : 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        carDetails[j].seats,
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 16
                                                : 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Price : ",
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 16
                                                : 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        carDetails[j].price!,
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 16
                                                : 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 10,
                                    color: Colors.black,
                                    onPressed: () {
                                      print(carDetails[j].driverName);
                                      print(cityList[hometown].cityName);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DriverInfo(
                                                    driverModel: carDetails[j],
                                                  )));
                                    },
                                    child: Text(
                                      "Book Now",
                                      style: GoogleFonts.salsa(
                                          fontSize:
                                              Responsive.isSmallMobile(context)
                                                  ? 16
                                                  : 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
