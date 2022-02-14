import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:sucarpooling/responsive.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  QRViewController? controller;
  Barcode? barcode;

  final List _qrList = [
    'Rishabh Bansal',
    '2021302586',
  ];

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  final qrKey = GlobalKey(debugLabel: "QR");

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.blue,
            appBar: AppBar(
              toolbarHeight: 80,
              elevation: 0,
              backgroundColor: Colors.blue,
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification
                  overscrollIndicatorNotification) {
                overscrollIndicatorNotification.disallowGlow();
                return true;
              },
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Text(
                      "QR Code Scanner".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Responsive.isSmallMobile(context) ? 22 : 30),
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
                          child: Stack(
                            children: [
                              Center(child: buildQrView(context)),
                              if (barcode != null) buildSuccessResult(),
                              Positioned(
                                  bottom: 150,
                                  left: 0,
                                  right: 0,
                                  child: Text(
                                    "Scan QR Code to verify passenger",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(),
                                  )),
                              Positioned(
                                bottom: 60,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      color: Colors.blue,
                                      icon: FutureBuilder<bool?>(
                                        future: controller?.getFlashStatus(),
                                        builder: (context, snapshot) {
                                          return Icon(
                                            snapshot.data!
                                                ? Icons.flash_on
                                                : Icons.flash_off,
                                            size: Responsive.isSmallMobile(
                                                    context)
                                                ? 25
                                                : 40,
                                          );
                                        },
                                      ),
                                      onPressed: () async {
                                        await controller!.toggleFlash();
                                        setState(() {});
                                      },
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    IconButton(
                                      color: Colors.blue,
                                      icon: FutureBuilder(
                                        future: controller?.getCameraInfo(),
                                        builder: (context, snapshot) {
                                          return Icon(
                                            Icons.switch_camera,
                                            size: Responsive.isSmallMobile(
                                                    context)
                                                ? 25
                                                : 40,
                                          );
                                        },
                                      ),
                                      onPressed: () async {
                                        await controller!.flipCamera();
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )));
  }

  buildSuccessResult() {
    controller!.pauseCamera();
    for (int i = 0; i <= _qrList.length; i++) {
      if (barcode!.code!.contains(_qrList[i])) {
        return SizedBox(
          width: 500,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            elevation: 8,
            title: Text(
              "Verified Successfully",
              style: GoogleFonts.poppins(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: const QRCodeScanner()));
                  },
                  child: Text(
                    "Scan QR Code",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Exit",
                    style: GoogleFonts.poppins(color: Colors.red),
                  )),
            ],
          ),
        );
      } else {
        return AlertDialog(
          elevation: 8,
          title: Text(
            "Invalid QR Code",
            style: GoogleFonts.poppins(
                color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const QRCodeScanner()));
                },
                child: Text(
                  "Scan QR Code",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Exit",
                  style: GoogleFonts.poppins(color: Colors.red),
                )),
          ],
        );
      }
    }
  }

  Widget buildQrView(BuildContext context) => QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        cutOutBottomOffset: 100,
        borderColor: Colors.blue,
        borderLength: 30,
        borderWidth: 10,
        borderRadius: 20,
        overlayColor: Colors.grey.shade200,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ));
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
  }
}
