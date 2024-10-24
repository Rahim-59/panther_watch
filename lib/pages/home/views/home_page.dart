import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  LatLng _center = LatLng(-190, -190);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      isLoading = false;
    });
  }

  final List<Map<String, String>> boards = [
    {
      'title': 'General Discussion',
      'lastComment': 'Last comment by Alice: "I totally agree!"'
    },
    {
      'title': 'Tech Talk',
      'lastComment': 'Last comment by Bob: "Check out the new updates."'
    },
    {
      'title': 'Flutter Developers',
      'lastComment':
          'Last comment by Carol: "How do I handle state management?"'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back, John',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400),
                          ),
                          Text('Tuesday, October 22, 2024 8:51 PM')
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
                      Container(
                        width: MediaQuery.of(context).size.width * .20,
                        height: MediaQuery.of(context).size.width * .20,
                        color: const Color.fromARGB(255, 0, 58, 166),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .20,
                        height: MediaQuery.of(context).size.width * .20,
                        color: const Color.fromARGB(255, 0, 58, 166),
                        child: Icon(
                          Icons.report,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .20,
                        height: MediaQuery.of(context).size.width * .20,
                        color: const Color.fromARGB(255, 0, 58, 166),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .20,
                        height: MediaQuery.of(context).size.width * .20,
                        color: const Color.fromARGB(255, 0, 58, 166),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
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
                                  onTap: () {},
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    color:
                                        const Color.fromARGB(255, 0, 58, 166),
                                    child: Center(
                                      child: Text(
                                        'Share Location',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {},
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text(
                      'Your Boards',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: ListView.separated(
                      itemCount: boards.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(
                        // Divider between each ListTile
                        thickness: 1, // Thickness of the divider
                        color: Colors.grey, // Color of the divider
                      ),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            boards[index]['title']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            boards[index]['lastComment']!,
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(
                              Icons.arrow_forward_ios), // Trailing arrow icon
                          onTap: () {
                            // Define what happens when the tile is tapped
                            print('Tapped on ${boards[index]['title']}');
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
