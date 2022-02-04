import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sucarpooling/responsive.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;

class DriverInfo extends StatefulWidget {
  final driverModel;
  DriverInfo({Key? key, required this.driverModel}) : super(key: key);

  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  var seats;
  var _buttoncolor = Colors.black;
  String finalMail = "";
  String amount = "";
  var sysID;
  String _book = "Book Now";
  bool _boolButton = true;
  Razorpay _razorpay = Razorpay();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    seats = widget.driverModel.seats;
    print(widget.driverModel.price);
    amount = widget.driverModel.price + "00";

    seats = int.parse(seats);
    getData();
    print(seats);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  getData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.getString("email");
    final SharedPreferences sharedPreferences03 =
        await SharedPreferences.getInstance();
    sharedPreferences03.getString("table");

    finalMail = sharedPreferences.getString("email")!;

    String url = "https://guam-monoliths.000webhostapp.com/fetch_data.php";
    var data = {
      "email": sharedPreferences.getString("email"),
      "table": sharedPreferences03.getString("table")
    };

    var res = await http.post(Uri.parse(url), body: data);
    var responseBody = jsonDecode(res.body);

    setState(() {
      sysID = responseBody['sysID'];
    });
    return responseBody;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      seats = seats - 1;
    });
    _getLocation();
    _listenLocation();
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection(sysID)
          .doc('Current Location')
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
      }, SetOptions(merge: true));
    } catch (e) {}
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection(sysID)
          .doc("Live Location")
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Wallet");
  }

  _bookSeats() {
    print(amount);
    var options = {
      'key': 'rzp_test_XsqSZDutXoetVT',
      'amount': '$amount ',
      'name': 'Sharda Car Pooling',
      'description': 'Payment',
      'prefill': {'contact': '', 'email': '$finalMail'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (seats == 0) {
      _buttoncolor = Colors.grey;
      _book = "Booked";
      _boolButton = false;
    }
  }

  var scafflodKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
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
                  icon: const Icon(
                    Icons.chat_rounded,
                    size: 30,
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
                            Text(
                              "Book a seat",
                              style: GoogleFonts.salsa(
                                  fontSize: Responsive.isSmallMobile(context)
                                      ? 20
                                      : 30,
                                  color: Colors.black),
                            ),
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
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      height: _height,
                      width: _width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        color: Colors.grey.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 8,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        HexColor("D5D0E5"),
                                        HexColor("F3E6E8"),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 20, bottom: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(widget.driverModel.driverName,
                                                style: GoogleFonts.salsa(
                                                  fontSize:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 25
                                                          : 35,
                                                  color: Colors.black,
                                                )),
                                            const Spacer(),
                                            if (widget.driverModel.occupation ==
                                                "Student")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Image.asset(
                                                  "images/std.png",
                                                  height:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 35
                                                          : 50,
                                                ),
                                              ),
                                            if (widget.driverModel.occupation ==
                                                "Faculty")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Image.asset(
                                                  "images/fac.png",
                                                  height:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 35
                                                          : 50,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(widget.driverModel.sysID,
                                            style: GoogleFonts.salsa(
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 15
                                                      : 20,
                                              color: Colors.black,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                "Available Seats : "
                                                        " " +
                                                    "$seats",
                                                style: GoogleFonts.salsa(
                                                  fontSize:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 15
                                                          : 20,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_city_outlined,
                                              color: Colors.purple,
                                            ),
                                            Text(
                                                "   " + widget.driverModel.city,
                                                style: GoogleFonts.salsa(
                                                  fontSize:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 15
                                                          : 20,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.car,
                                              color: Colors.purple,
                                            ),
                                            Text(
                                                "   " +
                                                    widget
                                                        .driverModel.driverCar +
                                                    " " +
                                                    widget
                                                        .driverModel.carNumber,
                                                style: GoogleFonts.salsa(
                                                  fontSize:
                                                      Responsive.isSmallMobile(
                                                              context)
                                                          ? 15
                                                          : 20,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 10,
                                    color: _buttoncolor,
                                    onPressed: () {
                                      if (_boolButton == true) {
                                        _bookSeats();
                                      } else {
                                        return null;
                                      }
                                    },
                                    child: Text(
                                      _book,
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
                              const SizedBox(
                                height: 30,
                              ),
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        HexColor("D5D0E5"),
                                        HexColor("F3E6E8"),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "images/std.png",
                                              height: Responsive.isSmallMobile(
                                                      context)
                                                  ? 20
                                                  : 30,
                                            ),
                                            Text(
                                              "Student ",
                                              style: GoogleFonts.salsa(
                                                  fontSize: 25),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "images/fac.png",
                                              height: Responsive.isSmallMobile(
                                                      context)
                                                  ? 20
                                                  : 30,
                                            ),
                                            Text(
                                              "Faculty ",
                                              style: GoogleFonts.salsa(
                                                  fontSize: 25),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )));
  }
}
