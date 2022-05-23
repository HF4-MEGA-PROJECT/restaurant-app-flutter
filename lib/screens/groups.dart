import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/screens/Groups.dart';

class GroupsPage extends StatefulWidget {
  static const String route = '/groups';

  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  String bearerToken = '';
  String defaultText = 'No groups yet';
  int groupsAmount = 0;
  final List<Widget> _groupList = [];

  Widget _group() {
    return ElevatedButton.icon(
      onPressed: _goToGroup,
      label: const Text('Group' 'N', style: TextStyle(fontSize: 15.0)),
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

  Future<void> _addNewGroup() async {
    String dropdownValue = 'One';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Add amount of people for this group"),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add group'),
              onPressed: _addGroupToList,
            ),
          ],
        );
      },
    );
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
        onPressed: _addNewGroup,
        tooltip: 'Add group',
        child: const Icon(Icons.add),
      ),
    );
  }
}
