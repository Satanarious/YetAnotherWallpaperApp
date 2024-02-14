import 'dart:convert';
import '../models/models.dart';
import '../providers/source_provider.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Map<String, dynamic> getHttpParams(Sources source) {
    switch (source) {
      case Sources.wallhaven:
        return {
          "baseUrl": "www.wallhaven.cc",
          "path": "/api/v1/search",
          "defaultQuery": {
            "sorting": "toplist",
            "page": "1",
          },
        };
      case Sources.reddit:
        return {
          "baseUrl": "www.reddit.com",
          "path": "/r/Verticalwallpapers/top.json",
          "defaultQuery": {
            "sort": "top",
            "t": "month",
          },
        };
      case Sources.lemmy:
        return {
          "baseUrl": "lemmy.ml",
          "path": "/api/v3/post/list",
          "defaultQuery": {
            "community_name": "apocalypticart@feddit.de",
            "sort": "Active"
          },
        };
      case Sources.oWalls:
        return {
          "baseUrl": "www.lemmy.com",
          "path": "",
          "defaultQuery": "",
        };
      case Sources.googlePixel:
        return {
          "baseUrl": "www.pixel.com",
          "path": "",
          "defaultQuery": "",
        };
      case Sources.bingDaily:
        return {
          "baseUrl": "www.bing.com",
          "path": "",
          "defaultQuery": "",
        };
    }
  }

  Future<WallpaperList> wallpaperSearch({
    required Sources source,
    Map<String, dynamic>? query,
    String? pageIndex,
    String? pageId,
  }) async {
    final httpsParams = getHttpParams(source);

    switch (source) {
      case Sources.wallhaven:
        query!['page'] = pageIndex ?? "1";
        break;
      case Sources.reddit:
        httpsParams['defaultQuery']['after'] = pageId ?? "";
      case Sources.lemmy:
        httpsParams['defaultQuery']['page'] = pageIndex ?? "1";
        break;
      case Sources.googlePixel:
        break;
      case Sources.bingDaily:
        break;
      case Sources.oWalls:
        break;
    }

    //Create URI
    final request = Uri.https(
      httpsParams['baseUrl'] as String,
      httpsParams['path'] as String,
      query ?? httpsParams['defaultQuery'],
    );
    final response = await http.get(request);

    if (response.statusCode != 200) {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }

    //Convert Raw data to JSON
    final wallpaperListJson = jsonDecode(response.body) as Map<String, dynamic>;

    // Call respective methods from WallpaperList
    switch (source) {
      case Sources.wallhaven:
        if (!wallpaperListJson.containsKey('data')) {
          throw Exception(
            'Wallpaper not found. Please check your query.',
          );
        }

        return WallpaperList.fromWallhavenJson(wallpaperListJson);

      case Sources.reddit:
        if (!wallpaperListJson.containsKey('data')) {
          throw Exception(
            'Wallpaper not found. Please check your query.',
          );
        }

        final children = wallpaperListJson['data']['children'] as List;
        final validChildren = children
            .where((child) => child['data']['post_hint'] == 'image')
            .toList();
        wallpaperListJson['data']['children'] = validChildren;

        return WallpaperList.fromRedditJson(
          wallpaperListJson,
          Meta.fromRedditJson(wallpaperListJson['data']),
        );

      case Sources.lemmy:
        if (!wallpaperListJson.containsKey('posts')) {
          throw Exception(
            'Wallpaper not found. Please check your query.',
          );
        }

        final children = wallpaperListJson['posts'] as List;
        final validChildren = children
            .where((child) => child['post']['thumbnail_url'] != null)
            .toList();
        wallpaperListJson['posts'] = validChildren;
        return WallpaperList.fromLemmyJson(
          wallpaperListJson,
          Meta.fromLemmyJson(wallpaperListJson),
        );

      case Sources.googlePixel:
        return WallpaperList.fromWallhavenJson(wallpaperListJson);
      case Sources.bingDaily:
        return WallpaperList.fromWallhavenJson(wallpaperListJson);
      case Sources.oWalls:
        return WallpaperList.fromWallhavenJson(wallpaperListJson);
    }
  }
}
