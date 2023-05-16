// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox/core/controllers/restaurants_controller.dart';
import 'package:flutter_mapbox/helpers/shared_prefs.dart';
import 'package:get/get.dart';

class RestaurantsScreen extends StatelessWidget {
  RestaurantsScreen({Key? key}) : super(key: key);

  RestaurantsController controller = Get.put(RestaurantsController());

  Widget cardButtons(IconData iconData, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          minimumSize: Size.zero,
        ),
        child: Row(
          children: [Icon(iconData, size: 16), const SizedBox(width: 2), Text(label)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants Table'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoTextField(
                prefix: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(Icons.search),
                ),
                padding: EdgeInsets.all(15),
                placeholder: 'Search dish or restaurant name',
                style: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              const SizedBox(height: 5),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: controller.restaurantsList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          height: 175,
                          width: 140,
                          fit: BoxFit.cover,
                          imageUrl: controller.restaurantsList![index].image!,
                        ),
                        Expanded(
                          child: Container(
                            height: 175,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.restaurantsList![index].name!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(controller.restaurantsList![index].items!),
                                const Spacer(),
                                const Text('Waiting time: 2hrs'),
                                Text(
                                  'Closes at 10PM',
                                  style: TextStyle(color: Colors.redAccent[100]),
                                ),
                                Row(
                                  children: [
                                    cardButtons(Icons.call, 'Call'),
                                    cardButtons(Icons.location_on, 'Map'),
                                    const Spacer(),
                                    Text(
                                      '${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)}km',
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
