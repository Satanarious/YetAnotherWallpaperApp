import 'package:flutter/material.dart';
import 'package:wallpaper_app/apis/api_client.dart';
import 'package:wallpaper_app/models/models.dart';
import 'package:wallpaper_app/providers/source_provider.dart';

class WallpaperListProvider with ChangeNotifier {
  // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
  final _wallpapers = WallpaperList(data: [], meta: Meta.empty);
  final ApiClient _apiClient = ApiClient();
  Sources source = Sources.reddit;

  int? offset;
  int? currentPage;
  int? lastPage;
  String? after;
  String? before;

  WallpaperList get wallpapers {
    return _wallpapers;
  }

  int getLength() {
    return _wallpapers.data.length;
  }

  void emptyWallpaperList() {
    _wallpapers.data.clear();
    offset = 0;
    currentPage = null;
    lastPage = null;
    before = null;
    after = null;
  }

  Future<void> loadMoreWallpapers({
    required Sources newSource,
    int? pageIndex,
    Map<String, dynamic>? query,
  }) async {
    //Reset Parameters on source change
    if (source != newSource) {
      emptyWallpaperList();
      source = newSource;
    }
    try {
      // Get Wallpaper from different Sources
      switch (source) {
        case Sources.wallhaven:

          // Check for last page on wallhaven
          if (currentPage != null && currentPage! + 1 > lastPage!) {
            notifyListeners();
            return;
          }

          final wallpaperList = currentPage == null
              ? await _apiClient.wallpaperSearch(source: source, query: query)
              : await _apiClient.wallpaperSearch(
                  source: source,
                  query: query,
                  pageIndex: (currentPage! + 1).toString());

          _wallpapers.data.addAll(wallpaperList.data);
          currentPage = wallpaperList
              .meta.currentPage; // Update currentPage to value from api
          lastPage =
              wallpaperList.meta.lastPage; // Update lastPage to value from api
          break;

        case Sources.reddit:
          // Check for last page on Reddit
          // do {
          // print("is less than 20 ---------------");
          // print(after);
          if (after == null && before != null) {
            return;
          }

          final wallpaperList = before == null && after == null
              ? await _apiClient.wallpaperSearch(source: source, query: query)
              : await _apiClient.wallpaperSearch(
                  source: source, query: query, pageId: after);

          if (after == null) {
            before = "NA"; // Set $before to non-null to avoid single page loop
          } else {
            before =
                after; // Otherwise, update $before to the last value of $after
          }
          _wallpapers.data.addAll(wallpaperList.data);
          after = wallpaperList
              .meta.after; // Update $after to the value recieved from api
          // } while (wallpapers.data.length < 20);
          break;

        case Sources.lemmy:
          // Check for last page on Lemmy
          if (after == null && currentPage != null) {
            return;
          }

          final wallpaperList = currentPage == null
              ? await _apiClient.wallpaperSearch(source: source, query: query)
              : await _apiClient.wallpaperSearch(
                  source: source,
                  query: query,
                  pageIndex: (currentPage! + 1).toString());
          currentPage = currentPage ?? 1;
          _wallpapers.data.addAll(wallpaperList.data);
          currentPage = currentPage! + 1;

          after = wallpaperList
              .meta.after; // Update after to the value recieved from api
          break;

        case Sources.deviantArt:
          final wallpaperList = offset == null
              ? await _apiClient.wallpaperSearch(
                  source: source,
                  query: query,
                )
              : await _apiClient.wallpaperSearch(
                  source: source,
                  query: query,
                  offset: offset.toString(),
                );

          _wallpapers.data.addAll(wallpaperList.data);
          offset = wallpaperList.meta.offset;

        default:
          throw Exception("Source Not supported yet");
      }
    } catch (e) {
      rethrow;
    }
  }
}
