// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:flutter_mapbox/core/repository/mapbox_repo.dart';
import 'package:flutter_mapbox/main.dart';
import 'package:flutter_mapbox/screens/home_screen.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  Future<void> initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location
    LocationData locationData = await location.getLocation();
    LatLng currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

    currentLatLng = const LatLng(37.33248492696747, -122.03122933325918);

    // Store the user location in sharedPreferences

    sharedPreferences.setDouble('latitude', currentLatLng.latitude);
    sharedPreferences.setDouble('longitude', currentLatLng.longitude);

    // Get and store the directions API response in sharedPreferences

    List<RestaurantModel> restaurants = await supabaseRepo.fetchAllRestaurants();

    for (var i = 0; i < restaurants.length; i++) {
      Map modifiedResponse = await MapBoxRepo().getDirectionsAPIResponse(currentLatLng, i);

      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(child: Image.asset('assets/images/splash.png')),
    );
  }
}
