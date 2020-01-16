import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//const request = "https://api.hgbrasil.com/finance?format=json&key=f0978e41";
const request = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.amber)) //OutlineInputBorder
              ) // InputDecorationTheme
          ) // ThemeData
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

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    double real = double.parse(text);
    double retorno = real / dolar;
    dolarController.text=  retorno.toStringAsPrecision(4);
    retorno = real /euro;
    euroController.text= retorno.toStringAsPrecision(4);
  }
  void _dolarChanged(String text){
    double dolart = double.parse(text);
    double real = dolart*dolar;
    realController.text= real.toStringAsPrecision(4);
    double retorno = real /euro;
    euroController.text= retorno.toStringAsPrecision(4);

  }
  void _euroChanged(String text){
    double eurot = double.parse(text);
    double real = euro*eurot;
    realController.text= real.toStringAsPrecision(4);
    double retorno = real /dolar;
    dolarController.text= retorno.toStringAsPrecision(4);
  }

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
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'carregando dados....',
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ); // Center
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'erro:' + snapshot.error.toString(),
                    style: TextStyle(color: Colors.red, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ); // Center
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: buildTextField('Real', 'R\$', realController, _realChanged),
                      ),// Container
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: buildTextField('Dolar', 'US\$', dolarController, _dolarChanged),
                      ),// Container
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 10),
                        child: buildTextField('Euros', '€', euroController, _euroChanged),
                      ),// Container
                    ], //children: <Widget>
                  ), // Column
                ); //SingleChildScrollView
              }
          }
        }, //FutureBuilder
      ), // body
    ); //Scaffold
  }
}

Widget buildTextField(String label, String prefixo, TextEditingController c, Function f){
  return TextField(
    onChanged: f,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ), //InputDecoration
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25,
    ), //TextStyle
    controller: c,
    keyboardType: TextInputType.number,
  ); //TextField
}
