import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';

class FavouritesProvider with ChangeNotifier {
  final Map<String, WallpaperList> favouriteFolders = {};
  final allFavourites = WallpaperList.emptyList();
  static const systemFolderName = "System | All";

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
          FavouritesProvider.systemFolderName, allFavourites);
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
          FavouritesProvider.systemFolderName, allFavourites);
      return false;
    } else {
      return true;
    }
  }

  void importFavouritesFolder({
    required String filePath,
    required FavouritesStorageProvider favouritesStorageProvider,
    String? renamedFolderName,
  }) {
    final file = File(filePath);
    if (file.existsSync()) {
      final folderName = renamedFolderName ??
          file.path.split("/").last.split(".").first.substring(5);
      favouriteFolders[folderName] =
          WallpaperList.fromJson(file.readAsStringSync());
      for (var wallpaper in favouriteFolders[folderName]!.data) {
        if (!allFavourites.data.contains(wallpaper)) {
          allFavourites.addWallpaper(wallpaper);
        }
      }
      favouritesStorageProvider.updateFavouritesFolder(
          FavouritesProvider.systemFolderName, allFavourites);
      notifyListeners();
    }
  }

  void createFolder(String folderName) {
    favouriteFolders[folderName] = WallpaperList.emptyList();
    notifyListeners();
  }

  void removeFolder(
      String folderName, FavouritesStorageProvider favouritesStorageProvider) {
    bool existsInMultipleFavouritesFolder = false;
    // Check if wallpaper exists in multiple favourites folders
    // and remove if not, from allFavourites
    for (var wallpaper
        in (favouriteFolders[folderName] as WallpaperList).data) {
      existsInMultipleFavouritesFolder = false;
      for (var folder in favouriteFolders.keys) {
        if (folder != folderName &&
            favouriteFolders[folder]!.data.contains(wallpaper)) {
          existsInMultipleFavouritesFolder = true;
          break;
        }
      }
      if (!existsInMultipleFavouritesFolder) {
        allFavourites.data.remove(wallpaper);
        favouritesStorageProvider.updateFavouritesFolder(
            FavouritesProvider.systemFolderName, allFavourites);
      }
    }
    // Finally remove the folder
    favouriteFolders.remove(folderName);
    notifyListeners();
  }
}
