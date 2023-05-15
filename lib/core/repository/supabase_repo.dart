import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepo {
  final supabase = Supabase.instance.client;

  Future<List<RestaurantModel>> fetchAllRestaurants() async {
    final List data = await supabase.from('restaurants').select();

    List<RestaurantModel> restaurantList = data.map((e) => RestaurantModel.fromJson(e)).toList();

    return restaurantList;
  }
}
