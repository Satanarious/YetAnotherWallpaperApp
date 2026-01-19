import 'dart:convert';

import 'package:html/parser.dart' as htmlparser;
import 'package:http/http.dart' as http;

class WallhavenProvider {
  static Future<List<Map<String, String>>> getPopularTags() async {
    final List<Map<String, String>> popularTags = [];
    final tagsURI = Uri.https(
      "wallhaven.cc",
      "/tags/popular",
    );
    final response = await http.get(tagsURI);
    if (response.statusCode != 200) {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }
    final document = htmlparser.parse(response.body);
    for (var tag in document.getElementsByClassName("taglist-name")) {
      final tagName = tag.text;
      final tagId = tag.innerHtml.split("tag/").last.split("\" title").first;
      popularTags.add({
        "name": "#$tagName",
        "id": tagId,
      });
    }
    return popularTags;
  }

  static Future<List<String>> getTags(String id) async {
    final tagURI = Uri.https(
      "wallhaven.cc",
      "/api/v1/w/$id",
    );
    final response = await http.get(tagURI);
    if (response.statusCode != 200) {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }
    final tags = ((jsonDecode(response.body) as Map<String, dynamic>)['data']
            ['tags'] as List)
        .map((tagMap) => tagMap['name'] as String)
        .toList();
    return tags;
  }
}
