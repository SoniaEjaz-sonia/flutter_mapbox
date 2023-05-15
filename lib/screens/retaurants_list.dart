import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/models/restaurant_model.dart';
import '../main.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  late Future<List<RestaurantModel>> restaurants;
  List<RestaurantModel>? restaurantsList;

  @override
  void initState() {
    restaurants = supabaseRepo.fetchAllRestaurants();

    super.initState();
  }

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
              FutureBuilder(
                  future: restaurants,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<RestaurantModel>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else if (snapshot.hasData) {
                        restaurantsList = snapshot.data!;

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: restaurantsList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    height: 175,
                                    width: 140,
                                    fit: BoxFit.cover,
                                    imageUrl: restaurantsList![index].image!,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 175,
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurantsList![index].name!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(restaurantsList![index].items!),
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
                                              const Text('2km'),
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
                        );
                      } else {
                        return const Text('Empty data');
                      }
                    } else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
