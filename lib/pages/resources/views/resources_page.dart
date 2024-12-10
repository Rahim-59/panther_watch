import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panther_watch/pages/resources/views/resource_page.dart';
import 'package:panther_watch/resources/models/ResourceCategory.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  Stream<List<Resourcecategory>> getCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('resource_categories')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Resourcecategory.fromDocument(doc))
              .toList(),
        );
  }

  void _launchPhoneNumber(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Container(
                height: 50,
                color: Color.fromARGB(255, 0, 58, 166),
              ),
              SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resources',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 15),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.report,
                      color: Colors.red,
                      size: 70,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Container(
                            width: 250,
                            child: Text(
                                'For immediate emergency services call: ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700))),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            _launchPhoneNumber('4044133333');
                          },
                            child: Text(
                          '404-413-3333',
                          style: TextStyle(fontSize: 25),
                        )),
                        Text('tap to call'),
                      ],
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Resourcecategory>>(
              stream: getCategoriesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading resources'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(''));
                }
          
                final resource_categories = snapshot.data!.reversed.toList();
          
                return ListView.builder(
                  itemCount: resource_categories.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final category = resource_categories[index];
          
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResourcePage(category_id: category.id, title: category.title)));
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 58, 166),
                              ),
                              child: Center(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      category.title,
                                      style: TextStyle(
                                          letterSpacing: 2, color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
