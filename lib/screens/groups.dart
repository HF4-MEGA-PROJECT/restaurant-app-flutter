import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/factories/group_service_factory.dart';
import 'dart:developer' as developer;

import 'package:restaurant_app_flutter/models/group.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final List<int> _numbers = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
  ];
  int? _selectedNumber;

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
                    child: Text('${group.number}',
                        style: const TextStyle(
                            fontSize: 30.0, color: Colors.black)),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(Icons.people, size: 40),
                    ),
                    Text('${group.amountOfPeople}',
                        style: const TextStyle(fontSize: 25))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _showOptionsForGroup(BuildContext context, Group group) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return AlertDialog(
              title: Text("Options for group ${group.number}"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("Edit amount of people"),
                        ),
                        DropdownButton<int>(
                          value: group.amountOfPeople,
                          hint: const Text(""),
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (int? newValue) {
                            setStateForDialog(() {
                              group.amountOfPeople = newValue!;
                            });
                            editGroupAmountOfPeople(group);
                          },
                          items: _numbers.map((number) {
                            return DropdownMenuItem(
                              child: Text(number.toString()),
                              value: number,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                          onPressed: () => goToOrdersForGroup(),
                          child: Text("Go to orders for ${group.number}"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurpleAccent)),
                    ),
                    ElevatedButton(
                        onPressed: () =>
                            {deleteGroup(group), Navigator.of(context).pop()},
                        child: Text("Delete group ${group.number}")),
                  ],
                ),
              ),
            );
          });
        });
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> addNewGroup(int? amountOfPeople) async {
    try {
      var group = Group(null, amountOfPeople, null, null, null, null);

      await (await GroupServiceFactory.make()).createGroup(group);

      setState(() {});
    } catch (e) {
      developer.log('Failed adding new group!', error: e);
      rethrow;
    }
  }

  void goToOrdersForGroup() {}

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

            for (var group in _groupList!) {
              _groupWidgets.add(_group(context, group));
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Groups'),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _groupWidgets.isEmpty
                      ? const Text('No groups yet',
                          style: TextStyle(fontSize: 40))
                      : RefreshIndicator(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: _groupWidgets.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return _groupWidgets[index];
                              }),
                          onRefresh: () async => setState(() {}))),
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
                              DropdownButton<int>(
                                value: _selectedNumber,
                                hint: const Text("Choose a number"),
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (int? newValue) {
                                  setStateForDialog(() {
                                    _selectedNumber = newValue!;
                                  });
                                },
                                items: _numbers.map((number) {
                                  return DropdownMenuItem(
                                    child: Text(number.toString()),
                                    value: number,
                                  );
                                }).toList(),
                              ),
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
                            onPressed: () {
                              addNewGroup(_selectedNumber);
                              _selectedNumber = null;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                  },
                ),
                tooltip: 'Add group',
                child: const Icon(Icons.add),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
