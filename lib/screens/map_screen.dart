import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mapbox/helpers/shared_prefs.dart';
import 'package:flutter_mapbox/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../components/carousel_card.dart';
import '../core/models/restaurant_model.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  // Mapbox related
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> kRestaurantsList;

  // Carousel related
  int pageIndex = 0;
  List<Map> carouselData = [];
  late List<Widget> carouselItems = [];

  late Future<List<RestaurantModel>> restaurantModel;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = CameraPosition(target: latLng, zoom: 15);

    restaurantModel = supabaseRepo.fetchAllRestaurants();

    restaurantModel.then((restaurants) {
      // Calculate the distance and time from data in SharedPreferences
      for (int index = 0; index < restaurants.length; index++) {
        num distance = getDistanceFromSharedPrefs(index) / 1000;
        num duration = getDurationFromSharedPrefs(index) / 60;

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
    });
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(CameraUpdate.newCameraPosition(kRestaurantsList[index]));

    // Add a polyLine between source and destination
    Map geometry = getGeometryFromSharedPrefs(carouselData[index]["index"]);

    final _fills = {
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
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
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

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    for (CameraPosition kRestaurant in kRestaurantsList) {
      await controller.addSymbol(SymbolOptions(
          geometry: kRestaurant.target, iconSize: 0.2, iconImage: 'assets/icon/food.png'));
    }

    _addSourceAndLineLayer(0, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants Map'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: MapboxMap(
                accessToken: dotenv.env["MAPBOX_ACCESS_TOKEN"],
                initialCameraPosition: initialCameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(2, 17),
              ),
            ),
            CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
                height: 100,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    pageIndex = index;
                  });

                  _addSourceAndLineLayer(index, true);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(initialCameraPosition),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
