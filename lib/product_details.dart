import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:market_place_test/constants.dart';
import 'package:market_place_test/custom_appbar.dart';
import 'package:market_place_test/product_model.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  const ProductDetails({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(product.name.toString()),
      //   centerTitle: true,
      //   backgroundColor: primary,
      // ),

      body: Column(
        children: [
          CustomAppbar(
            title: product.name,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      "assets/${product.image}",
                    ),
                  ),
                  // ListView.builder(
                  //   scrollDirection: Axis.horizontal,
                  //   shrinkWrap: true,
                  //   itemCount: image_list.length,
                  //   itemBuilder: (context, index) {return ElevatedButton(onPressed: () {}, child: Image.asset("assets/${image_list[index]}"))},
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
