import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/screens/category.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
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
    );
  }
}
