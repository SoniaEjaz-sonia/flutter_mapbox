import 'coordinates.dart';

class RestaurantModel {
  int? id;
  String? createdAt;
  String? name;
  String? items;
  String? image;
  Coordinates? coordinates;

  RestaurantModel({
    this.id,
    this.createdAt,
    this.name,
    this.items,
    this.image,
    this.coordinates,
  });

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    items = json['items'];
    image = json['image'];
    coordinates = json['coordinates'] != null ? Coordinates.fromJson(json['coordinates']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['items'] = items;
    data['image'] = image;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    return data;
  }
}
