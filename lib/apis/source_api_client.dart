import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/home/providers/deviant_art_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

class SourceApiClient {
  // Wallpaper Source Default Base URLs and Paths
  Map<String, dynamic> getHttpParams(Sources source) {
    switch (source) {
      case Sources.wallhaven:
        return {
          "baseUrl": "www.wallhaven.cc",
          "path": "/api/v1/search",
        };
      case Sources.reddit:
        return {
          "baseUrl": "www.reddit.com",
          "path": "/r/Verticalwallpapers/top.json",
        };
      case Sources.lemmy:
        return {
          "baseUrl": "lemmy.ml",
          "path": "/api/v3/post/list",
        };
      case Sources.deviantArt:
        return {
          "baseUrl": "www.deviantart.com",
          "path": "/api/v1/oauth2/browse/popular",
        };
      default:
        throw Exception("Source not supported yet!!");
    }
  }

  Future<WallpaperList> wallpaperSearch({
    required Sources source,
    Map<String, dynamic>? query,
    String? pageIndex,
    String? pageId,
    String? offset,
  }) async {
    final httpsParams = getHttpParams(source);
    String? deviantArtToken;

    // Nullify query in case where it is an empty map
    if (query != null && query.isEmpty) {
      query = null;
    }

    // Modify query and call other methods before calling wallpaper search
    switch (source) {
      case Sources.wallhaven:
        // Set page to default value or user provided value
        query!['page'] = pageIndex ?? "1";
        break;
      case Sources.reddit:
        if (pageId != null) {
          // Signifying last page
          query!['after'] = pageId;
        }
        httpsParams['path'] = "/r/${query!['subreddit']}/${query['sort']}.json";
        query.remove("subreddit");
        break;
      case Sources.lemmy:
        // Set page to default value or user provided value
        query!['page'] = pageIndex ?? "1";
        break;
      case Sources.deviantArt:
        deviantArtToken =
            await DeviantArtProvider().checkAndRefreshDeviantArtToken();

        if (offset != null) {
          // Signifying last page
          query!['offset'] = offset;
        }
        httpsParams['path'] = query!['path'];
        query.remove('path');
        break;
      default:
        throw Exception("Source not supported yet!!");
    }

    //Create Wallpaper API URI from baseURl, path and query
    final request = Uri.https(
      httpsParams['baseUrl'] as String,
      httpsParams['path'] as String,
      query,
    );

    final response = await http.get(request,
        headers: source == Sources.deviantArt
            ? {HttpHeaders.authorizationHeader: 'Bearer $deviantArtToken'}
            : null);

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

        return WallpaperList.fromWallhavenJson(
            wallpaperListJson,
            wallpaperListJson['meta'] == null
                ? Meta.empty
                : Meta.fromWallhavenJson(
                    wallpaperListJson['meta'] as Map<String, dynamic>));

      case Sources.reddit:
        if (!wallpaperListJson.containsKey('data')) {
          throw Exception(
            'Wallpaper not found. Please check your query.',
          );
        }

        final children = wallpaperListJson['data']['children'] as List;
        final validChildren = children
            .where((child) => (child['data']['post_hint'] == 'image' ||
                child['data']['post_hint'] == 'link'))
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
            .toList(); // Filter children where data has image
        wallpaperListJson['posts'] = validChildren;
        return WallpaperList.fromLemmyJson(
          wallpaperListJson,
          Meta.fromLemmyJson(wallpaperListJson),
        );

      case Sources.deviantArt:
        if (!wallpaperListJson.containsKey('results')) {
          throw Exception(
            'Wallpaper not found. Please check your query.',
          );
        }
        return WallpaperList.fromDeviantArtJson(
          wallpaperListJson,
          Meta.fromDeviantArtJson(wallpaperListJson),
        );

      default:
        throw Exception("Source not supported yet!!");
    }
  }
}
