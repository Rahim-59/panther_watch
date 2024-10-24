import 'package:flutter/material.dart';

class EventsCard extends StatelessWidget {
  final String imageURL;
  final String title;
  final String startDate;
  final String location;

  EventsCard({required this.imageURL, required this.title, required this.startDate, required this.location});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 373,
        // color: Colors.red,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(imageURL),
                fit: BoxFit.fill,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.date_range),
                      SizedBox(width: 5),
                      Text(startDate)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 2,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 35,
              color: const Color.fromARGB(255, 226, 226, 226),
            )
          ],
        ),
      ),
    );
  }
}
