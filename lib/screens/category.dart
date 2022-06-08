import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/category_service_factory.dart';
import 'package:restaurant_app_flutter/factories/product_service_factory.dart';
import 'package:restaurant_app_flutter/models/category.dart';
import 'package:restaurant_app_flutter/models/group.dart';

import '../models/product.dart';
import 'login.dart';

class CategoryPage extends StatefulWidget {
  final Group group;
  const CategoryPage({Key? key, required this.group}) : super(key: key);
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Category? currentCategory;

  Future<void> goBackToCategoryRoot() async {
    setState(() {
      currentCategory = null;
    });
  }

  Future<bool> _onWillPop() async {
    if (currentCategory == null) {
      return true;
    }

    if (currentCategory!.categoryId == null) {
      setState(() {
        currentCategory = null;
      });
      return false;
    }

    List<Category> categoryList = await (await CategoryServiceFactory.make()).getAllCategories();

    setState(() {
      currentCategory = categoryList.where(((element) => element.id == currentCategory!.categoryId)).first;
    });

    return false;
  }

  Future<List<Category>> getCategories() async {
    if (currentCategory == null) {
      List<Category> categoryList = await (await CategoryServiceFactory.make()).getAllCategories();
      return categoryList.where((element) => element.categoryId == null).toList();
    }
    return await (await CategoryServiceFactory.make()).getAllCategoriesById(currentCategory!.id);
  }

  Future<List<Product>> getProducts() async {
      List<Product> productList = await (await ProductServiceFactory.make()).getAllProducts();
      if(currentCategory == null){
        return productList.where((element) => element.categoryId == null).toList();
      }
      return productList.where((element) => element.categoryId == currentCategory!.id).toList();
  }

  Future<Map<String,dynamic>> getProductsAndCategories() async{
    Map<String,dynamic> productsAndCategories = {
      "products": await getProducts(),
      "categories": await getCategories()
    };
    return productsAndCategories;
  }

  List<int> orders = [];

  void _onClick(int value){
    orders.add(value);
    print(orders);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>>(
      future: getProductsAndCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Category> categories = snapshot.data!["categories"];
          List<Product> products = snapshot.data!["products"];
          List<Widget> categoryWidgets = <Widget>[];
          List<Widget> productWidgets = <Widget>[];
          categories.forEach(
            (element) {
              categoryWidgets.add(
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentCategory = element;
                    });
                  },
                  child: Text(
                    element.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              );
            },
          );
          products.forEach(
                (element) {
              productWidgets.add(
                ElevatedButton(
                  onPressed: () => _onClick(element.id),
                  child: Text(
                    element.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              );
            },
          );

          print(products.length.toString());

          List<Widget> Widgets = [];
          Widgets.addAll(categoryWidgets);
          Widgets.addAll(productWidgets);

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Category'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Widgets[index];
                  },
                  itemCount: Widgets.length,
                ),
              ),
              floatingActionButton: currentCategory == null
                  ? null
                  : FloatingActionButton(
                      onPressed: goBackToCategoryRoot,
                      tooltip: 'Go back to categories root',
                      child: const Icon(Icons.keyboard_return_rounded),
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
