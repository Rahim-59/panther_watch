import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 20,
                    color: const Color.fromARGB(255, 167, 167, 167),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .20,
                          height: MediaQuery.of(context).size.width * .20,
                          child: Image.asset('assets/logo.jpg'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back, John',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
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
                      child: Container(
                        color: Colors.red,
                        height: 200,
                        child: Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 17),
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                            ),
                            Container(
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 120,
                                      height: 40,
                                      color: const Color.fromARGB(255, 0, 58, 166),
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
                                      color: const Color.fromARGB(255, 0, 58, 166),
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Your Boards',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
