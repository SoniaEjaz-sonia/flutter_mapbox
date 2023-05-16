import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:flutter_mapbox/core/repository/mapbox_repo.dart';
import 'package:flutter_mapbox/main.dart';
import 'package:flutter_mapbox/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class SplashController extends GetxController {
  static SplashController get instance => Get.find();

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxList<Map> directionsAPIResponse = <Map>[].obs;
  late LatLng currentLatLng;
  late List<RestaurantModel> restaurants;

  @override
  void onInit() {
    initializeLocationAndSave();

    super.onInit();
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
    currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

    // setting location to hardcoded for better user experience
    currentLatLng = const LatLng(37.33248492696747, -122.03122933325918);

    // Store the user location
    latitude.value = currentLatLng.latitude;
    longitude.value = currentLatLng.longitude;

    // Get and store the directions API response
    restaurants = await supabaseRepo.fetchAllRestaurants();

    for (var i = 0; i < restaurants.length; i++) {
      Map modifiedResponse = await MapBoxRepo().getDirectionsAPIResponse(currentLatLng, i);

      directionsAPIResponse.add(modifiedResponse);
    }

    Get.offAll(const HomeScreen());
  }
}
