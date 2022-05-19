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

  void _addGroup() {
    groupsAmount += 1;


  }

  void _goToGroup() {}

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("You are about to add group N")
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
              onPressed: _addGroup,
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
        title: const Text("Groups"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          int count = 2;
          if (orientation == Orientation.landscape) {
            count = 3;
          }
          if (groupsAmount < 1) {
            return Center(
              child: Text(
                defaultText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 40),
              ),
            );
          } else {
            return GridView.count(
              crossAxisCount: count,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _goToGroup,
                  label: const Text('Group 1', style: TextStyle(fontSize: 15.0)),
                  icon: const Icon(Icons.add),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        tooltip: 'Add group',
        child: const Icon(Icons.add),
      ),
    );
  }
}
