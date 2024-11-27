import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';

class FavouritesProvider with ChangeNotifier {
  final Map<String, WallpaperList> favouriteFolders = {};
  final allFavourites = WallpaperList.emptyList();

  void removeWallpaperFromFolder(String folderName, Wallpaper wallpaper) {
    favouriteFolders[folderName]!.removeWallpaper(wallpaper);
    notifyListeners();
  }

  void addWallpaperToAllFolder(Wallpaper wallpaper) {
    allFavourites.addWallpaper(wallpaper);
    notifyListeners();
  }

  bool removeWallpaperFromAllFolder(Wallpaper wallpaper) {
    final folders = foldersWhereWallpaperExists(wallpaper);
    if (folders.length < 2) {
      allFavourites.removeWallpaper(wallpaper);
      if (folders.isNotEmpty) {
        favouriteFolders[folders[0] as String]!.removeWallpaper(wallpaper);
      }
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
    FavouritesStorageProvider favouritesStorageProvider,
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
        !allFavourites.data.contains(wallpaper)) {
      addWallpaperToAllFolder(wallpaper);
      favouritesStorageProvider.updateFavouritesFolder(
          "System | All", allFavourites);
    }

    for (var folderName in favouriteFolders.keys) {
      // Add wallpaper to favourites folders
      if (foldersNeedWallpaper.contains(folderName)) {
        favouriteFolders[folderName]!.addWallpaper(wallpaper);
        favouritesStorageProvider.updateFavouritesFolder(
            folderName, favouriteFolders[folderName]!);
      }
      // Remove wallpaper from favourites folders
      else if (initialSelection.contains(folderName) &&
          !selectedFavouriteFolders.contains(folderName)) {
        removeWallpaperFromFolder(folderName, wallpaper);
        favouritesStorageProvider.updateFavouritesFolder(
            folderName, favouriteFolders[folderName]!);
      }
    }
    notifyListeners();
    // Remove wallpaper from 'System | All' folder
    if (selectedFavouriteFolders.isEmpty) {
      allFavourites.removeWallpaper(wallpaper);
      favouritesStorageProvider.updateFavouritesFolder(
          "System | All", allFavourites);
      return false;
    } else {
      return true;
    }
  }

  void importFavouritesFolder(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      final folderName = file.path.split("/").last.split(".").first;
      favouriteFolders[folderName] =
          WallpaperList.fromJson(file.readAsStringSync());
      notifyListeners();
    }
  }

  void createFolder(String folderName) {
    favouriteFolders[folderName] = WallpaperList.emptyList();
    notifyListeners();
  }

  void removeFolder(String folderName) {
    favouriteFolders.remove(folderName);
    notifyListeners();
  }
}
