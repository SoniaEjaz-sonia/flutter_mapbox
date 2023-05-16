// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_mapbox/core/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(child: Image.asset('assets/images/splash.png')),
    );
  }
}
