import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bitcoin_ticker/helper/coin_data.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bitcoin_ticker/screen/price_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:menu_button/menu_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';



class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  Map priceData = {};

  CoinData coinData = CoinData();

  List currencycodeitems = [];

  List currencylist=[];

  String fromcurrencyselectedValue ="EGP";

  TextEditingController fromController = TextEditingController();

  String toController="";

  String tocurrencyselectedValue ="EGP";


  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    for (String coin in cryptoList) {
      priceData[coin] = "?";
    }

    getcurrencylist();

  }


  getMenuButton(String value){

    return SizedBox(
      width: 83,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                value,
                style: TextStyle(color: Colors.blue),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
                width: 12,
                height: 17,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    )
                )
            ),
          ],
        ),
      ),
    );


  }



  getcurrencylist() async {


    var currency_json = await rootBundle.loadString("assets/jsonfiles/currency.json");

    currencylist=json.decode(currency_json);

    for(var currency in currencylist){

      print(currency['code']);

      currencycodeitems.add(currency['code']);
    }

    currencycodeitems.sort();
    print(currencycodeitems.length);

  }


  void getCoinsData(coin,currency,moneyAmount) async {

     setState(() {
       isLoading=true;

     });

      dynamic coinPrice = await coinData.getCoinData(coin:coin, currency: currency);

      double totalMoneyAmount;

      if (coinPrice is Error) {
          priceData[coin] = "?";
          totalMoneyAmount=0;
      } else {
        priceData[coin] = coinPrice;
        totalMoneyAmount=priceData[coin]*double.parse(moneyAmount);
      }


      setState(() {

        if(totalMoneyAmount.toInt()==0){

          toController="Sorry, something went wrong";

        }else{
        toController=totalMoneyAmount.toString();
        }

        isLoading=false;
        print(totalMoneyAmount);

      });

  }

  Widget getPriceWidgets(context) {

    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white70,
                  width: 2.0
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(0.0)  //                 <--- border radius here
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],),
            child: TextField(
              controller: fromController,
              decoration: InputDecoration(
                hintText:"Money Amount",
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black,fontSize: 30),
            ),

          ),

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                Divider(),
                ListTile(
                  leading: Container(
                      width: 50,
                      child: Text("From",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),)),
                  title: Row(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child:
                          MenuButton(
                            child: getMenuButton(fromcurrencyselectedValue),// Widget displayed as the button
                            items: currencycodeitems,// List of your items
                            topDivider: true,
                            popupHeight: 200, // This popupHeight is optional. The default height is the size of items
                            scrollPhysics: AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
                            itemBuilder: (value) => Container(
                                width: 83,
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(value,style: TextStyle(color: Colors.black),)
                            ),// Widget displayed for each item
                            toggledChild: Container(
                              color: Colors.white,
                              child: getMenuButton(fromcurrencyselectedValue),// Widget displayed as the button,
                            ),
                            divider: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            onItemSelected: (value) {


                              setState(() {

                                fromcurrencyselectedValue = value;

                                getMenuButton(value);

                              });


                              // Action when new item is selected
                            },
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]),
                                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                color: Colors.white
                            ),
                            onMenuButtonToggle: (isToggle) {
                              print(isToggle);
                            },
                          )
                      ),




                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left:150),
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Container(
                      width: 50,
                      child: Text("To",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),)),
                  title: Row(
                    children: <Widget>[

                      Container(
                          width: 100,
                          child:
                          MenuButton(
                            child: getMenuButton(tocurrencyselectedValue),// Widget displayed as the button
                            items: currencycodeitems,// List of your items
                            topDivider: true,
                            popupHeight: 200, // This popupHeight is optional. The default height is the size of items
                            scrollPhysics: AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
                            itemBuilder: (value) => Container(
                                width: 83,
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(value,style: TextStyle(color: Colors.black),)
                            ),// Widget displayed for each item
                            toggledChild: Container(
                              color: Colors.white,
                              child: getMenuButton(tocurrencyselectedValue),// Widget displayed as the button,
                            ),
                            divider: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            onItemSelected: (value) {


                              setState(() {

                                tocurrencyselectedValue = value;

                                getMenuButton(value);

                              });


                              // Action when new item is selected
                            },
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]),
                                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                color: Colors.white
                            ),
                            onMenuButtonToggle: (isToggle) {
                              print(isToggle);
                            },
                          )
                      ),




                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          getPriceWidgets(context),

          isLoading?SpinKitRotatingCircle(
            color: Colors.blue,
            size: 100.0,
          ):Text(toController,style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),

          RaisedButton(

            onPressed: (){

              if(fromController.text.toString()!=null) {
                getCoinsData(fromcurrencyselectedValue, tocurrencyselectedValue,
                    fromController.text.toString());
              }

            },

            color: Colors.blue,

            child: Container(
                height: 80,
                width: 150,
                child: Center(child: Text("Convert",
                  style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),))),



          )


        ],
      ),
    );
  }
}