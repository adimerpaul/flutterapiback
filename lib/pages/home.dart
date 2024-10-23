import 'package:apiback/pages/formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    var url = Uri.parse(dotenv.env['API_BACK']!+'/products');
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
        title: const Text('Productos'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Text('Contador: $contador'),
          // ElevatedButton(
          //   onPressed: productGet,
          //   child: const Text('Actulizar'),
          // ),
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Formulario()),
          );
          productGet();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
