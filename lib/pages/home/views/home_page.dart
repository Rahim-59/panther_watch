import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';
import 'package:panther_watch/events/models/Events.dart';
import 'package:panther_watch/events/services/EventServices.dart';
import 'package:panther_watch/navigation/navigation_provider.dart';
import 'package:panther_watch/pages/chat/views/board_page.dart';
import 'package:panther_watch/pages/events/widgets/events_card.dart';
import 'package:panther_watch/pages/profile/profile.dart';
import 'package:panther_watch/pages/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  String username = '';
  String type = 'user';
  Timer? locationTimer;
  List<Event> events = [];
  LatLng _center = LatLng(-190, -190);
  List<Map<String, dynamic>> boards = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getInfo();
    getEvents();
  }
  

  void _getInfo() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await AuthService.getUserDetails();

      if (response != null) {
        setState(() {
          username = response['username'];
          type = response['type'];
        });

        getBoardsWithUsernameMessages(username);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void getEvents() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await EventService.getEvents(3);
      final eventsData = await jsonDecode(response);

      for (var objectsData in eventsData['value']) {
        final event = Event.fromJson(objectsData);
        setState(() {
          events.add(event);
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    if (mounted) {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              content: Text(
                  'In order to share location, please allow location services.'),
              actions: [
                TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          );
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    }

  }

  Future<String> getLastMessage(String boardId) async {
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (messagesSnapshot.docs.isNotEmpty) {
      return messagesSnapshot.docs.first['content'];
    } else {
      return 'No messages yet';
    }
  }

  void shareLocation() async {

    var sharePermission = false;

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Are you sure you want to share your location?',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Sharing will result in a call from the GSU Police Department')
                    ],
                  )),
               actions: [
                TextButton(onPressed: () {
                  setState(() {
                    sharePermission = true;
                  });
                  Navigator.pop(context);
                }, child: Text('Share Location')),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Cancel', style: TextStyle(color: Colors.red),)),
               ],
        )
    );

    if (mounted) {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              content: Text(
                  'In order to share location, please allow location services.'),
              actions: [
                TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          );
        }
      }
    }

    if (sharePermission) {

    Future<void> addLocation() async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('O3mvp8YGMOeIX72p2OJahw6vFrv2')
          .collection('shared_locations')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentID = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc('O3mvp8YGMOeIX72p2OJahw6vFrv2')
            .collection('shared_locations')
            .doc(documentID)
            .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'username': username,
          'active': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc('O3mvp8YGMOeIX72p2OJahw6vFrv2')
            .collection('shared_locations')
            .add({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'username': username,
          'active': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }

    addLocation();

    setState(() {
      // Set up periodic location updates
      locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
        await addLocation();
        print('Location Updated');
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Location is currently sharing',
          style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
    ));

    }
  }

  void cancelLocationSharing() async {

    final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('O3mvp8YGMOeIX72p2OJahw6vFrv2')
          .collection('shared_locations')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

    final documentID = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc('O3mvp8YGMOeIX72p2OJahw6vFrv2')
            .collection('shared_locations')
            .doc(documentID)
            .update({
          'active': false,
          'timestamp': FieldValue.serverTimestamp(),
        });

    setState(() {
      locationTimer?.cancel();
    });
  }

  Future<void> getBoardsWithUsernameMessages(String username) async {
    List<Map<String, dynamic>> matchingBoards = [];

    print(username);

    final boardsCollection = FirebaseFirestore.instance.collection('boards');

    final boardsSnapshot = await boardsCollection.get();

    for (var boardDoc in boardsSnapshot.docs) {
      // Reference to the messages subcollection within the current board
      final messagesCollection =
          boardsCollection.doc(boardDoc.id).collection('messages');

      final messagesSnapshot =
          await messagesCollection.where('author', isEqualTo: username).get();

      if (messagesSnapshot.docs.isNotEmpty) {
        var board = boardDoc.data();
        board['id'] = boardDoc.id;
        board['lastComment'] = await getLastMessage(boardDoc.id);
        matchingBoards.add(board);
      }
    }
    setState(() {
      boards = matchingBoards;
    });
  }

  String formatUtcDate(String utcDateString) {
    // Parse the UTC date string to a DateTime object
    DateTime utcDate = DateTime.parse(utcDateString);

    // Set the desired date format
    final DateFormat formatter = DateFormat("MMMM d'th' yyyy");

    // Format the date to a readable string
    String formattedDate = formatter.format(utcDate);

    // Get the day to apply the appropriate suffix
    String day = DateFormat('d').format(utcDate);
    String suffix = getDaySuffix(int.parse(day));
    formattedDate = formattedDate.replaceAll('th', suffix);

    return formattedDate;
  }

  String formatUtcTime(String utcDateString) {
    // Parse the UTC date string to a DateTime object
    DateTime utcDate = DateTime.parse(utcDateString);

    // Format the time to a readable string (e.g., 10:00 AM)
    final DateFormat timeFormatter = DateFormat("h:mm a");
    String formattedTime = timeFormatter
        .format(utcDate.toLocal()); // Convert to local time if needed

    return formattedTime;
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _launchUrl(_url) async {
    var url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .20,
                          height: MediaQuery.of(context).size.width * .20,
                          child: Image.asset('assets/logo.jpg'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back,',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            username,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w700),
                          ),
                          Text(formatUtcDate(DateTime.now().toString()) +
                              ' ' +
                              formatUtcTime(DateTime.now().toString()))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .20,
                          height: MediaQuery.of(context).size.width * .20,
                          color: const Color.fromARGB(255, 0, 58, 166),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            navigationProvider.setIndex(4);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .20,
                          height: MediaQuery.of(context).size.width * .20,
                          color: const Color.fromARGB(255, 0, 58, 166),
                          child: Icon(
                            Icons.report,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            navigationProvider.setIndex(1);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .20,
                          height: MediaQuery.of(context).size.width * .20,
                          color: const Color.fromARGB(255, 0, 58, 166),
                          child: Icon(
                            Icons.list_alt_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .20,
                          height: MediaQuery.of(context).size.width * .20,
                          color: const Color.fromARGB(255, 0, 58, 166),
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        if (_center != LatLng(-190, -190)) ...[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 207, 207, 207))),
                            child: GoogleMap(
                              initialCameraPosition:
                                  CameraPosition(target: _center, zoom: 17),
                              scrollGesturesEnabled: false,
                              zoomGesturesEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Center(
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 0, 58, 166),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          )
                        ],
                        Container(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: locationTimer != null &&
                                          locationTimer!.isActive
                                      ? cancelLocationSharing
                                      : shareLocation,
                                  child: Container(
                                    width: locationTimer != null &&
                                            locationTimer!.isActive
                                        ? 165
                                        : 120,
                                    height: 40,
                                    color: locationTimer != null &&
                                            locationTimer!.isActive
                                        ? Colors.red
                                        : const Color.fromARGB(255, 0, 58, 166),
                                    child: Center(
                                      child: Text(
                                        locationTimer != null &&
                                                locationTimer!.isActive
                                            ? 'Stop Sharing Location'
                                            : 'Share Location',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      navigationProvider.setIndex(4);
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    color:
                                        const Color.fromARGB(255, 0, 58, 166),
                                    child: Center(
                                      child: Text(
                                        'Report An Incident',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text(
                      'Your Boards',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (boards.isEmpty) ...[
                    Text('No boards found')
                  ] else ...[
                    Container(
                      height: 240,
                      child: ListView.separated(
                        itemCount: boards.length > 3 ? 3 : boards.length,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(
                          // Divider between each ListTile
                          thickness: 1, // Thickness of the divider
                          color: Colors.grey, // Color of the divider
                        ),
                        itemBuilder: (context, index) {
                          var board = boards[index];

                          return ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                            title: Text(
                              board['title']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              board['lastComment']!,
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Icon(
                                Icons.arrow_forward_ios), // Trailing arrow icon
                            onTap: () {
                              // Define what happens when the tile is tapped
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BoardPage(
                                          id: board['id'],
                                          title: board['title']!)));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              navigationProvider.setIndex(3);
                            });
                          },
                          child: Text(
                            'View All >',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 58, 166)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: events.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  _launchUrl(
                                      'https://pin.gsu.edu/event/${event.id}');
                                },
                                child: EventsCard(
                                  imageURL: event.imageURL,
                                  title: event.name,
                                  startDate: event.startDate,
                                  location: event.location,
                                ),
                              )),
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
