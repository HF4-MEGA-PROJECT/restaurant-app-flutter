import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}


class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
         child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red[700],
                child: const Text("Forretter"),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red[700],
                child: const Text('Hovedretter'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red[700],
                child: const Text('Desserter'),
              ),
            ],
          )
      ),
    );
  }
}