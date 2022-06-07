import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/order_service_factory.dart';
import 'package:restaurant_app_flutter/models/group.dart';
import 'package:restaurant_app_flutter/models/order.dart';
import 'package:restaurant_app_flutter/models/product.dart';
import 'package:restaurant_app_flutter/screens/category.dart';

import '../factories/order_service_factory.dart';
import 'package:restaurant_app_flutter/screens/login.dart';
import 'package:restaurant_app_flutter/services/order.dart';

class GroupPage extends StatefulWidget {
  final Group group;

  const GroupPage({required this.group, Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Future<List<Order>> getGroupOrders() async {
    OrderService orderService = (await OrderServiceFactory.make());
    return await orderService.getGroupOrders(widget.group);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: getGroupOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> orderWidgets = <Widget>[];

          for (var order in snapshot.data!) {
            orderWidgets.add(
              OrderWidget(
                order: order,
              ),
            );
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Orders for group ${widget.group.number}'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RefreshIndicator(
                  onRefresh: () async => setState(() {}),
                  child: orderWidgets.isEmpty
                      ? Stack(
                          children: <Widget>[
                            ListView(
                              children: const [
                                Text(
                                  'No orders, pull down to refresh',
                                  style: TextStyle(fontSize: 40),
                                )
                              ],
                            ),
                          ],
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            crossAxisSpacing: 40,
                            mainAxisSpacing: 40,
                          ),
                          itemCount: orderWidgets.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return StatefulBuilder(
                              builder: (context, setState) => orderWidgets[index],
                            );
                          },
                        ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CategoryPage(),
                  ),
                ),
                tooltip: 'Add order',
                child: const Icon(Icons.add),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          if (snapshot.error is DioError && (snapshot.error as DioError).response?.statusCode == 401) {
            BearerTokenFactory.make().then(
              (bearerTokenService) {
                bearerTokenService.deleteBearerToken();
                pushNewScreen(
                  context,
                  screen: const LoginPage(),
                  withNavBar: false,
                  customPageRoute: PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                    transitionDuration: Duration.zero,
                  ),
                );
              },
            );
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade900,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.order.getHourMinutes(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '#' + widget.order.id.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ...getProductTexts(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Total: ${widget.order.totalPrice().round().toString()},-',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getProductTexts() {
    Map<int, int> productIdToCountMap = {};

    for (Product product in widget.order.getProducts()) {
      productIdToCountMap.update(product.id, (value) => value + 1, ifAbsent: () => 1);
    }

    List<Widget> textWidgets = [];

    productIdToCountMap.forEach((productId, count) {
      Product product = widget.order.getProducts().where((product) => product.id == productId).first;

      textWidgets.add(
        Container(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  count.toString() + 'x ' + product.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                (product.price * count).round().toString() + ',-',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1.1))),
        ),
      );
    });

    return textWidgets;
  }
}
