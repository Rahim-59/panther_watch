import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panther_watch/events/models/Events.dart';
import 'package:panther_watch/events/services/EventServices.dart';

class EventsPage extends StatefulWidget {
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isLoading = false;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the list
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(event.name)),
                  );
                })
          ],
        ),
      ),
    );
  }
}
