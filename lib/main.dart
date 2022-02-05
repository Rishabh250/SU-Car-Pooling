import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:sucarpooling/responsive.dart';
import 'InternetConnectivity/net_connection.dart';
import 'package:get/get.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          theme: ThemeData.light(),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final checkConnection = CheckConnection();
  @override
  void initState() {
    super.initState();
    nextPage();
  }

  void nextPage() async {
    if (await checkConnection.checkInternet()) {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: const LoginPage())));
    } else {
      Timer(
        const Duration(seconds: 2),
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              "\n No Internet Connection \n",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            backgroundColor: Colors.red,
          ),
        ),
      );
      Timer(
          const Duration(seconds: 8),
          () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: const MyApp())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.indigo.shade900,
          child: Center(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "images/shardaLogo.png",
                      height: Responsive.isSmallMobile(context) ? 80 : 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Sharda University",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isSmallMobile(context) ? 30 : 40,
                      ),
                    ),
                    Text(
                      "Car Pooling",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isSmallMobile(context) ? 30 : 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                Column(
                  children: [
                    const Text(
                      "Car Pooling Service for Shardians",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Tab(
                      child: LoadingBouncingLine.circle(
                        size: 50,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
