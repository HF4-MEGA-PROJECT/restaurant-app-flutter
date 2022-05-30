import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:restaurant_app_flutter/screens/Groups.dart';
import 'package:restaurant_app_flutter/services/groupsService.dart';
import 'package:restaurant_app_flutter/models/group.dart';

class GroupsPage extends StatefulWidget {
  static const String route = '/groups';

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

  Widget _group(int? amountOfPeople, int? number) {
    return ElevatedButton.icon(
      key: Key(number.toString()),
      onPressed: _goToGroup,
      label: Text('Group $number' '\n\n $amountOfPeople people',
          style: const TextStyle(fontSize: 15.0)),
      icon: const Icon(Icons.edit),
    );
  }

  Future<void> _addNewGroup(int? amountOfPeople) async {
    try {
      var group = Group(null, amountOfPeople, null, null, null, null);

      await GroupsService().createGroup(group);

      setState(() {});
    } catch (e) {
      developer.log('Failed adding new group!', error: e);
      rethrow;
    }
  }

  Future<void> _goToGroup() async {}

  Future<List<Group>> getGroups() async {
    List<Group> groups = await GroupsService().getAllGroups();
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
              _groupWidgets.add(_group(group.amountOfPeople, group.number));
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
                    : RefreshIndicator(child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: _groupWidgets.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return _groupWidgets[index];
                    }), onRefresh: () async => setState(() {}))
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
                              _addNewGroup(_selectedNumber);
                              _selectedNumber = null;
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
