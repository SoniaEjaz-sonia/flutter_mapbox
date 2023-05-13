import 'package:flutter/material.dart';
import 'package:flutter_mapbox/screens/home_screen.dart';

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

  void initializeLocationAndSave() {
    // Ensure all permissions are collected for Locations

    // Get capture the current user location

    // Store the user location in sharedPreferences

    // Get and store the directions API response in sharedPreferences
    Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(child: Image.asset('assets/images/splash.png')),
    );
  }
}
