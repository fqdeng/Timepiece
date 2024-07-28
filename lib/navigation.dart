import 'package:flutter/material.dart';
import 'package:timepiece/event_bus.dart';
import 'counting_down.dart';
import 'domain/event.dart';
import 'settings.dart';
import 'history.dart';
import 'domain/event.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Navigation(),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;

  IconButton _SettingButton() {
    return IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Settings',
        onPressed: () {
          setState(() {
            _currentPageIndex = 2;
          });
        });
  }

  _BarIconButton() {
    switch (_currentPageIndex) {
      case 0:
        return _SettingButton();
      case 2:
        return Container();
      case 1:
        return IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: () {
            eventBus.fire(ClearHistoryEvent());
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Timepiece'),
          actions: <Widget>[_BarIconButton()],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: _currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.alarm),
              icon: Icon(Icons.alarm),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentPageIndex,
          children: const <Widget>[
            CountDown(),
            History(),
            Settings(),
          ],
        ));
  }
}
