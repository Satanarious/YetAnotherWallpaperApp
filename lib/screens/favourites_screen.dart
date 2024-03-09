import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/add_folder_dialog.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/screens/favourite_wallpaper_grid_screen.dart';

import '../models/wallpaper_list.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});
  static const String routeName = "/FavouritesScreen";

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favouriteFolders = favouritesProvider.favouriteFolders;
    final Iterable<String> favouritefolderTitles = favouriteFolders.keys;
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width ~/ 200;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      appBar: AppBar(
        title: const Text(
          "Favourites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context, builder: (context) => const AddFolderDialog()),
        child: const Icon(Icons.add),
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
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisCount: crossAxisCount,
                children: [
                      FavouriteFolderWidget(
                        crossAxisCount: crossAxisCount,
                        wallpapersList: favouritesProvider.allFavourites,
                        folderTitle: "System | All",
                      ),
                    ] +
                    favouritefolderTitles
                        .map((folderTitle) => FavouriteFolderWidget(
                              crossAxisCount: crossAxisCount,
                              wallpapersList: favouriteFolders[folderTitle]!,
                              folderTitle: folderTitle,
                            ))
                        .toList(),
              ),
            ),
    );
  }
}

class FavouriteFolderWidget extends StatelessWidget {
  const FavouriteFolderWidget({
    super.key,
    required this.crossAxisCount,
    required this.wallpapersList,
    required this.folderTitle,
  });

  final int crossAxisCount;
  final WallpaperList wallpapersList;
  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
          FavouriteWallpaperGridScreen.routeName,
          arguments: folderTitle),
      child: SizedBox(
        height: size.width / crossAxisCount,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (size.width / crossAxisCount) - 45,
                child: Stack(
                  children: [
                    FolderImagePreview(
                      top: 0,
                      right: constraints.maxWidth / 4,
                      url: wallpapersList.data.length > 2
                          ? wallpapersList.data[2].thumbs.large
                          : null,
                    ),
                    FolderImagePreview(
                      top: 15,
                      right: (constraints.maxWidth / 4) - 15,
                      url: wallpapersList.data.length > 1
                          ? wallpapersList.data[1].thumbs.large
                          : null,
                    ),
                    FolderImagePreview(
                      top: 30,
                      right: (constraints.maxWidth / 4) - 30,
                      url: wallpapersList.data.isEmpty
                          ? null
                          : wallpapersList.data[0].thumbs.large,
                    ),
                  ],
                ),
              ),
              Text(
                folderTitle,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FolderImagePreview extends StatelessWidget {
  const FolderImagePreview({
    super.key,
    required this.top,
    required this.right,
    this.url,
  });
  final double top;
  final double right;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final isVertical = size.height > size.width;
    final itemHeight = isVertical
        ? (size.width * size.width / size.height) - 70
        : (size.height * size.height / size.width) - 45;
    return Positioned(
      top: top,
      left: right,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: itemHeight,
            width: itemHeight,
            color: Colors.white60,
            child: url == null
                ? Container()
                : CachedNetworkImage(
                    imageUrl: url!,
                    fit: BoxFit.cover,
                  ),
          )),
    );
  }
}
