import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final String user_id;
  const MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  bool _visible = false;
  bool _visible01 = true;

  Icon _iconState = const Icon(Icons.keyboard_arrow_up);
  late BitmapDescriptor customIcon, customIcon2;

  Set<Marker> _markers = {};
  double _width = 50;
  double _height = 50;
  double _width01 = 50;

  final double _height01 = 50;
  Color _color = Colors.blue;
  bool buttonState = true;
  double lati = 28.4709;
  double longi = 77.4769;
  double _sizedBoxwidth01 = 20;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(2, 2)), "images/person.png");

    customIcon2 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(2, 2)), "images/destination.png");
  }

  void _start() {
    _visible01 = false;
    _sizedBoxwidth01 = 0;
    if (_height == 50) {
      setState(() {
        _iconState = const Icon(Icons.keyboard_arrow_down);
        _height = 180;
        _width = 350;
        _color = Colors.transparent;
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            if (_height == 180) {
              _visible = true;
            } else {
              _visible = false;
            }
          });
        });
      });
    } else if (_height == 180) {
      setState(() {
        _iconState = const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.white,
        );
        _height = 50;
        _width = 50;
        _color = Colors.blue;
        _visible = false;
        Future.delayed(const Duration(microseconds: 8000), () {
          _sizedBoxwidth01 = 20;
          _visible01 = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Live Tracking"),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (_added) {
                mymap(snapshot);
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Positioned.fill(
                child: GoogleMap(
                  mapType: MapType.normal,
                  buildingsEnabled: true,
                  trafficEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  initialCameraPosition: CameraPosition(
                      tilt: 88,
                      bearing: 30,
                      target: LatLng(
                        snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.user_id)['latitude'],
                        snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.user_id)['longitude'],
                      ),
                      zoom: 14.47),
                  onMapCreated: (GoogleMapController controller) async {
                    setState(() {
                      _controller = controller;
                      _added = true;

                      _markers.add(
                        Marker(
                          position: LatLng(
                            snapshot.data!.docs.singleWhere((element) =>
                                element.id == widget.user_id)['latitude'],
                            snapshot.data!.docs.singleWhere((element) =>
                                element.id == widget.user_id)['longitude'],
                          ),
                          markerId: const MarkerId("id-1"),
                          infoWindow: const InfoWindow(title: "Rishabh Bansal"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueAzure),
                        ),
                      );
                    });
                  },
                  markers: {
                    Marker(
                      position: LatLng(
                        snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.user_id)['latitude'],
                        snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.user_id)['longitude'],
                      ),
                      markerId: const MarkerId("id-1"),
                      infoWindow: const InfoWindow(title: "Rishabh Bansal"),
                      icon: customIcon,
                    ),
                    Marker(
                      position: const LatLng(28.4709, 77.4769),
                      markerId: const MarkerId("id+1"),
                      infoWindow: const InfoWindow(title: "Sharda University"),
                      icon: customIcon2,
                    ),
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: _visible01,
                          child: AnimatedContainer(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  shape: BoxShape.rectangle,
                                  color: _color,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              width: _width01,
                              height: _height01,
                              duration: const Duration(milliseconds: 1500))),
                      SizedBox(
                        width: _sizedBoxwidth01,
                      ),
                      Visibility(
                        child: AnimatedContainer(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 1500),
                          width: _width,
                          height: _height,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              shape: BoxShape.rectangle,
                              color: _color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          onEnd: () {
                            setState(() {
                              _height = _height;
                            });
                          },
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: _start,
                                icon: _iconState,
                              ),
                              Visibility(
                                  visible: _visible,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _currentLocation,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: const Offset(0,
                                                          0), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40.0,
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    right: 40),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "images/person.png",
                                                      width: 40,
                                                      height: 30,
                                                    ),
                                                    const Text(
                                                      "Current Location",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.lightBlue),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _destination,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset:
                                                          const Offset(0, 0),
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40.0,
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    right: 40),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "images/destination.png",
                                                      width: 40,
                                                      height: 30,
                                                    ),
                                                    const Text(
                                                      "Sharda University",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _sizedBoxwidth01,
                      ),
                      Visibility(
                          visible: _visible01,
                          child: AnimatedContainer(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  shape: BoxShape.rectangle,
                                  color: _color,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              width: _width01,
                              height: _height01,
                              duration: const Duration(milliseconds: 1500))),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  double _zoom = 10;
  bool cl = true;

  _destination() {
    print("Destination");
    setState(() {
      cl = false;
      _zoom = 15;
    });
  }

  _currentLocation() {
    print("Current Location");
    setState(() {
      cl = true;
      _zoom = 15;
    });
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (cl == true) {
      print("tttt");
      await _controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['longitude'],
              ),
              zoom: 14)));
    } else {
      await _controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                lati,
                longi,
              ),
              zoom: _zoom)));
    }
  }
}
