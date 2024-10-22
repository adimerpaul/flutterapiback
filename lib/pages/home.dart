import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var contador = 0;
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
        children:  <Widget>[
          Text('Contador:' + contador.toString()),
          ElevatedButton(
              onPressed: aumentar,
              child: Text('Incrementar')
          )
        ],
      ),
    );
  }
}
