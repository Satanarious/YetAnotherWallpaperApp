import 'package:flutter/material.dart';
import '../models/models.dart';

class FavouritesProvider with ChangeNotifier {
  final Map<String, WallpaperList> _favouriteFolders = {};
  // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
  final _allFavourites = WallpaperList(data: [], meta: Meta.empty);

  WallpaperList get allFavourites {
    return _allFavourites;
  }

  Map<String, WallpaperList> get favouriteFolders {
    return _favouriteFolders;
  }

  void addWallpaperToAllFolder(Wallpaper wallpaper) {
    _allFavourites.addWallpaper(wallpaper);
    notifyListeners();
  }

  bool removeWallpaperFromAllFolder(Wallpaper wallpaper) {
    if (foldersWhereWallpaperExists(wallpaper).isEmpty) {
      _allFavourites.removeWallpaper(wallpaper);
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  List foldersWhereWallpaperExists(Wallpaper wallpaper) {
    final folderList = [];
    for (var folderName in favouriteFolders.keys) {
      if (favouriteFolders[folderName]!.data.contains(wallpaper)) {
        folderList.add(folderName);
      }
    }
    return folderList;
  }

  bool manageFavouriteFolders(
    Wallpaper wallpaper,
    List initialSelection,
    List selectedFavouriteFolders,
  ) {
    final foldersNeedWallpaper = [];

    for (String folderName in selectedFavouriteFolders) {
      if (!initialSelection.contains(folderName)) {
        foldersNeedWallpaper.add(folderName);
      }
    }
    // Add wallpaper to 'System | All' folder
    if (foldersNeedWallpaper.isNotEmpty &&
        initialSelection.isEmpty &&
        !_allFavourites.data.contains(wallpaper)) {
      _allFavourites.addWallpaper(wallpaper);
    }
    // Add wallpaper to favourites folders
    for (var folderName in favouriteFolders.keys) {
      if (foldersNeedWallpaper.contains(folderName)) {
        _favouriteFolders[folderName]!.addWallpaper(wallpaper);
      }
      // Remove wallpaper from favourites folders
      else if (initialSelection.contains(folderName) &&
          !foldersNeedWallpaper.contains(folderName)) {
        _favouriteFolders[folderName]!.removeWallpaper(wallpaper);
      }
    }
    notifyListeners();
    // Remove wallpaper from 'System | All' folder
    if (selectedFavouriteFolders.isEmpty) {
      _allFavourites.removeWallpaper(wallpaper);
      return false;
    } else {
      return true;
    }
  }

  void createFolder(String folderName) {
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    _favouriteFolders[folderName] = WallpaperList(data: [], meta: Meta.empty);
    notifyListeners();
  }

  void removeFolder(String folderName) {
    _favouriteFolders.remove(folderName);
    notifyListeners();
  }
}
