import 'package:flutter/material.dart';
import '../models/models.dart';

class FavouritesProvider with ChangeNotifier {
  Map<String, WallpaperList> favouriteFolders = {};

  void createFolder(String folderName) {
    favouriteFolders = {
      ...favouriteFolders,
      folderName: WallpaperList(data: [], meta: Meta.empty),
    };
    notifyListeners();
  }

  void removeFolder(String folderName) {
    favouriteFolders.removeWhere((key, value) => key == folderName);
    notifyListeners();
  }
}
