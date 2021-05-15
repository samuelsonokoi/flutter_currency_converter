import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String apiKey = '15aef91e-6ac4-4f7f-9afc-06cc32337eed';
  final Uri currencyURL = Uri.https('v2.api.forex', '/rates/latest.json',
      {'key': '15aef91e-6ac4-4f7f-9afc-06cc32337eed'});

  Future<List<String>> getCurrencies() async {
    http.Response res = await http.get(currencyURL);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var list = body["rates"];
      List<String> currencies = (list.keys).toList();
      print(currencies);
      return currencies;
    } else {
      print('Failed to connect to API');
      throw Exception('Failed to connect to API');
    }
  }

  Future<double> getRate(String from, String to, double amount) async {
    final Uri rateUrl = Uri.https('v2.api.forex', '/convert', {
      'key': '15aef91e-6ac4-4f7f-9afc-06cc32337eed',
      'from': from,
      'to': to,
      'amount': amount
    });

    http.Response res = await http.get(rateUrl);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      print(body);
      return body['result'];
    } else {
      throw Exception('Failed to convert value');
    }
  }
}
