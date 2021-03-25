import 'package:flutter/material.dart';

import 'package:market_place_test/constants.dart';
import 'package:market_place_test/product_model.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  const ProductDetails({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name.toString()),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Title"),
                  subtitle: Text(product.name),
                ),
                ListTile(
                  title: Text("Price"),
                  subtitle: Text(product.price),
                ),
                ListTile(
                  title: Text("Weight"),
                  subtitle: Text(product.weight),
                ),
                ListTile(
                  title: Text("Image"),
                  subtitle: Text(product.image),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
