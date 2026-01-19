import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/queries/models/query.dart';
import 'package:wallpaper_app/settings/enums/enums.dart';

class SettingsProvider with ChangeNotifier {
  var defaultSource = Sources.reddit;
  var blurSketchy = true;
  var blurNsfw = true;
  var addToFavouritesOnDownload = false;
  var historyLimit = 100;
  var roundedCorners = false;
  var gridLayoutStyle = GridLayoutStyle.staggered;
  var columnSize = ColumnSizeType.adaptive;
  var columnWidth = 200.0;
  var columnNumber = 2;
  var cacheLimit = 1024.0;
  var wallhavenApiKey = '';
  var autoWallpaper = false;
  var dayNightMode = false;
  var wallpaperSource = AutoWallpaperSourceType.favourites;
  var wallpaperFavouritesFolder = FavouritesProvider.systemFolderName;
  var autoWallpaperInterval = 12;
  var dayChangeTime = const TimeOfDay(hour: 6, minute: 0);
  var nightChangeTime = const TimeOfDay(hour: 19, minute: 0);
  var dayModeFavouritesFolder = FavouritesProvider.systemFolderName;
  var dayModeQuery = Query(
    source: Sources.reddit,
    matureContent: false,
    communityName: 'Amoledbackgrounds',
    redditSortType: RedditSortType.top,
    redditSortRange: RedditSortRange.all,
  );
  var nightModeQuery = Query(
    source: Sources.reddit,
    matureContent: false,
    communityName: 'DailyWallpaper',
    redditSortType: RedditSortType.top,
    redditSortRange: RedditSortRange.all,
  );
  var nightModeFavouritesFolder = FavouritesProvider.systemFolderName;
  var constraints = [false, false, false, false];

  String toJson() {
    return jsonEncode({
      'defaultSource': defaultSource.index,
      'blurSketchy': blurSketchy,
      'blurNsfw': blurNsfw,
      'addToFavouritesOnDownload': addToFavouritesOnDownload,
      'historyLimit': historyLimit,
      'roundedCorners': roundedCorners,
      'gridLayoutStyle': gridLayoutStyle.index,
      'columnSize': columnSize.index,
      'columnWidth': columnWidth,
      'columnNumber': columnNumber,
      'cacheLimit': cacheLimit,
      'wallhavenApiKey': wallhavenApiKey,
      'autoWallpaper': autoWallpaper,
      'dayNightMode': dayNightMode,
      'wallpaperSource': wallpaperSource.index,
      'wallpaperFavouritesFolder': wallpaperFavouritesFolder,
      'autoWallpaperInterval': autoWallpaperInterval,
      'dayChangeTimeHours': dayChangeTime.hour,
      'dayChangeTimeMinutes': dayChangeTime.minute,
      'nightChangeTimeHours': nightChangeTime.hour,
      'nightChangeTimeMinutes': nightChangeTime.minute,
      'dayModeFavouritesFolder': dayModeFavouritesFolder,
      'dayModeQuery': dayModeQuery.toMap(),
      'nightModeQuery': nightModeQuery.toMap(),
      'nightModeFavouritesFolder': nightModeFavouritesFolder,
      'constraints': constraints,
    });
  }

  void fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return;

    defaultSource = Sources.values[json['defaultSource']];
    blurSketchy = json['blurSketchy'];
    blurNsfw = json['blurNsfw'];
    addToFavouritesOnDownload = json['addToFavouritesOnDownload'];
    historyLimit = json['historyLimit'];
    roundedCorners = json['roundedCorners'];
    gridLayoutStyle = GridLayoutStyle.values[json['gridLayoutStyle']];
    columnSize = ColumnSizeType.values[json['columnSize']];
    columnWidth = json['columnWidth'];
    columnNumber = json['columnNumber'];
    cacheLimit = json['cacheLimit'];
    wallhavenApiKey = json['wallhavenApiKey'];
    autoWallpaper = json['autoWallpaper'];
    dayNightMode = json['dayNightMode'];
    wallpaperSource = AutoWallpaperSourceType.values[json['wallpaperSource']];
    wallpaperFavouritesFolder = json['wallpaperFavouritesFolder'];
    autoWallpaperInterval = json['autoWallpaperInterval'];
    dayChangeTime = TimeOfDay(
      hour: json['dayChangeTimeHours'],
      minute: json['dayChangeTimeMinutes'],
    );
    nightChangeTime = TimeOfDay(
      hour: json['nightChangeTimeHours'],
      minute: json['nightChangeTimeMinutes'],
    );
    dayModeFavouritesFolder = json['dayModeFavouritesFolder'];
    dayModeQuery = Query.fromMap(json['dayModeQuery']);
    nightModeQuery = Query.fromMap(json['nightModeQuery']);
    nightModeFavouritesFolder = json['nightModeFavouritesFolder'];
    constraints = List<bool>.from(json['constraints']);
  }

  void changeDefaultSource(Sources source) {
    if (defaultSource != source) {
      defaultSource = source;
      notifyListeners();
    }
  }

  void changeBlurSketchy(bool value) {
    blurSketchy = value;
    notifyListeners();
  }

  void changeBlurNsfw(bool value) {
    blurNsfw = value;
    notifyListeners();
  }

  void changeAddToFavouritesOnDownload(bool value) {
    addToFavouritesOnDownload = value;
    notifyListeners();
  }

  void changeHistoryLimit(int value) {
    historyLimit = value;
  }

  void changeRoundedCorners(bool value) {
    roundedCorners = value;
    notifyListeners();
  }

  void changeGridLayoutStyle(GridLayoutStyle value) {
    gridLayoutStyle = value;
    notifyListeners();
  }

  void changeColumnSize(ColumnSizeType value) {
    columnSize = value;
    notifyListeners();
  }

  void changeColumnWidth(double value) {
    columnWidth = value;
    notifyListeners();
  }

  void changeColumnNumber(int value) {
    columnNumber = value;
    notifyListeners();
  }

  void changeCacheLimit(double value) {
    cacheLimit = value;
  }

  void changeWallhavenApiKey(String value) {
    wallhavenApiKey = value;
    notifyListeners();
  }

  void changeAutoWallpaper(bool value) {
    autoWallpaper = value;
    notifyListeners();
  }

  void changeDayNightMode(bool value) {
    dayNightMode = value;
    notifyListeners();
  }

  void changeWallpaperSource(AutoWallpaperSourceType value) {
    wallpaperSource = value;
    notifyListeners();
  }

  void changeWallpaperFavouritesFolder(String value) {
    wallpaperFavouritesFolder = value;
    notifyListeners();
  }

  void changeAutoWallpaperInterval(int value) {
    autoWallpaperInterval = value;
    notifyListeners();
  }

  void changeDayChangeTime(TimeOfDay value) {
    dayChangeTime = value;
    notifyListeners();
  }

  void changeNightChangeTime(TimeOfDay value) {
    nightChangeTime = value;
    notifyListeners();
  }

  void changeDayModeFavouritesFolder(String value) {
    dayModeFavouritesFolder = value;
    notifyListeners();
  }

  void changeDayModeQuery(Query value) {
    dayModeQuery = value;
    notifyListeners();
  }

  void changeNightModeQuery(Query value) {
    nightModeQuery = value;
    notifyListeners();
  }

  void changeNightModeFavouritesFolder(String value) {
    nightModeFavouritesFolder = value;
    notifyListeners();
  }

  void changeConstraints(List<bool> value) {
    constraints = value;
    notifyListeners();
  }
}
