import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:market_place_test/cart.dart';
import 'package:market_place_test/constants.dart';
import 'package:market_place_test/custom_appbar.dart';
import 'package:market_place_test/http_service.dart';
import 'package:market_place_test/product_details.dart';
import 'package:market_place_test/product_model.dart';
import 'package:market_place_test/ticket.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductsPage> {
  final HttpService httpService = new HttpService();

  List<Product> _cart = [];
  HashMap<Product, bool> _isInCart = new HashMap<Product, bool>();
  Future<List<Product>> _productList;

  @override
  void initState() {
    _productList = httpService.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: "powerslide",
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Badge(
              position: BadgePosition(top: 0.0, end: 0.0),
              badgeColor: secondary,
              badgeContent: Text(
                _cart.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(products: _cart),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // appBar: AppBar(
      //   title: Text("PowerSlide"),
      //   centerTitle: true,
      //   actions: [

      //   ],
      // ),
      body: FutureBuilder(
        future: _productList,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data;

            return ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              children: products
                  .map((Product p) => _buildProductTile(context, p))
                  .toList(),
              // children: products
              //     .map((Product p) => ListTile(
              //           title: Text(p.name),
              //           onTap: () => Navigator.of(context).push(
              //               MaterialPageRoute(
              //                   builder: (context) =>
              //                       ProductDetails(product: p))),
              //         ))
              //     .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, Product p) {
    return Ticket(
      width: 350,
      top: _buildTopTicket(p),
      bottom: _buildBottomTicket(context, p),
      borderRadius: 10.0,
      punchRadius: 10.0,
    );
  }

  Container _buildTopTicket(Product p) {
    return Container(
      height: 100,
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
                "assets/${p.image}",
                height: 100,
                width: 100,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name.toUpperCase(),
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
                    "${p.price} \$",
                    style: TextStyle(fontSize: 16.0),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildBottomTicket(BuildContext context, Product p) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isInCart.containsKey(p) && _isInCart[p]
              ? Container(
                  // onPressed: () {
                  //   setState(() {
                  //     _cart_product.add(p);
                  //   });
                  // },
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(product: p),
                ),
              );
              setState(() {
                _cart.addAll(result);
                _isInCart[p] = true;
              });
              print(_cart.contains(p));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              side: MaterialStateProperty.all(
                BorderSide(style: BorderStyle.solid, color: secondary),
              ),
            ),
            child: Text(
              "See details",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
