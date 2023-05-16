import 'dart:convert';

import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../main.dart';

LatLng getLatLngFromSharedPrefs() {
  return LatLng(
      sharedPreferences.getDouble('latitude')!, sharedPreferences.getDouble('longitude')!);
}

Map getDecodedResponseFromSharedPrefs(int index) {
  String key = 'restaurant--$index';
  Map response = json.decode(sharedPreferences.getString(key)!);
  return response;
}

num getDistanceFromSharedPrefs(int index) {
  num distance = getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

Map getGeometryFromSharedPrefs(int index) {
  Map geometry = getDecodedResponseFromSharedPrefs(index)['geometry'];
  return geometry;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('restaurant--$index', response);
}

LatLng getLatLngFromRestaurantData(RestaurantModel restaurant) {
  return LatLng(double.parse(restaurant.coordinates!.latitude!),
      double.parse(restaurant.coordinates!.longitude!));
}
