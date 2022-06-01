import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/models/category.dart';

import '../services/category.dart';


class OrdersPage extends StatefulWidget {
  final int? categoryId;
  const OrdersPage({Key? key,this.categoryId }) : super(key: key);
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}


class _OrdersPageState extends State<OrdersPage> {

  Future<void> goBackToCategoryRoot() async {
    await Navigator.of(context).pushNamed('/category');
  }

  Future<List<Category>> getCategories() async{
    if(widget.categoryId == null){
      List<Category> categoryList = await CategoryService().getAllCategories();
      return categoryList.where((element) => element.categoryId == null).toList();
    }
    return await CategoryService().getAllCategoriesById(widget.categoryId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(future: getCategories(), builder: (context,snapshot){
      if(snapshot.hasData){
        List<Widget> categoryWidgets = <Widget>[];
        snapshot.data?.forEach((element) {
          categoryWidgets.add(
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrdersPage(categoryId: element.id,))),
                  child: Text(
                      element.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      ),
                  )
              )
          );
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('category'),
          ),
          body: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3/2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return categoryWidgets[index];
              },itemCount: categoryWidgets.length,
              )
          ),
          floatingActionButton: FloatingActionButton(
          onPressed: goBackToCategoryRoot,
          tooltip: 'Go back to categories root',
          child: const Icon(Icons.keyboard_return_rounded),
        ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}