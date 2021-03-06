import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/group_service_factory.dart';
import 'dart:developer' as developer;

import 'package:restaurant_app_flutter/models/group.dart';
import 'package:restaurant_app_flutter/screens/group.dart';
import 'package:restaurant_app_flutter/screens/login.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int? _selectedNumber;

  showDeleteAlertDialog(BuildContext context, Group group) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: const Text("Delete group"),
      style: TextButton.styleFrom(primary: Colors.red),
      onPressed: () {
        deleteGroup(group);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Notice"),
      content: const Text(
          "Pressing on 'Delete group' will remove this group permanently"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _group(BuildContext context, Group group) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
      key: Key(group.number.toString()),
      onPressed: () => _showOptionsForGroup(context, group),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  '${group.number}',
                  style: const TextStyle(fontSize: 30.0, color: Colors.black),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.people, size: 40),
                ),
                Text(
                  '${group.amountOfPeople}',
                  style: const TextStyle(fontSize: 25),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showOptionsForGroup(BuildContext context, Group group) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateForDialog) {
            return AlertDialog(
              title: Text(
                "Options for group ${group.number}",
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Text("Edit amount of people",
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                initialValue: group.amountOfPeople.toString(),
                                decoration: const InputDecoration(
                                  hintText: "Choose a number",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                                onSaved: (newValue) {
                                  setStateForDialog(() {
                                    int? integer = 1;
                                    if (int.tryParse(newValue!) != null) {
                                      integer = int.tryParse(newValue)!;
                                    }
                                    group.amountOfPeople = integer;
                                    if (group.amountOfPeople! > 99) {
                                      group.amountOfPeople = 99;
                                    }

                                    editGroupAmountOfPeople(group);
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                          )),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState?.save();
                              },
                              child: const Text("Confirm"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await goToOrdersForGroup(group);
                        },
                        child: Text("Go to orders for group ${group.number}"),
                        style:
                            ElevatedButton.styleFrom(primary: Colors.lightBlue),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDeleteAlertDialog(context, group);
                        },
                        child: Text("Delete group ${group.number}")),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return const Center(child: CircularProgressIndicator());
  }

  Future<Group> addNewGroup(int? amountOfPeople) async {
    try {
      amountOfPeople ??= 1;
      var group = Group(null, amountOfPeople, null, null, null, null);

      Group newGroup = await (await GroupServiceFactory.make()).createGroup(group);

      setState(() {});
      return newGroup;
    } catch (e) {
      developer.log('Failed adding new group!', error: e);
      rethrow;
    }
  }

  Future<void> goToOrdersForGroup(Group group) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => GroupPage(group: group)));
  }

  Future<void> deleteGroup(Group group) async {
    await (await GroupServiceFactory.make()).deleteGroup(group);
    setState(() {});
  }

  Future<void> editGroupAmountOfPeople(Group group) async {
    await (await GroupServiceFactory.make()).updateGroup(group);
    setState(() {});
  }

  Future<List<Group>> getGroups() async {
    List<Group> groups =
        await (await GroupServiceFactory.make()).getAllGroups();
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Group>>(
      future: getGroups(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Group>? _groupList = snapshot.data;
          List<Widget> _groupWidgets = [];

          _groupList?.sort((a, b) => a.number!.compareTo(b.number!));

          for (var group in _groupList!) {
            _groupWidgets.add(_group(context, group));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Groups'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: _groupWidgets.isEmpty
                    ? Stack(
                        children: <Widget>[
                          ListView(
                            children: const [
                              Text(
                                'No groups yet, pull down to refresh',
                                style: TextStyle(fontSize: 40),
                              )
                            ],
                          ),
                        ],
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _groupWidgets.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return _groupWidgets[index];
                        },
                      ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setStateForDialog) {
                      return AlertDialog(
                        title: const Text('Add a new group'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              const Text("Add amount of people for this group"),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                initialValue: null,
                                decoration: const InputDecoration(
                                  hintText: "Choose a number",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setStateForDialog(() {
                                    int? integer = 0;
                                    if (int.tryParse(newValue) != null) {
                                      integer = int.tryParse(newValue)!;
                                    }
                                    _selectedNumber = integer;
                                    if (_selectedNumber! > 99) {
                                      _selectedNumber = 99;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _selectedNumber = null;
                            },
                          ),
                          TextButton(
                            child: const Text('Add group'),
                            onPressed: () async {
                              Group newGroup =
                                  await addNewGroup(_selectedNumber);
                              _selectedNumber = null;
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    GroupPage(group: newGroup),
                              ));
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              tooltip: 'Add group',
              child: const Icon(Icons.add),
            ),
          );
        }

        if (snapshot.hasError) {
          if (snapshot.error is DioError &&
              (snapshot.error as DioError).response?.statusCode == 401) {
            BearerTokenFactory.make().then(
              (bearerTokenService) {
                bearerTokenService.deleteBearerToken();
                pushNewScreen(
                  context,
                  screen: const LoginPage(),
                  withNavBar: false,
                  customPageRoute: PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginPage(),
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
