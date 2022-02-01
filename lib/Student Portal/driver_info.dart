import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sucarpooling/responsive.dart';

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
  String _book = "Book Now";
  bool _boolButton = true;
  Razorpay _razorpay = Razorpay();

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

  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  getData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    finalMail = sharedPreferences.getString("email")!;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      seats = seats - 1;
    });
    print("Sucess");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              "Book a seat",
              style: GoogleFonts.salsa(
                  fontSize: Responsive.isSmallMobile(context) ? 30 : 40,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            Card(
              elevation: 8,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
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
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.driverModel.driverName,
                              style: GoogleFonts.salsa(
                                fontSize:
                                    Responsive.isSmallMobile(context) ? 25 : 35,
                                color: Colors.black,
                              )),
                          const Spacer(),
                          if (widget.driverModel.occupation == "Student")
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.asset(
                                "images/std.png",
                                height:
                                    Responsive.isSmallMobile(context) ? 35 : 50,
                              ),
                            ),
                          if (widget.driverModel.occupation == "Faculty")
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.asset(
                                "images/fac.png",
                                height:
                                    Responsive.isSmallMobile(context) ? 35 : 50,
                              ),
                            ),
                        ],
                      ),
                      Text(widget.driverModel.sysID,
                          style: GoogleFonts.salsa(
                            fontSize:
                                Responsive.isSmallMobile(context) ? 15 : 20,
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
                                    Responsive.isSmallMobile(context) ? 15 : 20,
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
                          Text("   " + widget.driverModel.city,
                              style: GoogleFonts.salsa(
                                fontSize:
                                    Responsive.isSmallMobile(context) ? 15 : 20,
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
                                  widget.driverModel.driverCar +
                                  " " +
                                  widget.driverModel.carNumber,
                              style: GoogleFonts.salsa(
                                fontSize:
                                    Responsive.isSmallMobile(context) ? 15 : 20,
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
                      borderRadius: BorderRadius.circular(10)),
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
                        fontSize: Responsive.isSmallMobile(context) ? 16 : 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "images/std.png",
                            height: Responsive.isSmallMobile(context) ? 20 : 30,
                          ),
                          Text(
                            "Student ",
                            style: GoogleFonts.salsa(fontSize: 25),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "images/fac.png",
                            height: Responsive.isSmallMobile(context) ? 20 : 30,
                          ),
                          Text(
                            "Faculty ",
                            style: GoogleFonts.salsa(fontSize: 25),
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
    );
  }
}
