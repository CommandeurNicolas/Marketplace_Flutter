import 'dart:convert';

import 'package:http/http.dart';
import 'package:market_place_test/product_model.dart';

class HttpService {
  final String getUrl =
      "https://info802-commandeur-graphql.herokuapp.com/graphql?query={products%20{name%20price%20weight%20image%20type}}";

  Future<List<Product>> getProducts() async {
    Response res = await get(Uri.parse(getUrl));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['data']['products'];

      List<Product> products = body
          .map(
            (dynamic item) => Product.fromJson(item),
          )
          .toList();

      return products;
    } else {
      throw "Can't get products";
    }
  }
}
