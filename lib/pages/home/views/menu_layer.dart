import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';
import 'package:panther_watch/navigation/navigation_provider.dart';
import 'package:panther_watch/pages/login/login.dart';
import 'package:provider/provider.dart';

class MenuLayer extends StatefulWidget {
  @override
  State<MenuLayer> createState() => _MenuLayerState();
}

class _MenuLayerState extends State<MenuLayer> {
  bool _isLoggedIn = false;


  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    try {

      var session = AuthService.getCurrentUser();

      if (mounted) {
        setState(() {
          if (session != null) {
            _isLoggedIn = true;
            return;
          }

          _isLoggedIn = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Error checking auth status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final Size size = MediaQuery.of(context).size;

     if (!_isLoggedIn) {
      return LoginPage();
    } 

    return Scaffold(
      body: navigationProvider.screens[navigationProvider.selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                width: size.width,
                height: 70,
                child: Stack(
                  children: [
                    Center(
                        heightFactor: 0.6,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  navigationProvider.setIndex(2);
                                });
                              },
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 58, 166),
                                  borderRadius: BorderRadius.all(Radius.circular(200)),
                                ),
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      width: size.width,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              if (navigationProvider.selectedIndex == 0) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(0);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: Icon(
                                      Icons.chat_bubble_outline,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(
                                  'Chat',
                                  style: TextStyle(color: Color.fromARGB(255, 0, 58, 166)),
                                ),
                              ],
                              if (navigationProvider.selectedIndex != 0) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(0);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: const Icon(Icons.chat_bubble_outline)),
                                const Text('Chat'),
                              ],
                            ],
                          ),
                          Column(
                            children: [
                              if (navigationProvider.selectedIndex == 1) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(1);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: Icon(
                                      navigationProvider.type == 'user' ? Icons.list_alt_sharp : Icons.account_box_rounded,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(
                                  navigationProvider.type == 'user' ? 'Resources' : 'Users',
                                  style: TextStyle(color: Color.fromARGB(255, 0, 58, 166)),
                                ),
                              ],
                              if (navigationProvider.selectedIndex != 1) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(1);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: Icon(
                                      navigationProvider.type == 'user' ? Icons.list_alt_sharp : Icons.account_box_rounded
                                    )),
                                Text(
                                  navigationProvider.type == 'user' ? 'Resources' : 'Users',
                                ),
                              ],
                            ],
                          ),
                          Container(width: size.width * 0.1),
                          Column(
                            children: [
                              if (navigationProvider.selectedIndex == 3) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(3);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: Icon(
                                      Icons.event_available,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(
                                  'Events',
                                  style: TextStyle(color: Color.fromARGB(255, 0, 58, 166)),
                                ),
                              ],
                              if (navigationProvider.selectedIndex != 3) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(3);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: const Icon(Icons.event_available)),
                                const Text('Events'),
                              ],
                            ],
                          ),
                          Column(
                            children: [
                              if (navigationProvider.selectedIndex == 4) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(4);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: Icon(
                                      Icons.report,
                                      color: Colors.red,
                                    )),
                                Text(
                                  navigationProvider.type == 'user' ? 'Report' : 'Reports',
                                  style: TextStyle(color: Color.fromARGB(255, 0, 58, 166)),
                                ),
                              ],
                              if (navigationProvider.selectedIndex != 4) ...[
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationProvider.setIndex(4);
                                      });
                                    },
                                    iconSize: 25,
                                    icon: const Icon(
                                      Icons.report,
                                      color: Colors.red,
                                    )),
                                Text(
                                  navigationProvider.type == 'user' ? 'Report' : 'Reports',
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
