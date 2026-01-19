import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:wallpaper_app/common/models/models.dart';

class HistoryStorageProvider with ChangeNotifier {
  static const _key = 'History';

  WallpaperList? fetchHistory() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return WallpaperList.fromJson(raw);
    } else {
      return null;
    }
  }

  void addWallpaperToHistory(Wallpaper wallpaper) {
    final raw = localStorage.getItem(_key);
    if (raw == null) {
      // Add new wallpaper list if none exists
      localStorage.setItem(
          _key, WallpaperList(data: [wallpaper], meta: Meta.empty).toJson());
    } else {
      // Add wallpaper to existing wallpaper list
      final prevList = WallpaperList.fromJson(raw);
      prevList.addWallpaper(wallpaper);
      localStorage.setItem(_key, prevList.toJson());
    }
  }

  void removeWallpaperFromHistory(Wallpaper wallpaper) {
    final raw = localStorage.getItem(_key);
    final prevList = WallpaperList.fromJson(raw!);
    prevList.removeWallpaper(wallpaper);
    localStorage.setItem(_key, prevList.toJson());
  }

  void emptyHistory() {
    localStorage.removeItem(_key);
  }
}
