import 'package:flutter/material.dart';
import 'package:flutter_mapbox/screens/map_screen.dart';
import 'package:flutter_mapbox/screens/retaurants_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [MapsScreen(), const RestaurantsScreen()];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (selectedIndex) {
          setState(() {
            _index = selectedIndex;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Restaurant Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Restaurants Table'),
        ],
      ),
    );
  }
}
