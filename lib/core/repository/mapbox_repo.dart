import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:flutter_mapbox/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/constants.dart';
import '../exceptions/dio_exceptions.dart';

class MapBoxRepo {
  final Dio _dio = Dio();

  Future getNavRouteUsingMapbox(LatLng source, LatLng destination) async {
    String url =
        '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
    try {
      _dio.options.contentType = Headers.jsonContentType;
      final responseData = await _dio.get(url);
      return responseData.data;
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
      debugPrint(errorMessage);
    }
  }

  Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
    List<RestaurantModel> restaurants = await supabaseRepo.fetchAllRestaurants();

    final response = await getNavRouteUsingMapbox(
        currentLatLng,
        LatLng(double.parse(restaurants[index].coordinates!.latitude!),
            double.parse(restaurants[index].coordinates!.longitude!)));

    Map geometry = response['routes'][0]['geometry'];
    num duration = response['routes'][0]['duration'];
    num distance = response['routes'][0]['distance'];

    Map modifiedResponse = {
      "geometry": geometry,
      "duration": duration,
      "distance": distance,
    };
    return modifiedResponse;
  }
}
