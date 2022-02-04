import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sucarpooling/components/booking_list.dart';
import 'package:sucarpooling/qr_scanner.dart';
import 'package:sucarpooling/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class CarRegister extends StatefulWidget {
  const CarRegister({Key? key}) : super(key: key);

  @override
  _CarRegisterState createState() => _CarRegisterState();
}

List registerCarList = [];
int totalCar = 0;
String finalMail = "";

class _CarRegisterState extends State<CarRegister>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabIndex);
    getCarData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  getCarData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    finalMail = sharedPreferences.getString("email")!;
    var url = Uri.parse("https://guam-monoliths.000webhostapp.com/car.php");
    var response =
        await http.post(url, body: {"email": 'rishu25bansal@gmail.com'});

    try {
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            registerCarList = jsonDecode(response.body);
          });
        }
        return registerCarList;
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.black87,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black87),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black87, width: 2)),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Booking Details"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black87, width: 2)),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Registered Cars"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                BookingDetails(),
                ListCar(),
              ]),
          floatingActionButton: _bottomButtons(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }

  Widget _bottomButtons() {
    return _tabController.index == 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: "startride",
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  label: const Text("Start Riding"),
                  icon: const Icon(
                    Icons.arrow_circle_up,
                    size: 20.0,
                  ),
                ),
                FloatingActionButton.extended(
                  heroTag: "scanQr",
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: const QRCodeScanner()));
                  },
                  backgroundColor: Colors.blue,
                  label: const Text("Scan QR Code"),
                  icon: const Icon(
                    Icons.qr_code_2,
                    size: 20.0,
                  ),
                )
              ],
            ),
          )
        : FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Colors.blue,
            label: const Text("Add Car"),
            icon: const Icon(
              Icons.add,
              size: 20.0,
            ),
          );
  }
}

class ListCar extends StatelessWidget {
  const ListCar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List getlistCar = registerCarList;
    Future getFinallistCar() async {
      if (getlistCar.isNotEmpty) {
        return getlistCar;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.9,
          child: FutureBuilder(
              future: getFinallistCar(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: registerCarList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Card(
                            color: Colors.transparent,
                            shadowColor: Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(colors: [
                                    HexColor("D5D0E5"),
                                    HexColor("F3E6E8"),
                                  ])),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 20, bottom: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            registerCarList[index]["carname"] +
                                                " : ",
                                            style: GoogleFonts.salsa(
                                                color: Colors.black,
                                                fontSize:
                                                    Responsive.isSmallMobile(
                                                            context)
                                                        ? 15
                                                        : 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            registerCarList[index]["carumber"],
                                            style: GoogleFonts.salsa(
                                                color: Colors.black,
                                                fontSize:
                                                    Responsive.isSmallMobile(
                                                            context)
                                                        ? 15
                                                        : 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.edit))
                                        ],
                                      ),
                                      Text(
                                          "System ID : " +
                                              registerCarList[index]["sysid"],
                                          style: GoogleFonts.salsa(
                                              color: Colors.black,
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Location : " +
                                              registerCarList[index]
                                                  ["location"],
                                          style: GoogleFonts.salsa(
                                              color: Colors.black,
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Time : " +
                                              registerCarList[index]["time"],
                                          style: GoogleFonts.salsa(
                                              color: Colors.black,
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Seats : " +
                                              registerCarList[index]["seats"],
                                          style: GoogleFonts.salsa(
                                              color: Colors.black,
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Price : " +
                                              registerCarList[index]["price"],
                                          style: GoogleFonts.salsa(
                                              color: Colors.black,
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            elevation: 10,
                                            color: Colors.black,
                                            onPressed: () {},
                                            child: Text(
                                              "Register car",
                                              style: GoogleFonts.salsa(
                                                  fontSize:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 16
                                                          : 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            elevation: 10,
                                            color: Colors.redAccent.shade700,
                                            onPressed: () {},
                                            child: Text(
                                              "Remove car",
                                              style: GoogleFonts.salsa(
                                                  fontSize:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 16
                                                          : 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        );
                      });
                }
                return Center(
                  child: Image.asset(
                    "images/emptyactiveBooking.png",
                    height: 250,
                  ),
                );
              })),
    );
  }
}

class BookingDetails extends StatelessWidget {
  const BookingDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future finalBookingList() async {
      if (bookingList.isNotEmpty) {
        return bookingList;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.9,
        child: FutureBuilder(
          future: finalBookingList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: bookingList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.blue,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                HexColor("D5D0E5"),
                                HexColor("F3E6E8"),
                              ])),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 20, bottom: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        bookingList[index].name,
                                        style: GoogleFonts.salsa(
                                            color: Colors.black,
                                            fontSize: Responsive.isSmallMobile(
                                                    context)
                                                ? 15
                                                : 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      if (bookingList[index].status == "verify")
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Image.asset(
                                            "images/8777_Approval.gif",
                                            height: 30,
                                          ),
                                        ),
                                      if (bookingList[index].status ==
                                          "unverify")
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Image.asset(
                                            "images/pngwing.com.png",
                                            height: 30,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "System ID : " + bookingList[index].sysID,
                                      style: GoogleFonts.salsa(
                                          color: Colors.black,
                                          fontSize:
                                              Responsive.isSmallMobile(context)
                                                  ? 16
                                                  : 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "Phone Number : " +
                                          bookingList[index].phoneNumber,
                                      style: GoogleFonts.salsa(
                                          color: Colors.black,
                                          fontSize:
                                              Responsive.isSmallMobile(context)
                                                  ? 16
                                                  : 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 10,
                                        color: Colors.black,
                                        onPressed: () async {
                                          var url = "+91" +
                                              bookingList[index].phoneNumber;

                                          await launch('tel:$url');
                                        },
                                        child: Text(
                                          "Call now",
                                          style: GoogleFonts.salsa(
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 10,
                                        color: Colors.redAccent.shade700,
                                        onPressed: () {},
                                        child: Text(
                                          "Cancel Seat",
                                          style: GoogleFonts.salsa(
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 16
                                                      : 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return Center(
              child: Image.asset(
                "images/emptyactiveBooking.png",
                height: 250,
              ),
            );
          },
        ),
      ),
    );
  }
}
