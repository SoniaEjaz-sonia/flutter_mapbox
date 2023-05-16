import 'package:flutter_mapbox/core/controllers/splash_controller.dart';
import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:get/get.dart';

class RestaurantsController extends GetxController {
  static RestaurantsController get instance => Get.find();

  SplashController splashController = Get.find<SplashController>();

  List<RestaurantModel>? restaurantsList;

  @override
  void onInit() {
    restaurantsList = splashController.restaurants;

    super.onInit();
  }
}
