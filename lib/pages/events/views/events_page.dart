import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panther_watch/events/models/Events.dart';
import 'package:panther_watch/events/models/Organization.dart';
import 'package:panther_watch/events/services/EventServices.dart';
import 'package:panther_watch/pages/events/widgets/events_card.dart';

class EventsPage extends StatefulWidget {
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isLoading = false;
  List<Event> events = [];
  List<Organization> organizations = [];

  @override
  void initState() {
    super.initState();
    getOrganizations();
    getEvents();
  }

  void getEvents() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await EventService.getEvents(15);
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

  void getOrganizations() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await EventService.getOrganizations(15);
      final orgData = await jsonDecode(response);

      for (var objectsData in orgData['value']) {
        final org = Organization.fromJson(objectsData);
        setState(() {
          organizations.add(org);
        });
      }

      setState(() {
        organizations = organizations.where((org) => org.shortName.isNotEmpty && org.imageURL.isNotEmpty).toList();
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                child: Image.asset(
                  'assets/pin-logo.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Explore Organizations',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: organizations.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final org = organizations[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 58, 166), borderRadius: BorderRadius.circular(50), image: DecorationImage(image: NetworkImage(org.imageURL), fit: BoxFit.cover)),
                                  ),
                                  SizedBox(height: 5),
                                  Text(org.shortName, style: TextStyle(overflow: TextOverflow.ellipsis),)
                                ],
                              ),
                            )),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Events',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: events.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: EventsCard(
                            imageURL: event.imageURL,
                            title: event.name,
                            startDate: event.startDate,
                            location: event.location,
                          )),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
