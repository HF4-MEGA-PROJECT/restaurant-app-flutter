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
                        child: ListBody(
                          children: <Widget>[
                            const Text("Add amount of people for this group"),
                            DropDownWidget()
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            DropDownWidget().selectedNumber = null;
                          },
                        ),
                        TextButton(
                          child: const Text('Add group'),
                          onPressed: () {
                            addNewGroup(DropDownWidget().selectedNumber);
                            DropDownWidget().selectedNumber = null;
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

  const ShowOptionsWidget({
    required this.group,
    Key? key,
  }) : super(key: key);

  @override
  _ShowOptionsWidgetState createState() => _ShowOptionsWidgetState();
}

class _ShowOptionsWidgetState extends State<ShowOptionsWidget> {
  final List<int> _numbers = [for(var i=1; i<=15; i+=1) i];

  Future<void> editGroupAmountOfPeople(Group group) async {
    await (await GroupServiceFactory.make()).updateGroup(group);
    setState(() {});
  }

  void goToOrdersForGroup() {}

  Future<void> deleteGroup(Group group) async {
    await (await GroupServiceFactory.make()).deleteGroup(group);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return AlertDialog(
              title: Text("Options for group ${widget.group.number}"),
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
                          value: widget.group.amountOfPeople,
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
                              widget.group.amountOfPeople = newValue!;
                            });
                            editGroupAmountOfPeople(widget.group);
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
                          child:
                              Text("Go to orders for ${widget.group.number}"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurpleAccent)),
                    ),
                    ElevatedButton(
                        onPressed: () => {
                              deleteGroup(widget.group),
                              Navigator.of(context).pop()
                            },
                        child: Text("Delete group ${widget.group.number}")),
                  ],
                ),
              ),
            );
          });
        });
    return const Center(child: CircularProgressIndicator());
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
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
        onPressed: () => ShowOptionsWidget(group: widget.group),
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
                    child: Text('${widget.group.number}',
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
                    Text('${widget.group.amountOfPeople}',
                        style: const TextStyle(fontSize: 25))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class DropDownWidget extends StatefulWidget {
  final List<int> _numbers = [for(var i=1; i<=15; i+=1) i];
  int? selectedNumber;

  DropDownWidget({
    this.selectedNumber,
    Key? key,
  }) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setStateForDialog) {
      return DropdownButton<int>(
        value: widget.selectedNumber,
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
            widget.selectedNumber = newValue!;
          });
        },
        items: widget._numbers.map((number) {
          return DropdownMenuItem(
            child: Text(number.toString()),
            value: number,
          );
        }).toList(),
      );
    });
  }
}
