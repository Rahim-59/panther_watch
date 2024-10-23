import 'package:flutter/material.dart';
import 'package:panther_watch/navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

class MenuLayer extends StatefulWidget {
  @override
  State<MenuLayer> createState() => _MenuLayerState();
}

class _MenuLayerState extends State<MenuLayer> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: navigationProvider.screens[navigationProvider.selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(
              //   color: Colors.grey.withOpacity(0.5),
              //   spreadRadius: 5,
              //   blurRadius: 0,
              //   offset: Offset(5, 4), // changes position of shadow
              // ),
            ],
          ),
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
                                      iconSize: 20,
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
                                      iconSize: 20,
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
                                      iconSize: 20,
                                      icon: Icon(
                                        Icons.list_alt_sharp,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  Text(
                                    'Resources',
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
                                      iconSize: 20,
                                      icon: const Icon(Icons.list_alt_sharp)),
                                  const Text('Resources'),
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
                                      iconSize: 20,
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
                                      iconSize: 20,
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
                                      iconSize: 20,
                                      icon: Icon(
                                        Icons.report,
                                        color: Colors.red,
                                      )),
                                  Text(
                                    'Report',
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
                                      iconSize: 20,
                                      icon: const Icon(
                                        Icons.report,
                                        color: Colors.red,
                                      )),
                                  const Text('Report'),
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
      ),
    );
  }
}
