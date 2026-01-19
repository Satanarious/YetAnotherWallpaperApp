import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/common/models/wallpaper_list.dart';
import 'package:wallpaper_app/favourites/dialogs/add_folder_dialog.dart';
import 'package:wallpaper_app/favourites/dialogs/rename_import_dialog.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/screens/favourite_wallpaper_grid_screen.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/favourites/widgets/folder_grid_image_preview.dart';
import 'package:wallpaper_app/favourites/widgets/folder_image_preview.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});
  static const String routeName = "/FavouritesScreen";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favouriteFolders = favouritesProvider.favouriteFolders;
    final Iterable<String> favouritefolderTitles = favouriteFolders.keys;
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width ~/ 200;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              title: const Text(
                "Favourites",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  tooltip: "Import Folder",
                  icon: const Icon(
                    IconlyLight.upload,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final files = await FilePicker.platform.pickFiles();
                    if (files != null && files.files.isNotEmpty) {
                      final file = files.files.first;
                      if (file.extension == "json") {
                        if (context.mounted) {
                          final favouritesStorageProvider =
                              Provider.of<FavouritesStorageProvider>(context,
                                  listen: false);

                          List<dynamic> result =
                              favouritesStorageProvider.importFavouritesFolder(
                            filePath: file.path!,
                          );
                          if (result.first == false &&
                              result.last == "Rename!") {
                            result = await AnimatedPopInDialog.showGeneral(
                                context, RenameImportDialog(file.path!));
                          }

                          // result is [folderCreated,message,renamedFolderName]
                          // where result[0] is bool, result[1] is String and result[2] is String?

                          if (result.first &&
                              result[1] == "Successfully renamed!") {
                            favouritesProvider.importFavouritesFolder(
                              filePath: file.path!,
                              favouritesStorageProvider:
                                  favouritesStorageProvider,
                              renamedFolderName: result.last,
                            );
                          } else if (result.first) {
                            favouritesProvider.importFavouritesFolder(
                              filePath: file.path!,
                              favouritesStorageProvider:
                                  favouritesStorageProvider,
                            );
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result[1])));
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid file type!")));
                        }
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No file selected!")));
                      }
                    }
                  },
                )
              ],
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withAlpha(50),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => AnimatedPopInDialog.showGeneral(
                      context, const AddFolderDialog()),
                ),
              ),
            ),
          ),
        ],
      ),
      body: favouriteFolders.isEmpty &&
              favouritesProvider.allFavourites.data.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/empty.gif",
                    height: 200,
                    width: 300,
                    fit: BoxFit.fitWidth,
                  ),
                  const Text(
                    "Add Folders to see them here.",
                    style: TextStyle(color: Colors.white54, fontSize: 20),
                  ),
                ],
              ),
            )
          : GridView.count(
              mainAxisSpacing: 10,
              crossAxisCount: crossAxisCount,
              children: [
                    FavouriteFolderWidget(
                      crossAxisCount: crossAxisCount,
                      wallpapersList: favouritesProvider.allFavourites,
                      folderTitle: "System | All",
                      isGrid: true,
                    ),
                  ] +
                  favouritefolderTitles
                      .map((folderTitle) => FavouriteFolderWidget(
                            crossAxisCount: crossAxisCount,
                            wallpapersList: favouriteFolders[folderTitle]!,
                            folderTitle: folderTitle,
                            isGrid: false,
                          ))
                      .toList(),
            ),
    );
  }
}

class FavouriteFolderWidget extends StatefulWidget {
  const FavouriteFolderWidget({
    super.key,
    required this.crossAxisCount,
    required this.wallpapersList,
    required this.folderTitle,
    required this.isGrid,
  });

  final int crossAxisCount;
  final WallpaperList wallpapersList;
  final String folderTitle;
  final bool isGrid;

  @override
  State<FavouriteFolderWidget> createState() => _FavouriteFolderWidgetState();
}

class _FavouriteFolderWidgetState extends State<FavouriteFolderWidget> {
  bool showFolderOptions = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
          FavouriteWallpaperGridScreen.routeName,
          arguments: widget.folderTitle),
      child: SizedBox(
        height: size.width / widget.crossAxisCount,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (size.width / widget.crossAxisCount) - 45,
                child: widget.isGrid
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FolderGridImagePreview(
                                wallpaper: widget.wallpapersList.data.isNotEmpty
                                    ? widget.wallpapersList.data[0]
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              FolderGridImagePreview(
                                wallpaper: widget.wallpapersList.data.length > 1
                                    ? widget.wallpapersList.data[1]
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FolderGridImagePreview(
                                wallpaper: widget.wallpapersList.data.length > 2
                                    ? widget.wallpapersList.data[2]
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              FolderGridImagePreview(
                                wallpaper: widget.wallpapersList.data.length > 3
                                    ? widget.wallpapersList.data[3]
                                    : null,
                              ),
                            ],
                          )
                        ],
                      )
                    : Stack(
                        children: [
                          FolderImagePreview(
                            top: 0,
                            right: constraints.maxWidth / 4,
                            wallpaper: widget.wallpapersList.data.length > 2
                                ? widget.wallpapersList.data[2]
                                : null,
                          ),
                          FolderImagePreview(
                            top: 15,
                            right: (constraints.maxWidth / 4) - 15,
                            wallpaper: widget.wallpapersList.data.length > 1
                                ? widget.wallpapersList.data[1]
                                : null,
                          ),
                          FolderImagePreview(
                            top: 30,
                            right: (constraints.maxWidth / 4) - 30,
                            wallpaper: widget.wallpapersList.data.isEmpty
                                ? null
                                : widget.wallpapersList.data[0],
                          ),
                        ],
                      ),
              ),
              Text(
                widget.folderTitle,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
