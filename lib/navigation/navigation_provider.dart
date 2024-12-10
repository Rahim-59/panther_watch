import 'package:flutter/material.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';
import 'package:panther_watch/pages/chat/chat.dart';
import 'package:panther_watch/pages/events/views/events_page.dart';
import 'package:panther_watch/pages/home/home.dart';
import 'package:panther_watch/pages/home/views/admin_home.dart';
import 'package:panther_watch/pages/report/report.dart';
import 'package:panther_watch/pages/report/views/admin_reports.dart';
import 'package:panther_watch/pages/resources/resources.dart';
import 'package:panther_watch/pages/resources/views/users_page.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 2;
  String type = 'user';

  int get selectedIndex => _selectedIndex;

  List<Widget> _screens = [
    ChatPage(),
    ResourcesPage(),
    HomePage(),
    EventsPage(),
    ReportPage()
  ];

  List<Widget> get screens => _screens;

  NavigationProvider() {
    getType();
  }

  void getType() async {
    try {
      final response = await AuthService.getUserDetails();

      if (response != null) {
        type = response['type'];

        if (type == 'admin') {
          _screens = [
            ChatPage(),
            UsersPage(),
            AdminHomePage(),
            EventsPage(),
            ReportsPage()
          ];
        } else {
          _screens = [
            ChatPage(),
            ResourcesPage(),
            HomePage(),
            EventsPage(),
            ReportPage()
          ];
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setIndex(index) {
    _selectedIndex = index;
    notifyListeners();
  }

}
