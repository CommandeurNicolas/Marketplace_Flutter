import 'package:flutter/material.dart';
import 'package:market_place_test/constants.dart';
import 'package:market_place_test/http_service.dart';
import 'package:market_place_test/product_model.dart';
import 'package:market_place_test/ticket.dart';

class ProductsPage extends StatelessWidget {
  final HttpService httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PowerSlide"),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: FutureBuilder(
        future: httpService.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data;

            return ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              children:
                  products.map((Product p) => _buildProductTile(p)).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProductTile(Product p) {
    return Ticket(
      width: 350,
      top: _buildTopTicket(p),
      bottom: _buildBottomTicket(),
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

  Container _buildBottomTicket() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              side: MaterialStateProperty.all(
                BorderSide.lerp(
                    BorderSide(
                      style: BorderStyle.solid,
                      color: secondary,
                    ),
                    BorderSide(
                      style: BorderStyle.solid,
                      color: secondary,
                    ),
                    10.0),
              ),
            ),
            child: Text(
              "See details",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              side: MaterialStateProperty.all(
                BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.green,
                ),
              ),
            ),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
    );
  }
}
