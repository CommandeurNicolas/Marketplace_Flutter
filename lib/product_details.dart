import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:market_place_test/constants.dart';
import 'package:market_place_test/custom_appbar.dart';
import 'package:market_place_test/product_model.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _nb = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: widget.product.name,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/${widget.product.image}",
              ),
            ),
            // ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   shrinkWrap: true,
            //   itemCount: image_list.length,
            //   itemBuilder: (context, index) {return ElevatedButton(onPressed: () {}, child: Image.asset("assets/${image_list[index]}"))},
            // )
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _productCharacteristics(
                        "Weight", "weight.png", widget.product.weight, primary),
                    _productCharacteristics("Type", "rollerblade.png",
                        widget.product.type, primary),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 150),
                    decoration: BoxDecoration(
                      // color: primary,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIncrementDecrementButton(Color(0xffCCCCCC),
                            Icons.remove, () => _decrement()),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _nb.toString(),
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                        ),
                        _buildIncrementDecrementButton(
                            primary, Icons.add, () => _increment()),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        [for (var i = 0; i < _nb; i += 1) widget.product],
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0.0),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff416be1),
                            Color(0xff95adee),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: 80.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              (double.parse(widget.product.price) * _nb)
                                  .toString(),
                              // "${widget.product.price} \$",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: Color(0xffCCCCCC),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 24,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCharacteristics(
      String title, String img, String desc, Color iconColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/$img",
                scale: 5,
                color: iconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                desc[0].toUpperCase() + desc.substring(1),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      _nb++;
    });
  }

  void _decrement() {
    setState(() {
      if (_nb > 1) {
        _nb--;
      }
    });
  }

  Widget _buildIncrementDecrementButton(
      Color c, IconData i, Function onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: IconButton(
        icon: Icon(i),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
