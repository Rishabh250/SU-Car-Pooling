import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  var scafflodKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late ScrollController scrollController01, scrollController02;

  @override
  void initState() {
    scrollController01 = ScrollController();
    scrollController02 = ScrollController();
    getData();
    carDetails = getDelhiCars;
    cityList = cityInfo;

    super.initState();
  }

  String finalName = "";
  String getFirstLetter = "";

  int hometown = 0;
  List carDetails = [];
  List cityList = [];

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
      finalName = responseBody['name'];
      getFirstLetter = finalName[0];
    });
    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: scafflodKey,
        drawer: Drawer(
          backgroundColor: Colors.grey.shade200,
          elevation: 8,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                  width: _width * 0.7,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        finalName,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      QrImage(
                        data: finalName,
                        version: QrVersions.auto,
                        size: 130.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Driver will confirm your seat by this QR Code.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.amber,
                ),
                title: const Text(
                  'My Profile',
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.history_toggle_off,
                  color: Colors.green,
                ),
                title: const Text('Booking History'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  color: Colors.orange,
                ),
                title: const Text('Payment Methods'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                ),
                title: const Text('Logout'),
                onTap: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove("email");
                  sharedPreferences.remove("page");
                  Get.offAll(const LoginPage());
                },
              ),
            ]),
          ),
        ),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: () {
                scafflodKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Center(
                    child: Text(
                  getFirstLetter,
                  style: GoogleFonts.poppins(
                      fontSize: Responsive.isSmallMobile(context) ? 15 : 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "Sharda University".toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Responsive.isSmallMobile(context) ? 16 : 22),
              ),
              Text(
                "Car Pooling".toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Responsive.isSmallMobile(context) ? 12 : 18),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_rounded,
                    size: Responsive.isSmallMobile(context) ? 25 : 30,
                  )),
            )
          ],
        ),
        backgroundColor: Colors.blue,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification
              overscrollIndicatorNotification) {
            overscrollIndicatorNotification.disallowGlow();
            return true;
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  child: Container(
                    width: _width * 0.5,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Promocode : ".toUpperCase(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.isSmallMobile(context)
                                      ? 10
                                      : 15)),
                          Text("Shardians".toUpperCase(),
                              style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.isSmallMobile(context)
                                      ? 10
                                      : 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.9,
                maxChildSize: 1,
                minChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: 60,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          height: _height * 0.24,
                                          width: _width * 0.9,
                                          child: Swiper(
                                            pagination: const SwiperPagination(
                                                alignment:
                                                    Alignment.bottomRight),
                                            viewportFraction: 1,
                                            onIndexChanged: (int index) =>
                                                setState(() {
                                              hometown = index;
                                              carChange();
                                              carPageReset();
                                            }),
                                            itemCount: cityList.length,
                                            itemWidth: _width * 0.9,
                                            layout: SwiperLayout.STACK,
                                            itemBuilder: (_, i) {
                                              return Card(
                                                color: Colors.transparent,
                                                semanticContainer: true,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                elevation: 5,
                                                margin: const EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.24,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        color: Colors.black,
                                                        child: Opacity(
                                                            opacity: 0.25,
                                                            child:
                                                                _homeImage[i])),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 10.0,
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            cityList[i]
                                                                .cityName,
                                                            style: GoogleFonts.salsa(
                                                                fontSize: Responsive
                                                                        .isSmallMobile(
                                                                            context)
                                                                    ? 23
                                                                    : 30,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          SizedBox(
                                                            height: Responsive
                                                                    .isSmallMobile(
                                                                        context)
                                                                ? 10
                                                                : 30,
                                                          ),
                                                          Text(
                                                            cityList[i]
                                                                .aboutCity,
                                                            maxLines: 5,
                                                            style: GoogleFonts.salsa(
                                                                fontSize: Responsive
                                                                        .isSmallMobile(
                                                                            context)
                                                                    ? 9
                                                                    : 14,
                                                                color: Colors
                                                                    .white38),
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
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ShaderMask(
                                                    shaderCallback:
                                                        (Rect rect) {
                                                      return const LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.purple,
                                                          Colors.transparent,
                                                          Colors.transparent,
                                                          Colors.purple
                                                        ],
                                                        stops: [
                                                          0.0,
                                                          0.1,
                                                          0.9,
                                                          1.0
                                                        ], // 10% purple, 80% transparent, 10% purple
                                                      ).createShader(rect);
                                                    },
                                                    blendMode: BlendMode.dstOut,
                                                    child: ListView.builder(
                                                      itemCount:
                                                          carDetails.length,
                                                      controller:
                                                          _pageController,
                                                      itemBuilder: (index, j) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Card(
                                                            elevation: 8,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      gradient:
                                                                          LinearGradient(
                                                                              colors: [
                                                                            HexColor("D5D0E5"),
                                                                            HexColor("F3E6E8"),
                                                                          ])),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        left:
                                                                            20,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          carDetails[j].driverCar! +
                                                                              " : ",
                                                                          style: GoogleFonts.salsa(
                                                                              color: Colors.black,
                                                                              fontSize: Responsive.isSmallMobile(context) ? 15 : 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          carDetails[j]
                                                                              .carNumber!,
                                                                          maxLines:
                                                                              2,
                                                                          style: GoogleFonts.salsa(
                                                                              color: Colors.black,
                                                                              fontSize: Responsive.isSmallMobile(context) ? 15 : 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        const Spacer(),
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: 10.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.verified_user,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      carDetails[
                                                                              j]
                                                                          .driverName!,
                                                                      style: GoogleFonts.salsa(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: Responsive.isSmallMobile(context)
                                                                              ? 16
                                                                              : 20,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "Price : ",
                                                                          style: GoogleFonts.salsa(
                                                                              color: Colors.black,
                                                                              fontSize: Responsive.isSmallMobile(context) ? 16 : 20,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        Text(
                                                                          carDetails[j]
                                                                              .price!,
                                                                          style: GoogleFonts.salsa(
                                                                              color: Colors.black,
                                                                              fontSize: Responsive.isSmallMobile(context) ? 16 : 20,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    MaterialButton(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      elevation:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      onPressed:
                                                                          () {
                                                                        print(carDetails[j]
                                                                            .driverName);
                                                                        print(cityList[hometown]
                                                                            .cityName);
                                                                        Navigator.push(
                                                                            context,
                                                                            PageTransition(
                                                                                type: PageTransitionType.fade,
                                                                                child: DriverInfo(
                                                                                  driverModel: carDetails[j],
                                                                                )));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Book Now",
                                                                        style: GoogleFonts.salsa(
                                                                            fontSize: Responsive.isSmallMobile(context)
                                                                                ? 16
                                                                                : 20,
                                                                            color:
                                                                                Colors.white,
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
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
