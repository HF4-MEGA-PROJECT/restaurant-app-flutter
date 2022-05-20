import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends BottomNavigationBar {
  CustomBottomNavigationBar({Key? key, required BuildContext context}): super(key: key, items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.accessible_forward_sharp),
      label: 'Groups'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Account'
    ),
  ], onTap: (int index) {
    String route = '';

    switch(index) {
      case 0:
        route = '/groups';
      break;
      case 1:
        route = '/account';
      break;
      default:
      return;
    }

    if(ModalRoute.of(context)?.settings.name != route) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  });
}