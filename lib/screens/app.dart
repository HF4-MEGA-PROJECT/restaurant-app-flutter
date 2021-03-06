import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/screens/account.dart';
import 'package:restaurant_app_flutter/screens/bar.dart';
import 'package:restaurant_app_flutter/screens/groups.dart';
import 'package:restaurant_app_flutter/screens/kitchen.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: const Color(0xff121212),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: false,
          hideNavigationBarWhenKeyboardShows: true,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          navBarStyle: NavBarStyle.style6,
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const GroupsPage(),
      const KitchenPage(),
      const BarPage(),
      const AccountPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        title: ("Groups"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.ballot_outlined),
        title: ("Kitchen"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.kitchen),
        title: ("Bar"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        title: ("Account"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }
}
