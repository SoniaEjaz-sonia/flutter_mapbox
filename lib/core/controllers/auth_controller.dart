import 'package:flutter/material.dart';
import 'package:flutter_mapbox/main.dart';
import 'package:flutter_mapbox/screens/home_screen.dart';
import 'package:flutter_mapbox/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getLoggedInUser();
    super.onInit();
  }

  Future<void> getLoggedInUser() async {
    try {
      isLoading.toggle();

      User? user = await supabaseRepo.getLoggedInUser();

      if (user != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }

      isLoading.toggle();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "WARNING!",
          message: e.toString(),
          icon: const Icon(Icons.warning, color: Colors.white),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      isLoading.toggle();
    }
  }

  Future<void> signInUserWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.toggle();

      User? user =
          await supabaseRepo.signInUserWithEmailAndPassword(email: email, password: password);

      if (user != null) {
        Get.offAll(() => const HomeScreen());
      }

      isLoading.toggle();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "WARNING!",
          message: e.toString(),
          icon: const Icon(Icons.warning, color: Colors.white),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      isLoading.toggle();
    }
  }

  Future<void> registerUserWithEmail(String email, String password) async {
    try {
      isLoading.toggle();

      User? user = await supabaseRepo.registerUserWithEmail(email: email, password: password);

      if (user != null) {
        Get.showSnackbar(
          const GetSnackBar(
            title: "WARNING!",
            message: "Please verify your email to continue",
            icon: Icon(Icons.verified, color: Colors.white),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        Get.offAll(LoginScreen());
      }

      isLoading.toggle();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "WARNING!",
          message: e.toString(),
          icon: const Icon(Icons.warning, color: Colors.white),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      isLoading.toggle();
    }
  }
}
