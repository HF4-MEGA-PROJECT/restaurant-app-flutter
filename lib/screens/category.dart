import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/category_service_factory.dart';
import 'package:restaurant_app_flutter/models/category.dart';

import 'login.dart';

class CategoryPage extends StatefulWidget {
  final Category? category;
  const CategoryPage({Key? key, this.category}) : super(key: key);
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Category? currentCategory;

  @override
  void initState() {
    currentCategory = widget.category;
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> categoryWidgets = <Widget>[];
          snapshot.data?.forEach(
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
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Category'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return categoryWidgets[index];
                  },
                  itemCount: categoryWidgets.length,
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
