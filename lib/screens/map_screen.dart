// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mapbox/core/controllers/maps_controller.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapsScreen extends StatelessWidget {
  MapsScreen({Key? key}) : super(key: key);

  MapsController controller = Get.put(MapsController());

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
                initialCameraPosition: controller.initialCameraPosition,
                onMapCreated: controller.onMapCreated,
                onStyleLoadedCallback: controller.onStyleLoadedCallback,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(2, 17),
              ),
            ),
            CarouselSlider(
              items: controller.carouselItems,
              options: CarouselOptions(
                height: 100,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  controller.pageIndex = index;

                  controller.addSourceAndLineLayer(index, true);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.mapboxController.animateCamera(
            CameraUpdate.newCameraPosition(controller.initialCameraPosition),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
