import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:market_place_test/product_model.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import 'constants.dart';
import 'custom_appbar.dart';
import 'http_service.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key, this.products}) : super(key: key);

  final List<Product> products;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final HttpService httpService = new HttpService();

  double _total = 0.0;
  HashMap<Product, int> _productNumber = new HashMap<Product, int>();

  @override
  void initState() {
    for (Product item in widget.products) {
      _total += double.parse(item.price);
      _productNumber.containsKey(item)
          ? _productNumber[item]++
          : _productNumber[item] = 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: "Your Cart",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _productNumber.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffcacaca),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                                "assets/${_productNumber.keys.elementAt(index).image}"),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    _productNumber.keys
                                            .elementAt(index)
                                            .name[0]
                                            .toUpperCase() +
                                        _productNumber.keys
                                            .elementAt(index)
                                            .name
                                            .substring(1),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    (double.parse(_productNumber.keys
                                                .elementAt(index)
                                                .price))
                                            // * _productNumber.values
                                            //   .elementAt(index))
                                            .toString() +
                                        " \$",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                // width: 40.0,
                                child: ElevatedButton(
                                  onPressed: () => _showDialog(
                                    _productNumber.keys.elementAt(index),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(0.0),
                                    primary: Colors.red,
                                  ),
                                  child: Icon(Icons.delete_outline),
                                ),
                              ),
                              Container(
                                // width: 40.0,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(0.0),
                                    primary: primary.withOpacity(0.6),
                                  ),
                                  child: Text(
                                    _productNumber.values
                                        .elementAt(index)
                                        .toString(),
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
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Total :",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _total.toString() + " \$",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("+ shipping fee"),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                _buildCheckoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog(Product p) {
    return Dialogs.materialDialog(
      msg: 'Are you sure ? you can\'t undo this',
      title: "Delete",
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          textStyle: TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () {
            setState(() {
              _total -= _productNumber[p] * double.parse(p.price);
              _productNumber.remove(p);
            });
            Navigator.pop(context);
          },
          text: "Delete",
          iconData: Icons.delete,
          color: Colors.red,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: () async {
        double shippingPrice = await httpService.getShipping(100, 10);
        print(shippingPrice);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(0.0),
        ),
      ),
      child: Container(
        height: 50,
        width: 250,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 0.0),
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
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 24,
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Text(
                  "Checkout",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
