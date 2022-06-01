import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurant_app_flutter/factories/group_service_factory.dart';
import 'dart:developer' as developer;

import 'package:restaurant_app_flutter/models/group.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int? selectedNumber;

  Future<void> addNewGroup(int? amountOfPeople) async {
    try {
      if (amountOfPeople! > 99) {
        amountOfPeople = 99;
      }
      var group = Group(null, amountOfPeople, null, null, null, null);

      await (await GroupServiceFactory.make()).createGroup(group);

      setState(() {});
    } catch (e) {
      developer.log('Failed adding new group!', error: e);
      rethrow;
    }
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
              _groupWidgets.add(GroupWidget(group: group));
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Groups'),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _groupWidgets.isEmpty
                      ? const Text('No groups yet \n Pull down to refresh',
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
                      return AlertDialog(
                        title: const Text('Add a new group'),
                        content: SingleChildScrollView(
                            child: Form(
                          child: ListBody(
                            children: <Widget>[
                              const Text("Add amount of people for this group"),
                              TextFormFieldWidget(
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedNumber = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        )),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Add group'),
                            onPressed: () {
                              addNewGroup(selectedNumber);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }),
                tooltip: 'Add group',
                child: const Icon(Icons.add),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ShowOptionsWidget extends StatefulWidget {
  final Group group;
  final Function onChanged;

  const ShowOptionsWidget({
    required this.group,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _ShowOptionsWidgetState createState() => _ShowOptionsWidgetState();
}

class _ShowOptionsWidgetState extends State<ShowOptionsWidget> {
  Group? group;
  int? selectedNumber;

  @override
  void initState() {
    group = widget.group;
    super.initState();
  }

  Future<void> editGroupAmountOfPeople(Group group) async {
    if (group.amountOfPeople! > 99) {
      group.amountOfPeople = 99;
    }
    await (await GroupServiceFactory.make()).updateGroup(group);
    setState(() {});
  }

  void goToOrdersForGroup() {}

  Future<void> deleteGroup(Group group) async {
    await (await GroupServiceFactory.make()).deleteGroup(group);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setStateForDialog) {
      return AlertDialog(
        title: Text("Options for group ${group!.number}"),
        content: SingleChildScrollView(
            child: Form(
          child: ListBody(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("Edit amount of people"),
                  ),
                  Expanded(
                      child: TextFormFieldWidget(
                    selectedNumber: group!.amountOfPeople,
                    onChanged: (int? newValue) {
                      setState(() {
                        group!.amountOfPeople = newValue;
                        widget.onChanged(newValue);
                        editGroupAmountOfPeople(group!);
                      });
                    },
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                    onPressed: () => goToOrdersForGroup(),
                    child: Text("Go to orders for group ${group!.number}"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurpleAccent)),
              ),
              ElevatedButton(
                  onPressed: () =>
                      {deleteGroup(group!), Navigator.of(context).pop()},
                  child: Text("Delete group ${group!.number}")),
            ],
          ),
        )),
      );
    });
  }
}

class GroupWidget extends StatefulWidget {
  final Group group;

  const GroupWidget({
    required this.group,
    Key? key,
  }) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  Group? group;

  @override
  void initState() {
    group = widget.group;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return ShowOptionsWidget(
                group: group!,
                onChanged: (int? value) => setState(() {
                  group!.amountOfPeople = value;
                }),
              );
            }),
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
                    child: Text('${group!.number}',
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
                    Text('${group!.amountOfPeople}',
                        style: const TextStyle(fontSize: 25))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class TextFormFieldWidget extends StatefulWidget {
  final int? selectedNumber;
  final Function onChanged;

  const TextFormFieldWidget({
    this.selectedNumber,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  int? selectedNumber;
  Function? onChanged;

  @override
  void initState() {
    selectedNumber = widget.selectedNumber;
    onChanged = widget.onChanged;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setStateForDialog) {
      return TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        initialValue: selectedNumber?.toString(),
        decoration: const InputDecoration(
          hintText: "Choose a number",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
        ),
        onChanged: (value) {
          setState(() {
            int integer = 0;
            if (int.tryParse(value) != null) {
              integer = int.tryParse(value)!;
            }
            selectedNumber = integer;
            onChanged!(integer);
          });
        },
      );
    });
  }
}
