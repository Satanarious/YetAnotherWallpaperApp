import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:wallpaper_app/common/models/wallpaper_list.dart';

class FavouritesStorageProvider with ChangeNotifier {
  static const _key = "favourites";
  List fetchFavourites() {
    final favourites = [];
    try {
      final folderList = jsonDecode(localStorage.getItem(_key)!) as List;
      for (String folder in folderList) {
        favourites.add({
          "name": folder,
          "list": getFavouriteFolder(folder),
        });
      }
      return favourites;
    } catch (e) {
      localStorage.setItem(_key, jsonEncode([]));
      return [];
    }
  }

  List<dynamic> importFavouritesFolder({
    required String filePath,
    String? renamedFolderName,
  }) {
    final file = File(filePath);
    if (file.existsSync()) {
      final folderName = renamedFolderName ??
          file.path.split("/").last.split(".").first.substring(5);
      // Check if folder already exists
      final favouriteFolders = jsonDecode(localStorage.getItem(_key)!) as List;
      if (favouriteFolders.contains(folderName)) {
        return [false, "Rename!"];
      }
      localStorage.setItem("Favourites:$folderName", file.readAsStringSync());
      final folderList = jsonDecode(localStorage.getItem(_key)!) as List;
      folderList.add(folderName);
      localStorage.setItem(_key, jsonEncode(folderList));
      return [true, "Successfully imported!"];
    } else {
      return [false, "File doesn't exist!"];
    }
  }

  WallpaperList getFavouriteFolder(String folderName) {
    try {
      return WallpaperList.fromJson(
          localStorage.getItem("Favourites:$folderName")!);
    } catch (e) {
      return WallpaperList.emptyList();
    }
  }

  void addFavouritesFolder(String folderName) {
    localStorage.setItem("Favourites:$folderName", jsonEncode([]));
    final folderList = jsonDecode(localStorage.getItem(_key)!) as List;
    folderList.add(folderName);
    localStorage.setItem(_key, jsonEncode(folderList));
  }

  void renameFavouritesFolder(String originalFolderName, String newFolderName) {
    addFavouritesFolder(newFolderName);
    removeFavouriteFolder(originalFolderName);
  }

  void removeFavouriteFolder(String folderName) {
    localStorage.removeItem("Favourites:$folderName");
    final folderList = jsonDecode(localStorage.getItem(_key)!) as List;
    folderList.remove(folderName);
    localStorage.setItem(_key, jsonEncode(folderList));
  }

  void updateFavouritesFolder(String folderName, WallpaperList wallpaperList) {
    localStorage.setItem("Favourites:$folderName", wallpaperList.toJson());
  }
}
