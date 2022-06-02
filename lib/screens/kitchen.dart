import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/order_service_factory.dart';
import 'package:restaurant_app_flutter/models/order.dart';
import 'package:restaurant_app_flutter/models/order_product.dart';
import 'package:restaurant_app_flutter/models/product.dart';
import 'package:restaurant_app_flutter/screens/login.dart';
import 'package:restaurant_app_flutter/services/order.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key}) : super(key: key);

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  List<Order>? pendingOrders;

  Future<List<Order>> getPendingOrders() async {
    OrderService orderService = (await OrderServiceFactory.make());
    return await orderService.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: getPendingOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> orderWidgets = <Widget>[];

          for (var order in snapshot.data!) {
            orderWidgets.add(
              KitchenOrder(
                onDeletion: () {
                  print('deleting...');
                  setState(() {});
                },
                order: order,
              ),
            );
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Kitchen orders'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RefreshIndicator(
                  onRefresh: () async => setState(() {
                    print('refreshing');
                  }),
                  child: GridView.builder(
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

class KitchenOrder extends StatefulWidget {
  final Order order;
  final Function onDeletion;

  const KitchenOrder({Key? key, required this.onDeletion, required this.order}) : super(key: key);

  @override
  State<KitchenOrder> createState() => _KitchenOrderState();
}

class _KitchenOrderState extends State<KitchenOrder> {
  @override
  Widget build(BuildContext context) {
    bool allChecked = isChecked(widget.order.orderProducts);

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
                    if (allChecked)
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: () => widget.onDeletion(),
                            icon: const Icon(Icons.check),
                            label: const Text('Finish'),
                          ),
                        ),
                      )
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

      List<OrderProduct> orderProducts =
          widget.order.orderProducts.where((orderProduct) => orderProduct.productId == productId).toList();

      bool checked = isChecked(orderProducts);

      textWidgets.add(
        Container(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  count.toString() + 'x ' + product.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Transform.scale(
                scale: 1.6,
                child: Checkbox(
                  value: checked,
                  onChanged: (value) {
                    setState(() {
                      for (var orderProduct in orderProducts) {
                        if (value!) {
                          orderProduct.status = 'deliverable';
                        } else {
                          orderProduct.status = 'ordered';
                        }
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  activeColor: Colors.red.shade800,
                ),
              ),
            ],
          ),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1.1))),
        ),
      );
    });

    return textWidgets;
  }

  bool isChecked(List<OrderProduct> orderProducts) {
    bool checked = true;

    for (var orderProduct in orderProducts) {
      if (orderProduct.status == 'ordered') {
        checked = false;
        break;
      }
    }

    return checked;
  }
}
