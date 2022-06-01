import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/factories/order_service_factory.dart';
import 'package:restaurant_app_flutter/models/order.dart';
import 'package:restaurant_app_flutter/models/product.dart';
import 'package:restaurant_app_flutter/services/order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order>? pendingOrders;

  Future<List<Order>> getPendingOrders() async {
    OrderService orderService = (await OrderServiceFactory.make());
    return await orderService.getOrders();
  }

  List<ElevatedButton> getOrderWidgets(List<Order> orders) {
    List<ElevatedButton> orderWidgets = <ElevatedButton>[];

    for (var order in orders) {
      orderWidgets.add(
        ElevatedButton(
          onPressed: () => print('click'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Order ' + order.id.toString(),
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                ),
                ...getProductTexts(order)
              ]
            )
          )
        )
      );
    }

    return orderWidgets;
  }

  List<Text> getProductTexts(Order order) {
    Map<int, int> productIdToCountMap = {};

    for(Product product in order.products) {
      productIdToCountMap.update(product.id, (value) => value + 1, ifAbsent: () => 1);
    }

    List<Text> textWidgets = [];

    productIdToCountMap.forEach((key, value) {
      textWidgets.add(Text(value.toString() + 'x ' + order.products.where((product) => product.id == key).first.name));
    });

    return textWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: getPendingOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ElevatedButton> orderWidgets = getOrderWidgets(snapshot.data!);

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Orders'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0), 
                child: RefreshIndicator(
                  onRefresh: () async => setState(() {}),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 6 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      crossAxisCount: 1
                    ),
                    itemCount: orderWidgets.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return orderWidgets[index];
                    }
                  )
                )
              )
            )
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
