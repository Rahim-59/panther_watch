
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panther_watch/resources/models/Resource.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcePage extends StatefulWidget {
  final String category_id;
  final String title;

  const ResourcePage({super.key, required this.category_id, required this.title});

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {

  Stream<List<Resource>> getResourcesStream() {
    return FirebaseFirestore.instance
        .collection('resource_categories')
        .doc(widget.category_id)
        .collection('resources')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Resource.fromDocument(doc))
              .toList(),
        );
  }

  void _launchUrl(_url) async {
    var url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Expanded(
            child: StreamBuilder<List<Resource>>(
              stream: getResourcesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error loading resources'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(''));
                }
            
                final resources = snapshot.data!;
            
                return ListView.builder(
                  itemCount: resources.length,
                  itemBuilder: (context, index) {
                    final resource = resources[index];
              
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            resource.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            resource.desciption,
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _launchUrl(resource.url);
                          },
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