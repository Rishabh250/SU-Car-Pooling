// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:sucarpooling/responsive.dart';
import 'dart:math';
import '../login.dart';

class MailSender extends StatefulWidget {
  const MailSender({Key? key}) : super(key: key);

  @override
  _MailSenderState createState() => _MailSenderState();
}

class _MailSenderState extends State<MailSender> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mail = TextEditingController();
  TextEditingController getOtp = TextEditingController();
  var email;
  var textOtp = "Send OTP";
  var textOtpVerify = "Verify OTP";
  var generatedOtp, verifyOTP;
  bool _visible = false;
  bool _visible02 = false;
  bool _isButtonDisabled = true;

  sendMail() async {
    String username = 'rishu25bansal@gmail.com';
    String password = 'Rishabh25Bansal@';
    var finalMail = mail.text;

    if (finalMail.isEmpty) {
      setState(() {
        _visible = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "\n Enter Sharda Mail ID \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ));
    } else {
      final smtpServer = gmail(username, password);
      random(min, max) {
        var rn = Random();
        return min + rn.nextInt(max - min);
      }

      generatedOtp = random(1000, 9999);

      final message = Message()
        ..from = Address(username)
        ..recipients.add(mail.text)
        ..subject = 'Sharda Car Pooling \nOTP for Password Reset   😀'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html =
            "<p> Hello $finalMail your OTP has been generated for password reset link.,\n <h1> OTP : $generatedOtp</h1>\n It will expire in 10 minutes.</p>";

      try {
        final sendReport = await send(message, smtpServer);
        otpsended();
      } on MailerException catch (e) {
        for (var p in e.problems) {}
      }
    }
  }

  otpsended() async {
    textOtp = "OTP Sended";
    setState(() {
      _isButtonDisabled = false;
      _visible = false;
      Timer(const Duration(seconds: 10), () {
        setState(() {
          textOtp = "Resend OTP";
        });
      });

      Timer(const Duration(minutes: 2), () {
        setState(() {
          generatedOtp = "";
        });
      });
    });
  }

  verifyOPT() {
    if (getOtp.text.isEmpty) {}
    if (generatedOtp == "") {
      setState(() {
        textOtpVerify = "OTP Expired";
      });
      Timer(const Duration(seconds: 10), () {
        setState(() {
          textOtpVerify = "Verify OTP";
        });
      });
    }
    if (getOtp.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "\n Enter OTP\n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _visible02 = false;
      });
    } else {
      var one = int.parse(getOtp.text);
      if (one != generatedOtp) {
        setState(() {
          _visible02 = false;
          textOtpVerify = "Invalid OTP";
        });
      }
      if (one == generatedOtp) {
        setState(() {
          _visible02 = false;
          textOtpVerify = "OTP Verified";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            "\n OTP Verified \n",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          backgroundColor: Colors.green,
        ));
        Timer(
            const Duration(seconds: 5),
            () => Navigator.pushReplacement((context),
                MaterialPageRoute(builder: (context) => const LoginPage())));
      }
      Timer(const Duration(seconds: 20), () {
        setState(() {
          _visible02 = false;
          textOtpVerify = "Verify OTP";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: const Color.fromRGBO(10, 34, 85, 1),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.isSmallMobile(context) ? 30 : 60,
                ),
                Center(
                  child: Image.asset(
                    "images/shardaLogo.png",
                    height: Responsive.isSmallMobile(context) ? 80 : 100,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "Forget Password",
                    style: TextStyle(
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(0, 2.5),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Shadow(
                            blurRadius: 8.0,
                            color: Color.fromARGB(125, 0, 0, 255),
                          ),
                        ],
                        color: Colors.white,
                        fontSize: Responsive.isSmallMobile(context) ? 25 : 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(
                                1, 7), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Sharda Mail ID",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            Responsive.isSmallMobile(context)
                                                ? 16
                                                : 20),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.transparent,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 1.5,
                                            blurRadius: 4,
                                            offset: const Offset(2, 7),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(40),
                                            bottomRight: Radius.circular(40)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            left: 0.0,
                                            right: 5.0,
                                            bottom: 8),
                                        child: TextFormField(
                                          onChanged: (value) {
                                            email = value;
                                          },
                                          controller: mail,
                                          style: TextStyle(
                                              fontSize:
                                                  Responsive.isSmallMobile(
                                                          context)
                                                      ? 15
                                                      : 17,
                                              fontWeight: FontWeight.bold),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(Icons.email),
                                          ),
                                        ),
                                      ))),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 180,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(1, 7),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: FlatButton(
                          splashColor: Colors.blue.shade400,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          onPressed: () {
                            setState(() {
                              _visible = true;
                            });
                            sendMail();
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                textOtp,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.arrow_right_rounded,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Visibility(
                          visible: _visible,
                          child: Tab(
                            child: LoadingBouncingLine.circle(
                              size: 50,
                              backgroundColor: Colors.white,
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(0, 2.5),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Shadow(
                            blurRadius: 8.0,
                            color: Color.fromARGB(125, 0, 0, 255),
                          ),
                        ],
                        color: Colors.white,
                        fontSize: Responsive.isSmallMobile(context) ? 25 : 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset:
                              const Offset(1, 7), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Form(
                      child: Column(children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1.5,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            2, 7), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 0.0,
                                        right: 25.0,
                                        bottom: 8),
                                    child: TextFormField(
                                      controller: getOtp,
                                      style: TextStyle(
                                          fontSize:
                                              Responsive.isSmallMobile(context)
                                                  ? 15
                                                  : 17,
                                          fontWeight: FontWeight.bold),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.password),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 50,
                            width: 180,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(1, 7),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            child: FlatButton(
                              splashColor: Colors.blue.shade400,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              onPressed: _isButtonDisabled
                                  ? null
                                  : () {
                                      setState(() {
                                        _visible02 = true;
                                      });
                                      verifyOPT();
                                    },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    textOtpVerify,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(
                                    Icons.arrow_right_rounded,
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Visibility(
                            visible: _visible02,
                            child: Tab(
                              child: LoadingBouncingLine.circle(
                                size: 50,
                                backgroundColor: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }
}
