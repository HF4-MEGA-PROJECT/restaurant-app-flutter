import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/screens/category.dart';
import 'package:restaurant_app_flutter/screens/groups.dart';
import 'package:restaurant_app_flutter/factories/group_service_factory.dart';
import 'package:restaurant_app_flutter/models/group.dart';

import '../factories/order_service_factory.dart';

class GroupPage extends StatefulWidget {
  final Group group;

  const GroupPage({required this.group, Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Group? group;

  @override
  void initState() {
    group = widget.group;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders for group ${group?.number}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
            onRefresh: () async => setState(() {}),
          child: ElevatedButton(
            onPressed: () async => { await (await OrderServiceFactory.make()).getOrdersForGroup(group!)}, child: null,
          ),
            ),
        ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add order',
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CategoryPage()));
        },
      ),
    );
  }
}
