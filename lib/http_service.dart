import 'dart:convert';

import 'package:http/http.dart';
import 'package:market_place_test/product_model.dart';
import 'package:xml/xml.dart';

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

  Future<double> getShipping(int distance, int weight) async {
    String uri = "https://info802-commandeur-soap.herokuapp.com/shipping?wsdl";
    String requestBody =
        """<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ship="shipping">
            <soapenv:Header/>
            <soapenv:Body>
                <ship:shipping>
                  <!--Optional:-->
                  <ship:distance>$distance</ship:distance>
                  <!--Optional:-->
                  <ship:weight>$weight</ship:weight>
                </ship:shipping>
            </soapenv:Body>
          </soapenv:Envelope>""";
    Response response = await post(Uri.parse(uri),
            headers: {
              "SOAPAction":
                  "http://www.totvs.com/IwsConsultaSQL/RealizarConsultaSQL",
              "Content-Type": "text/xml;charset=UTF-8",
              "Authorization": "Basic bWVzdHJlOnRvdHZz",
              "cache-control": "no-cache"
            },
            body: utf8.encode(requestBody),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    return _parseXml(response.body);
  }

  double _parseXml(String body) {
    final document = XmlDocument.parse(body).toString();
    String patternStart = '<tns:string>';
    String patternEnd = '</tns:string>';
    double shippingPrice = double.parse(document.substring(
        document.indexOf(patternStart) + patternStart.length,
        document.indexOf(patternEnd)));

    return shippingPrice;
  }
}
