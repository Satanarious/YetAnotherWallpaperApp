import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DeviantArtProvider {
  String? _deviantArtToken;
  DateTime? _deviantArtTokenExpiry;
  List<Map<String, String>>? _deviantArtTopTopics;
  final List<Map<String, String>> _deviantArtAllTopics = [];
  // Deviant Art Singleton
  static final _singleton = DeviantArtProvider._internal();

  factory DeviantArtProvider() {
    return _singleton;
  }
  DeviantArtProvider._internal();

  Future<List<String>> getDeviationTags(String id) async {
    final tagURI = Uri.https(
      "www.deviantart.com",
      "/api/v1/oauth2/deviation/metadata",
      {'deviationids': id},
    );
    final token = await checkAndRefreshDeviantArtToken();
    final response = await http.get(tagURI,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode != 200) {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }
    final tags = ((jsonDecode(response.body)
            as Map<String, dynamic>)['metadata'][0]['tags'] as List)
        .map((tag) => tag['tag_name'] as String)
        .toList();
    return tags;
  }

  Future<List<Map<String, String>>> getDeviantArtSeachTags(String tag) async {
    final tagURI = Uri.https(
      "www.deviantart.com",
      "/api/v1/oauth2/browse/tags/search",
      {'tag_name': tag},
    );
    final token = await checkAndRefreshDeviantArtToken();
    final response = await http.get(tagURI,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode != 200) {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }
    final tags =
        ((jsonDecode(response.body) as Map<String, dynamic>)['results'] as List)
            .map((tagMap) => {
                  'name': "#${tagMap['tag_name']}",
                  'value': tagMap['tag_name'] as String,
                })
            .toList();
    return tags;
  }

  Future<List<Map<String, String>>> get deviantArtTopTopics async {
    // Case where topics already exist
    if (_deviantArtTopTopics != null) return [..._deviantArtTopTopics!];

    final topicURI =
        Uri.https("www.deviantart.com", "/api/v1/oauth2/browse/toptopics");
    final token = await checkAndRefreshDeviantArtToken();
    final response = await http.get(topicURI,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode != 200) {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }
    final topics =
        ((jsonDecode(response.body) as Map<String, dynamic>)['results'] as List)
            .map((topicMap) => {
                  'name': topicMap['name'] as String,
                  'value': topicMap['canonical_name'] as String,
                })
            .toList();
    _deviantArtTopTopics = topics;
    return topics;
  }

  Future<List<Map<String, String>>> get deviantArtAllTopics async {
    // Case where topics already exist
    if (_deviantArtAllTopics.isNotEmpty) return _deviantArtAllTopics;

    var hasMore = true;
    String? offset;

    while (hasMore) {
      final topicURI = Uri.https(
        "www.deviantart.com",
        "/api/v1/oauth2/browse/topics",
        {'offset': offset},
      );
      final token = await checkAndRefreshDeviantArtToken();
      final response = await http.get(topicURI,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status: ${response.statusCode}',
        );
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final topics = (data['results'] as List).map((topicMap) {
        final url =
            (topicMap['example_deviations'][0]['thumbs'] as List).last['src'];
        final topic = {
          'name': topicMap['name'] as String,
          'value': topicMap['canonical_name'] as String,
          'description': '',
          'url': url as String,
        };
        return topic;
      }).toList();
      _deviantArtAllTopics.addAll(topics);
      offset = data['next_offset'].toString();
      hasMore = data['has_more'];
    }

    return _deviantArtAllTopics;
  }

  Future<String> checkAndRefreshDeviantArtToken() async {
    // Check if token is not valid
    if (_deviantArtTokenExpiry == null ||
        _deviantArtTokenExpiry!.isBefore(DateTime.now())) {
      final authURI = Uri.https("www.deviantart.com", "/oauth2/token", {
        "grant_type": "client_credentials",
        "client_id": const String.fromEnvironment('deviantart_client_id'),
        "client_secret":
            const String.fromEnvironment('deviantart_client_secret'),
      });

      // Get new token
      final authResponse = await http.get(authURI);
      if (authResponse.statusCode != 200) {
        throw Exception(
          'Request failed with status: ${authResponse.statusCode}',
        );
      }
      final newToken = (jsonDecode(authResponse.body)
          as Map<String, dynamic>)['access_token'] as String;
      _deviantArtToken = newToken;
      // Update token expiry time
      _deviantArtTokenExpiry = DateTime.now().add(const Duration(hours: 1));
      return newToken;
    } else {
      return _deviantArtToken!;
    }
  }
}
