class Organization {
  final String id;
  final String name;
  final String shortName;
  final String description;
  final String websiteKey;
  final String imageURL;

  Organization({required this.id, required this.name, required this.websiteKey, required this.shortName, required this.description, required this.imageURL});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(id: json['Id'], name: json['Name'], shortName: json['ShortName'] ?? '', description: json['Description'], websiteKey: json['WebsiteKey'], imageURL: json['ProfilePicture'] != null ? 'https://se-images.campuslabs.com/clink/images/${json['ProfilePicture']}' : '');
  }
}
