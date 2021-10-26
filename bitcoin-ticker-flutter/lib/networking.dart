import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'api_key.dart';

const String url = 'https://rest.coinapi.io/v1/exchangerate';

class CryptoPriceGetter {
  Future<String> get_exchange_rate(String crypto, String realCurrency) async {
    http.Response response = await http.get(
        Uri.parse(
          '$url/$crypto/$realCurrency',
        ),
        headers: {'X-CoinAPI-Key': api_key});

    if (response.statusCode == 200) {
      Map map = JsonDecoder().convert(response.body);
      print(map['rate']);
      return roundOffToXDecimal(map['rate']).toString();
    } else {
      print('status code : ${response.statusCode}');
      return '0.00';
    }
  }
}

double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
  // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
  String numbersAfterDecimal = number.toString().split('.')[1];
  if (numbersAfterDecimal != '0') {
    int existingNumberOfDecimal = numbersAfterDecimal.length;
    number += 1 / (10 * pow(10, existingNumberOfDecimal));
  }

  return double.parse(number.toStringAsFixed(numberOfDecimal));
}
