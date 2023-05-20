import 'package:flutter/material.dart';
import 'package:flutter_mapbox/components/carousel_card.dart';
import 'package:flutter_mapbox/core/controllers/auth_controller.dart';
import 'package:flutter_mapbox/core/controllers/splash_controller.dart';
import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapsController extends GetxController {
  static MapsController get instance => Get.find();

  SplashController splashController = Get.find<SplashController>();
  AuthController authController = Get.find<AuthController>();

  // Mapbox related
  late LatLng latLng;
  late CameraPosition initialCameraPosition;
  late MapboxMapController mapboxController;
  late List<CameraPosition> kRestaurantsList;

  // Carousel related
  int pageIndex = 0;
  List<Map> carouselData = [];
  late List<Widget> carouselItems = [];

  late List<RestaurantModel> restaurants;

  @override
  void onInit() {
    latLng = splashController.currentLatLng;

    initialCameraPosition = CameraPosition(target: latLng, zoom: 15);

    restaurants = splashController.restaurants;

    // Calculate the distance and time from data
    for (int index = 0; index < restaurants.length; index++) {
      num distance = splashController.directionsAPIResponse[index]["distance"] / 1000;
      num duration = splashController.directionsAPIResponse[index]["duration"] / 60;

      carouselData.add({
        'index': index,
        'distance': distance,
        'duration': duration,
      });
    }
    carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
      restaurants.length,
      (index) => carouselCard(
        restaurants[carouselData[index]['index']],
        carouselData[index]['distance'],
        carouselData[index]['duration'],
      ),
    );

    // initialize map symbols in the same order as carousel widgets
    kRestaurantsList = List<CameraPosition>.generate(
      restaurants.length,
      (index) => CameraPosition(
        target: getLatLngFromRestaurantData(restaurants[carouselData[index]['index']]),
        zoom: 15,
      ),
    );

    super.onInit();
  }

  addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    mapboxController.animateCamera(CameraUpdate.newCameraPosition(kRestaurantsList[index]));

    // Add a polyLine between source and destination
    Map geometry = splashController.directionsAPIResponse[carouselData[index]["index"]]["geometry"];

    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await mapboxController.removeLayer("lines");
      await mapboxController.removeSource("fills");
    }

    // Add new source and lineLayer
    await mapboxController.addSource("fills", GeojsonSourceProperties(data: fills));
    await mapboxController.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  onMapCreated(MapboxMapController controller) async {
    mapboxController = controller;
  }

  onStyleLoadedCallback() async {
    for (CameraPosition kRestaurant in kRestaurantsList) {
      await mapboxController.addSymbol(SymbolOptions(
          geometry: kRestaurant.target, iconSize: 0.2, iconImage: 'assets/icon/food.png'));
    }

    addSourceAndLineLayer(0, false);
  }

  LatLng getLatLngFromRestaurantData(RestaurantModel restaurant) {
    return LatLng(double.parse(restaurant.coordinates!.latitude!),
        double.parse(restaurant.coordinates!.longitude!));
  }
}
