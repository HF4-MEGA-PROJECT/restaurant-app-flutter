import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/screens/Groups.dart';

class GroupsPage extends StatefulWidget {
  static const String route = '/groups';

  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  String defaultText = 'No groups yet';
  int groupsAmount = 0;
  final List<Widget> _groupList = [];

  final List<int> _numbers = [1,2,3,4,5,6,7,8,9];
  int? _selectedNumber = 0;

  Widget _group() {
    return ElevatedButton.icon(
      onPressed: _goToGroup,
      label: const Text('Group ' 'N' '\n\n cum', style: TextStyle(fontSize: 15.0)),
      icon: const Icon(Icons.edit),
    );
  }

  void _addGroupToList() {
    setState(() {
      groupsAmount += 1;
      _groupList.add(_group());
    });
  }

  Future<void> _goToGroup() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: _groupList.length,
            itemBuilder: (BuildContext ctx, index) {
              return _groupList[index];
            }),
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
                            style: const TextStyle(color: Colors.deepPurple),
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
                          _addGroupToList;
                          _selectedNumber = null;
                        },
                      ),
                    ],
                  );
                }
            );
          },
        ),
        tooltip: 'Add group',
        child: const Icon(Icons.add),
      ),
    );
  }
}
