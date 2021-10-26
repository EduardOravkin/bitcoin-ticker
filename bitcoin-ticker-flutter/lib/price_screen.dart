import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'networking.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'EUR';
  Map<String, String> exchangeRates = {
    'BTC': '0.00',
    'ETH': '0.00',
    'LTC': '0.00'
  };
  String exchangeRate = '0.0';
  FixedExtentScrollController scrollController;
  CryptoPriceGetter rate_getter = CryptoPriceGetter();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: 4);
    getExchangeRates(selectedCurrency);
  }

  void getExchangeRates(realCurrency) async {
    for (int i = 0; i < cryptoList.length; i++) {
      exchangeRates[cryptoList[i]] =
          await rate_getter.get_exchange_rate(cryptoList[i], realCurrency);
    }
    ;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getChildren(),
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> l = [];

    List<Widget> l1 = cryptoList.map<Widget>((String crypto) {
      return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = ${exchangeRates[crypto]} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }).toList();

    l.add(Column(
      children: l1,
      mainAxisAlignment: MainAxisAlignment.start,
    ));
    l.add(Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? getiOSPicker() : getAndroidDropdown(),
    ));

    return l;
  }

  NotificationListener getiOSPicker() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          print(selectedCurrency);
          getExchangeRates(
              selectedCurrency); //this is here because of async / await
          return true;
        } else {
          return false;
        }
      },
      child: CupertinoPicker(
        scrollController: scrollController,
        itemExtent: 32.0,
        backgroundColor: Colors.lightBlue,
        children: currenciesList.map((String e) => Text(e)).toList(),
        onSelectedItemChanged: (int value) {
          selectedCurrency = currenciesList[value];
        },
      ),
    );
  }

  NotificationListener getAndroidDropdown() {
    return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            print(selectedCurrency);
            getExchangeRates(
                selectedCurrency); //this is here because of async / await
            return true;
          } else {
            return false;
          }
        },
        child: DropdownButton(
          value: selectedCurrency,
          onChanged: (value) async {
            selectedCurrency = currenciesList[value];
          },
          items: currenciesList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }

  DropdownButton getAndroidDropdown2() {
    return DropdownButton(
      value: selectedCurrency,
      onChanged: (value) async {
        selectedCurrency = currenciesList[value];
        getExchangeRates(selectedCurrency);
      },
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  CupertinoPicker getiOSPicker2() {
    return CupertinoPicker(
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      children: currenciesList.map((String e) => Text(e)).toList(),
      onSelectedItemChanged: (value) async {
        selectedCurrency = currenciesList[value];
        getExchangeRates(selectedCurrency);
      },
    );
  }
}
