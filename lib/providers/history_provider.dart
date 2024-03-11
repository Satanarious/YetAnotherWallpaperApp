import 'package:flutter/material.dart';
import 'package:wallpaper_app/models/models.dart';

class HistoryProvider with ChangeNotifier {
  // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
  final _history = WallpaperList(data: [], meta: Meta.empty);

  WallpaperList get history {
    return _history;
  }

  void clearAllHistory() {
    _history.data.clear();
    notifyListeners();
  }

  void addToHistory(Wallpaper wallpaper) {
    // Ignore if wallpaper already exists in history
    if (_history.data.contains(wallpaper)) return;
    // Remove last wallpaper if wallpaper >=100
    if (_history.data.length >= 100) _history.data.removeLast();
    _history.data.insert(0, wallpaper);
  }

  void removeFromHistory(Wallpaper wallpaper) {
    _history.removeWallpaper(wallpaper);
    notifyListeners();
  }
}
