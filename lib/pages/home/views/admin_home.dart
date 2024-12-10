import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';
import 'package:panther_watch/navigation/navigation_provider.dart';
import 'package:panther_watch/pages/home/widgets/Location.dart';
import 'package:panther_watch/pages/profile/profile.dart';
import 'package:panther_watch/pages/settings/settings.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool isLoading = false;
  LatLng _center = LatLng(-190, -190);
  String id = FirebaseAuth.instance.currentUser!.uid;
  Set<Marker> markers = {};
  String username = '';
  String type = 'user';

  @override
  void initState() {
    super.initState();
    _getInfo();
    _getCurrentLocation();
  }

  Stream<List<Location>> getLocationsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('shared_locations')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Location.fromDocument(doc)).toList(),
        );
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

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
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
                      Icons.account_box_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingsPage()));
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
          ),
          Expanded(
            child: StreamBuilder<List<Location>>(
              stream: getLocationsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error loading locations'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(''));
                }

                final locations = snapshot.data!;

                return GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 17),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: locations
                      .where((location) => location.active == true)
                      .map((location) {
                    return Marker(
                      markerId: MarkerId(location.id),
                      position: LatLng(location.latitude, location.longitude),
                      draggable: false,
                      infoWindow: InfoWindow(
                        title: location.username,
                        snippet: location.timestamp.toDate().toString(),
                      ),
                    );
                  }).toSet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
