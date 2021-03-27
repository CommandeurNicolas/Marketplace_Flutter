import 'package:flutter/material.dart';
import 'package:market_place_test/product_model.dart';

import 'constants.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key, this.products}) : super(key: key);

  final List<Product> products;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _total = 0.0;
  @override
  Widget build(BuildContext context) {
    for (Product item in widget.products) {
      _total += double.parse(item.price);
      print(_total);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Image.network(p.image),

                        Container(
                          padding: EdgeInsets.only(left: 2.0, right: 16.0),
                          child: Image.asset(
                            "assets/${widget.products[index].image}",
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.products[index].name.toUpperCase(),
                              style: TextStyle(fontSize: 15.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              width: 60.0,
                              child: Divider(
                                height: 10,
                                thickness: 2.0,
                                indent: 10.0,
                                color: secondary,
                              ),
                            ),
                            Center(
                              child: Text(
                                "${widget.products[index].price} \$",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 70.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("data"),
                      Text(
                        _total.toString(),
                      ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Go to checkout"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
