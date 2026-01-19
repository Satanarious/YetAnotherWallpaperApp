import 'package:flutter/material.dart';
import 'package:wallpaper_app/common/models/models.dart';

class HistoryProvider with ChangeNotifier {
  final _history = WallpaperList.emptyList();

  WallpaperList get history {
    return _history;
  }

  set history(WallpaperList? list) {
    if (list != null) {
      _history.data.addAll(list.data.reversed);
    }
  }

  void clearAllHistory() {
    _history.data.clear();
    notifyListeners();
  }

  void fixLimit(int limit) {
    // Remove trailing history if the current length exceeds limit
    if (_history.data.length > limit) {
      _history.data.removeRange(limit, history.data.length);
    }
  }

  bool addToHistory(Wallpaper wallpaper, int limit) {
    fixLimit(limit);
    // Ignore if wallpaper already exists in history
    if (_history.data.contains(wallpaper)) return false;
    // Remove last wallpaper if wallpaper >=100
    if (_history.data.length >= limit) _history.data.removeLast();
    _history.data.insert(0, wallpaper);
    return true;
  }

  void removeFromHistory(Wallpaper wallpaper) {
    _history.removeWallpaper(wallpaper);
    notifyListeners();
  }
}
