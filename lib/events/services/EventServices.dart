import 'package:http/http.dart' as http;

class EventService {
  static const baseUrl = 'https://pin.gsu.edu/api/discovery/event';

  static Future<String> getEvents(int buffer) async {
    final url = Uri.parse('$baseUrl/search').replace(queryParameters: {
      'take': '15'
    });

    print(url);

    final response = await http.get(
      url,
    );

    return response.body;
  }
}
