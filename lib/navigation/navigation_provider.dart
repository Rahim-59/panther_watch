import 'package:flutter/material.dart';
import 'package:panther_watch/pages/chat/chat.dart';
import 'package:panther_watch/pages/events/views/events_page.dart';
import 'package:panther_watch/pages/home/home.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 2;

  int get selectedIndex => _selectedIndex;

  void setIndex(index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    ChatPage(),
    Placeholder(),
    HomePage(),
    EventsPage(),
    Placeholder()
  ];

  List<Widget> get screens => _screens;
}
