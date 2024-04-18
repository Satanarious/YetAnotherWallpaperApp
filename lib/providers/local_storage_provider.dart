import 'package:flutter/material.dart';

class LocalStorageProvider with ChangeNotifier {
  Future<void> addFavouriteWallpaper() {
    // TODO: Implement saving new wallpaper to favourite folder
    return Future(() => null);
  }

  Future<void> removeFavouriteWallpaper() {
    // TODO: Implement removing wallpaper from favourite
    return Future(() => null);
  }

  Future<void> removeFavouriteFolder() {
    // TODO: Implement removing favourites folder
    return Future(() => null);
  }

  Future<void> addWallpaperToHistory(wallpaperAsJson) {
    // TODO: Implement saving new wallpaper to history
    return Future(() => null);
  }

  Future<void> removeWallpaperFromHistory() {
    // TODO: Implement removing wallpaper from history
    return Future(() => null);
  }

  Future<void> emptyHistory() {
    // TODO: Implement emptying history
    return Future(() => null);
  }
}
