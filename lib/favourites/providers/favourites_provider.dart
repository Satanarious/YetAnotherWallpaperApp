import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:wallpaper_app/common/enums/file_type.dart' as ft;
import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

class FavouritesProvider with ChangeNotifier {
  final Map<String, WallpaperList> favouriteFolders = {};
  final allFavourites = WallpaperList.emptyList();
  static const systemFolderName = "System | All";
  var notifyFavouritesListener = true;

  void removeWallpaperFromFolder(String folderName, Wallpaper wallpaper) {
    if (folderName == systemFolderName) return;
    favouriteFolders[folderName]!.removeWallpaper(wallpaper);
    notifyListeners();
  }

  void addWallpaperToAllFolder(Wallpaper wallpaper) {
    allFavourites.addWallpaper(wallpaper);
    notifyListeners();
  }

  bool removeWallpaperFromAllFolder(Wallpaper wallpaper,
      FavouritesStorageProvider favouritesStorageProvider) {
    final folders = foldersWhereWallpaperExists(wallpaper);
    if (folders.length < 2) {
      allFavourites.removeWallpaper(wallpaper);
      favouritesStorageProvider.updateFavouritesFolder(
          "System | All", allFavourites);
      if (folders.isNotEmpty) {
        final folderName = folders[0] as String;
        favouriteFolders[folderName]!.removeWallpaper(wallpaper);
        favouritesStorageProvider.updateFavouritesFolder(
            folderName, favouriteFolders[folderName]!);
      }
      if (notifyFavouritesListener) {
        notifyListeners();
      }
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

  Future<bool> addLocalWallpapers({
    required BuildContext context,
    required bool isSystemFolder,
    required FavouritesStorageProvider favouritesStorageProvider,
    required String title,
  }) async {
    final pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'gif'],
    );
    if (pickedFiles != null && pickedFiles.files.isNotEmpty) {
      final downloadsDirectory = await getDownloadsDirectory();
      if (downloadsDirectory == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to add to Favourites!"),
          ));
        }
        return false;
      }

      for (final pickedFile in pickedFiles.files) {
        final file = File(pickedFile.path!);
        final newCopiedFile = await file
            .copy("${downloadsDirectory.path}/${file.path.split("/").last}");
        // Create a new local wallpaper
        final newLocalWallpaper = Wallpaper(
          id: const Uuid().v4(),
          title: file.path.split("/").last.split(".").first,
          source: Sources.local,
          url: '',
          purity: PurityType.general,
          fileSize: 0,
          localPath: newCopiedFile.path,
          fileType:
              ft.File.fromString("image/${pickedFile.path!.split(".").last}"),
          thumbs: Thumbs.empty,
        );

        // Add the new local wallpaper to the favourites
        addWallpaperToAllFolder(newLocalWallpaper);
        if (!isSystemFolder) {
          favouriteFolders[title]!.addWallpaper(newLocalWallpaper);
        }
      }

      // Update favourites storage provider with new local Wallpapers
      favouritesStorageProvider.updateFavouritesFolder(
          systemFolderName, allFavourites);
      if (!isSystemFolder) {
        favouritesStorageProvider.updateFavouritesFolder(
            title, favouriteFolders[title]!);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Added to Favourites!"),
        ));
        return true;
      }
    }
    return false;
  }

  Future<void> importFavouritesFolder({
    required String filePath,
    required FavouritesStorageProvider favouritesStorageProvider,
    String? renamedFolderName,
  }) async {
    final file = File(filePath);
    if (file.existsSync()) {
      final folderName = renamedFolderName ??
          file.path.split("/").last.split(".").first.substring(5);
      favouriteFolders[folderName] =
          WallpaperList.fromJson(file.readAsStringSync());

      // Add to favourites
      for (var wallpaper in favouriteFolders[folderName]!.data) {
        if (!allFavourites.data.contains(wallpaper)) {
          allFavourites.addWallpaper(wallpaper);
        }
      }
      favouritesStorageProvider.updateFavouritesFolder(
          FavouritesProvider.systemFolderName, allFavourites);
      if (notifyFavouritesListener) {
        notifyListeners();
      }
    }
  }

  Future<File?> getFavouritesFolderJsonPath(String folderName) async {
    try {
      final exportWallpaperList = WallpaperList.emptyList();
      for (var wallpaper in favouriteFolders[folderName]!.data) {
        if (wallpaper.source != Sources.local) {
          exportWallpaperList.addWallpaper(wallpaper);
        }
      }
      final tempDirectory = await getTemporaryDirectory();
      final file = File('${tempDirectory.path}/$folderName.json');
      file.writeAsString(exportWallpaperList.toJson());
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> shareFavouriteFolder(String folderName) async {
    final isFolderEmpty = favouriteFolders[folderName]!.data.isEmpty;
    // Check if favourites folder is not empty
    if (isFolderEmpty) {
      return;
    }
    final jsonFile = await getFavouritesFolderJsonPath(folderName);
    // Check if file exists
    if (jsonFile != null) {
      SharePlus.instance.share(
        ShareParams(
            files: [XFile(jsonFile.path)],
            fileNameOverrides: ['YAWA-$folderName']),
      );
    }
  }

  Future<bool> saveFavouritesFolderJson(String folderName) async {
    try {
      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        final downloadsDirectory = Directory('/storage/emulated/0/Download');
        final jsonFile = await getFavouritesFolderJsonPath(folderName);
        if (jsonFile != null) {
          await jsonFile
              .copy("${downloadsDirectory.path}/YAWA-$folderName.json");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void renameFavouritesFolder(String originalFolderName, String newFolderName,
      FavouritesStorageProvider favouritesStorageProvider) {
    favouriteFolders[newFolderName] = favouriteFolders[originalFolderName]!;
    favouriteFolders.remove(originalFolderName);
    favouritesStorageProvider.updateFavouritesFolder(
        newFolderName, favouriteFolders[newFolderName]!);
    notifyListeners();
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

  void shouldNotifyListener(bool value) {
    notifyFavouritesListener = value;
  }
}
