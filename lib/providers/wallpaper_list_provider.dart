import 'package:flutter/material.dart';
import '../models/models.dart';
import '../apis/api_client.dart';
import '../providers/source_provider.dart';

class WallpaperListProvider with ChangeNotifier {
  final List<Wallpaper> _wallpapers = [];
  final ApiClient _apiClient = ApiClient();
  Sources source = Sources.wallhaven;
  int? currentPage;
  int? lastPage;
  String? after;
  String? before;

  List<Wallpaper> get wallpapers {
    return [..._wallpapers];
  }

  int getLength() {
    return _wallpapers.length;
  }

  void emptyWallpaperList() {
    _wallpapers.clear();
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

          _wallpapers.addAll(wallpaperList.data);
          currentPage = wallpaperList
              .meta.currentPage; // Update currentPage to value from api
          lastPage =
              wallpaperList.meta.lastPage; // Update lastPage to value from api
          break;

        case Sources.reddit:
          // Check for last page on Reddit
          if (after == null && before != null) {
            return;
          }

          final wallpaperList = before == null && after == null
              ? await _apiClient.wallpaperSearch(source: source, query: query)
              : await _apiClient.wallpaperSearch(
                  source: source, query: query, pageId: after);

          before = after; // Update before to the last value of after
          _wallpapers.addAll(wallpaperList.data);
          after = wallpaperList
              .meta.after; // Update after to the value recieved from api
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
          _wallpapers.addAll(wallpaperList.data);
          currentPage = currentPage! + 1;

          after = wallpaperList
              .meta.after; // Update after to the value recieved from api
          break;

        default:
          throw Exception("Source Not supported yet");
      }
    } catch (e) {
      print("!!!Error: $e");
    }
  }
}
