import 'package:flutter_mapbox/core/models/restaurant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepo {
  final SupabaseClient client = Supabase.instance.client;

  Future<User?> getLoggedInUser() async {
    final User? user = client.auth.currentUser;

    return user;
  }

  Future<User?> signInUserWithEmailAndPassword(
      {required String email, required String password}) async {
    AuthResponse authResponse = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final User? user = authResponse.user;

    return user;
  }

  Future<User?> registerUserWithEmail({required String email, required String password}) async {
    AuthResponse authResponse = await client.auth.signUp(
      email: email,
      password: password,
    );

    final User? user = authResponse.user;

    return user;
  }

  Future<List<RestaurantModel>> fetchAllRestaurants() async {
    final List data = await client.from('restaurants').select();

    List<RestaurantModel> restaurantList = data.map((e) => RestaurantModel.fromJson(e)).toList();

    return restaurantList;
  }
}
