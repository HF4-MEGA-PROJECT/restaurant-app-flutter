import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/models/orders.dart';

import '../services/orders.dart';

class OrdersPage extends StatefulWidget {
  final int? categoryId;
  const OrdersPage({Key? key,this.categoryId }) : super(key: key);
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}


class _OrdersPageState extends State<OrdersPage> {

  Future<List<Orders>> getCategories() async{
    return await OrderService().getAllCategoriesById(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Orders>>(future: getCategories(), builder: (context,snapshot){
      if(snapshot.hasData){
        List<Widget> categoryWidgets = <Widget>[];
        snapshot.data?.forEach((element) {
          categoryWidgets.add(
              ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrdersPage(categoryId: element.id,))),
                  icon: Icon(Icons.ac_unit_outlined),
                  label: Text(element.name)
              )
          );
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('Category'),
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
                itemBuilder: (BuildContext context, int index) {
                  return categoryWidgets[index];
              },itemCount: categoryWidgets.length,
              )
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}