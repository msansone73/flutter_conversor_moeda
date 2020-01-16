import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=f0978e41";

void main() async {

  runApp(MaterialApp(
    home: Home(),
  )); //MaterialApp
}


Future<Map> getData() async {
  http.Response response = await http.get(request);
  //print(json.decode(response.body)['results']['currencies']['USD']);
  return json.decode(response.body);

}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$Conversor\$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('carregando dados....',
                  style: TextStyle( color: Colors.amber, fontSize: 25 ),
                textAlign: TextAlign.center,),
              ); // Center
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text('erro:' + snapshot.error.toString(),
                    style: TextStyle( color: Colors.red, fontSize: 25 ),
                    textAlign: TextAlign.center,),
                ); // Center
              } else {

                dolar= snapshot.data['results']['currencies']['USD']['buy'];
                euro= snapshot.data['results']['currencies']['EUR']['buy'];

                return Center(
                  child: Text('Sem erro : '+ dolar.toStringAsPrecision(4)+euro.toStringAsPrecision(4),
                    style: TextStyle( color: Colors.green, fontSize: 25 ),
                    textAlign: TextAlign.center,),
                ); // Center
              }
          }
        },//FutureBuilder
      ), // body
    ); //Scaffold
  }
}


