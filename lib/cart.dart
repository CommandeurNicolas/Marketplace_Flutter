import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_place_test/custom_dialog.dart';
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
  final TextEditingController distanceController = TextEditingController();

  bool _cartBought;

  double _total = 0.0;
  double _totalWeight = 0.0;
  double _distance = 0.0;
  double _shippingPrice = 0.0;
  HashMap<Product, int> _productNumber = new HashMap<Product, int>();

  @override
  void initState() {
    _cartBought = false;
    for (Product item in widget.products) {
      _total += double.parse(item.price);
      _totalWeight += double.parse(item.weight);
      _productNumber.containsKey(item)
          ? _productNumber[item]++
          : _productNumber[item] = 1;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: "Your Cart",
        popReturn: widget.products,
      ),
      body: Column(
        children: [
          _cartBought
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/love.json", repeat: false),
                        Text(
                          "Thank you very much for your purchase !",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 32),
                        )
                      ],
                    ),
                  ),
                )
              : (_productNumber.isNotEmpty
                  ? Expanded(
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
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          // width: 40.0,
                                          child: ElevatedButton(
                                            onPressed: () => _showDeleteDialog(
                                              _productNumber.keys
                                                  .elementAt(index),
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
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/empty_cart.json"),
                            Text(
                              "Your cart is empty !",
                              style: TextStyle(fontSize: 32),
                            )
                          ],
                        ),
                      ),
                    )),
          _productNumber.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildTotalText("+ shipping fee"),
                      Container(
                        height: 20,
                      ),
                      _buildCheckoutButton()
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTotalText(String shipping_text) {
    return Column(children: [
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
            child: Text(shipping_text),
          ),
        ],
      ),
    ]);
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: () async {
        _showCheckoutDialog();
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

  Future<void> _showDeleteDialog(Product p) {
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
              widget.products.removeWhere((element) => element == p);
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

  Future<void> _showCheckoutDialog() {
    Widget component = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Before going to checkout we must know where your are from us.",
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: distanceController,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Color(0xffcacaca)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Color(0xffcacaca)),
              ),
              hintText: 'in km',
              labelText: 'Distance',
            ),
          ),
        ),
      ],
    );
    Function f = () async {
      double distance = double.parse(distanceController.text);
      double shippingPrice =
          await httpService.getShipping(_distance.ceil(), _totalWeight.ceil());
      setState(() {
        _distance = distance;
        _shippingPrice = shippingPrice;
      });
      Navigator.pop(context);
      _showPaymentDialog();
    };

    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Checkout",
        component: component,
        functionOk: f,
        buttonOkTitle: 'Continue',
      ),
    );
  }

  Future<void> _showPaymentDialog() {
    Widget component = _buildTotalAndShippingText();
    Function f = () {
      Navigator.pop(context);
      _showCongratulationDialog();
    };

    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Payment",
        component: component,
        functionOk: f,
        buttonOkColor: primary,
        buttonOkIcon: Icons.payment_rounded,
        buttonOkTitle: "Proceed",
      ),
    );
  }

  Future<void> _showCongratulationDialog() {
    return Dialogs.materialDialog(
      color: Colors.white,
      // msg: 'Payment succeed !',
      // title: 'Thank you',
      animation: 'assets/payment_animation.json',
      animationRepeat: false,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            setState(() {
              _cartBought = true;
              _total -= 0.0;
              _productNumber.clear();
              widget.products.clear();
            });
            Navigator.pop(context);
          },
          text: 'Exit',
          iconData: Icons.done,
          color: primary,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildTotalAndShippingText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Align(
                alignment: Alignment.centerRight,
                child: Text("  ${_total.toString()}"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Align(
                alignment: Alignment.centerRight,
                child: Text("+ ${_shippingPrice.toString()}"),
              ),
            ],
          ),
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
                (_total + _shippingPrice).toString() + " \$",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
