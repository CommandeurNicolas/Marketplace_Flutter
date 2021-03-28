import 'package:flutter/foundation.dart';

class Product {
  final String name;
  final String price;
  final String weight;
  final String image;
  final String type;

  Product(
      {@required this.name,
      @required this.price,
      @required this.weight,
      @required this.image,
      @required this.type});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['name'] as String,
        price: json['price'] as String,
        weight: json['weight'] as String,
        image: json['image'] as String,
        type: json['type'] as String);
  }
}
