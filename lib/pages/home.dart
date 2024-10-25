import 'package:apiback/pages/formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

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
    var token = localStorage.getItem('token');
    var url = Uri.parse(dotenv.env['API_BACK']!+'/products');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
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
          ElevatedButton(
            onPressed: productGet,
            child: const Text('Actualizar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index]['name'].toString()),
                  subtitle: Text(products[index]['price'].toString()),
                  leading: Image.network(
                    dotenv.env['API_BACK']!+'/../images/1.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      print(error);
                      return Icon(Icons.error); // Muestra un ícono de error si falla la carga
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator(); // Muestra un indicador de carga mientras se descarga la imagen
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Formulario(
                              id: products[index]['id'],
                              name: products[index]['name'],
                              price: products[index]['price'],
                              amount: products[index]['amount'],
                            )),
                          );
                          productGet();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Se eliminará el producto'),
                                // content: const SingleChildScrollView(
                                //   child: ListBody(
                                //     children: <Widget>[
                                //       Text('This is a demo alert dialog.'),
                                //       Text('Would you like to approve of this message?'),
                                //     ],
                                //   ),
                                // ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Eliminar'),
                                    onPressed: () async {
                                      var token = localStorage.getItem('token');
                                      var url = Uri.parse(dotenv.env['API_BACK']!+'/products/'+products[index]['id'].toString());
                                      var response = await http.delete(url, headers: {
                                        'Authorization': 'Bearer $token',
                                      });
                                      if (response.statusCode == 200) {
                                        productGet();
                                      } else {
                                        print('Request failed with status: ${response.statusCode}.');
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // var url = Uri.parse(dotenv.env['API_BACK']!+'/products/'+products[index]['id'].toString());
                          // var response = await http.delete(url);
                          // if (response.statusCode == 200) {
                          //   productGet();
                          // } else {
                          //   print('Request failed with status: ${response.statusCode}.');
                          // }
                        },
                      ),
                    ],
                  ),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () async {
                  //     var url = Uri.parse(dotenv.env['API_BACK']!+'/products/'+products[index]['id'].toString());
                  //     var response = await http.delete(url);
                  //     if (response.statusCode == 200) {
                  //       productGet();
                  //     } else {
                  //       print('Request failed with status: ${response.statusCode}.');
                  //     }
                  //   },
                  // ),
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
