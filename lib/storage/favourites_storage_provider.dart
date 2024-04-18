import 'package:flutter/material.dart';

class FavouritesStorageProvider with ChangeNotifier {
  Future<void> fetchFavourites() {
    // TODO: Implement fetching all favourites at the beginning
    return Future(() => null);
  }

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
}
