import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //Default value of selectedCurrency ise set to 'AUD' as it is the first element in the list
  String selectedCurrency = 'AUD';

  CoinData coinData = CoinData();

  DropdownButton<String> androidDropdownButton(){

    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currenciesList){
      var newItem=DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
    value: selectedCurrency,// This is the default value of the button or it can be said that whenever the app starts this value will be visible
    items: dropdownItems,
    dropdownColor: Color(0xffc1c0ef),
    onChanged: (value){
      setState(() {
        //This will store the 'value' in selectedCurrency and that selectedCurrency is used in getData() method which is further called to print the price
        selectedCurrency= value!;
        //Call getData() when the picker/dropdown changes
        getData();
    });
    },);
  }

  CupertinoPicker iosPicker(){
    List<Text> pickerItems = [];
    for(String currency in currenciesList){
      Text(currency);
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Color(0xffc1c0ef),
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
        //The index of the item int the currenciesList will be store int the selected currency variable which will be used in the getData() method called afterwards
        selectedCurrency = currenciesList[selectedIndex];
        //After calling getData() the value in selectedCurrency will be passed to the getCoinData method inside getData() method to fetch the details
        getData();
      },
      children: pickerItems,
    );
  }
  Map<String, String> coinValues = {};
  bool isWaiting=false;

  void getData() async{
    //we put this variable to true because the app is fetching the data from the api
    isWaiting=true;
    try{
      var data = await coinData.getCoinData(selectedCurrency);
      //As soon as the above line completes and the code gets the data from the api we put the isWaiting variable to false
      isWaiting=false;
      setState(() {
        //this will set the state whenever the app restarts or the value in the dropdown menu or cupertino picker changes
        coinValues = data;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //If we want something to happen, the moment that our stateful widget is created and added to the tree, then we are going to put our code in the init state
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Coinio',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26.0,
          color: Color(0xffafb0d4)
        ),),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                crypto: 'BTC',
                value: isWaiting ? '?' : coinValues['BTC']!,
                selectedCurrency: selectedCurrency
              ),
              CryptoCard(
                  crypto: 'ETH',
                  value: isWaiting ? '?' : coinValues['ETH']!,
                  selectedCurrency: selectedCurrency
              ),
              CryptoCard(
                  crypto: 'LTC',
                  value: isWaiting ? '?' : coinValues['LTC']!,
                  selectedCurrency: selectedCurrency
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Color(0xffc1c0ef),
            //Ternary operator which will find check the Platform on which the app is running
            child: Platform.isIOS ? iosPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {


  const CryptoCard({required this.value, required this.crypto, required this.selectedCurrency});

  final String value;
  final String selectedCurrency;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color(0xffc1c0ef),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xff456fb2),
            ),
          ),
        ),
      ),
    );
  }
}

