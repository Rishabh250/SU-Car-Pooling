import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    required this.mobile,
    required this.smallMobile,
  }) : super(key: key);

  final Widget mobile;
  final Widget smallMobile;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.height >= 800;
  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.of(context).size.height < 800;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.height >= 550) {
      return mobile;
    } else {
      return smallMobile;
    }
  }
}
