import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/models/wallpaper_list.dart';

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

  Future<String?> getFavouritesFolderJsonPath(String folderName) async {
    try {
      final folderJson = localStorage.getItem("Favourites:$folderName")!;
      final tempDirectory = await getTemporaryDirectory();
      final file = File('${tempDirectory.path}/$folderName.json');
      file.writeAsString(folderJson);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> shareFavouriteFolder(String folderName) async {
    final isFolderEmpty = getFavouriteFolder(folderName).data.isEmpty;
    // Check if favourites folder is not empty
    if (isFolderEmpty) {
      return;
    }
    final filePath = await getFavouritesFolderJsonPath(folderName);
    // Check if file exists
    if (filePath != null) {
      Share.shareXFiles([XFile(filePath)], text: 'YAWA - $folderName');
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
