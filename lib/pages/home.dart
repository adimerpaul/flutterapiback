import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var contador = 0;
  List products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productGet();
  }
  productGet() async {
    var url = Uri.parse('https://4d1f-2800-cd0-afd1-6b00-f1-4439-1487-f3b1.ngrok-free.app/api/products');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // print(jsonResponse);
      setState(() {
        products = jsonResponse;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  aumentar() {
    contador++;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Text('Contador: $contador'),
          ElevatedButton(
            onPressed: aumentar,
            child: const Text('Aumentar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index]['name'].toString()),
                  subtitle: Text(products[index]['price'].toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
