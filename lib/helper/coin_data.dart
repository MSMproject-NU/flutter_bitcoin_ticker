import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'FDA691F2-0475-4EB1-82FC-79315E7652E2';



class CoinData {
  dynamic getCoinData({coin, currency}) async {
    try {
      http.Response response = await http
          .get("${coinAPIURL}/${coin}/${currency}?apikey=$apiKey")
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        return data["rate"];
      }
      throw "";
    } catch (err) {
      return Error();
    }
  }
}