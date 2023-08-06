import 'dart:convert';
import 'package:http/http.dart' as http;

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

const apiKey = 'F72207DF-2239-4E19-9570-BF1611E842FF';
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const bitcoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';
class CoinData {

  Future getCoinData(String selectedCurrency) async {
    //Create Map of the results instead of using a single value
    Map<String, String> cryptoPrices ={};
    //Use a loop in order to request info about every Crypto in a loop
    for(String crypto in cryptoList){
      String url = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        String data= response.body;
        var decodedData = jsonDecode(data);
        double lastPrice = decodedData['rate'];
        //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
        cryptoPrices[crypto]= lastPrice.toStringAsFixed(0);
      }else{
        print(response.body);
        throw 'An Error occurred with the request';
      }
    }
    return cryptoPrices;
  }
}
