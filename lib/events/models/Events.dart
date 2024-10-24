class Event {
  final String id;
  final String name;
  final String organizationName;
  final String description;
  final String imageURL;
  final String location;
  final String startDate;
  final String endDate;

  Event({required this.id, required this.name, required this.organizationName, required this.description, required this.imageURL, required this.location, required this.startDate, required this.endDate});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(id: json['id'], name: json['name'], organizationName: json['organizationName'], description: json['description'], imageURL: 'https://se-images.campuslabs.com/clink/images/${json['imagePath']}', location: json['location'], startDate: json['startsOn'], endDate: json['endsOn']);
  }
}
