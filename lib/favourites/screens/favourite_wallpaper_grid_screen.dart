import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/common/widgets/masonry_grid_widget.dart';
import 'package:wallpaper_app/favourites/dialogs/rename_folder_dialog.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';

class FavouriteWallpaperGridScreen extends StatelessWidget {
  const FavouriteWallpaperGridScreen({super.key});
  static const routeName = "/FavouritesScreen/FavouriteFolder";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    final isSystemFolder = title == "System | All";
    final favouritesProvider = Provider.of<FavouritesProvider>(context);

    // Condition to prevent rebuild after folder deletion
    if (!favouritesProvider.notifyFavouritesListener) {
      favouritesProvider.shouldNotifyListener(true);
      return const SizedBox.shrink();
    }
    final favouritesStorageProvider =
        Provider.of<FavouritesStorageProvider>(context, listen: false);
    final wallpaperList = isSystemFolder
        ? favouritesProvider.allFavourites
        : favouritesProvider.favouriteFolders[title];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      extendBodyBehindAppBar: true,
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
                    Icons.add_photo_alternate_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () => favouritesProvider.addLocalWallpapers(
                    context: context,
                    favouritesStorageProvider: favouritesStorageProvider,
                    isSystemFolder: isSystemFolder,
                    title: title,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              title: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                isSystemFolder
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () => AnimatedPopInDialog.showGeneral(
                            context, RenameFolderDialog(title)),
                        icon: const Icon(
                          IconlyLight.edit,
                          color: Colors.white,
                        ),
                        tooltip: "Rename",
                      ),
                IconButton(
                    onPressed: () => AnimatedPopInDialog.showCustomized(
                          context: context,
                          title: "Share or Save",
                          icon: Icons.share_rounded,
                          description:
                              "Choose whether to share this folder or save it on device. Local wallpapers will be skipped from this export. ",
                          buttonNameAndFunctionMap: {
                            "Cancel": Navigator.of(context).pop,
                            "Share": () {
                              favouritesProvider.shareFavouriteFolder(title);
                              Navigator.of(context).pop();
                            },
                            "Save": () async {
                              if (await favouritesProvider
                                  .saveFavouritesFolderJson(title)) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Saved to Downloads!!"),
                                  ));
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Failed to save to Downloads!!"),
                                  ));
                                }
                              }
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                    icon: const Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                      size: 20,
                    )),
                isSystemFolder
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(
                          IconlyLight.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          await AnimatedPopInDialog.showCustomized(
                            context: context,
                            title: "Warning",
                            icon: Icons.warning_amber_rounded,
                            description:
                                "Deleting this folder will also delete all favourited items inside it as well. Are you sure you want to delete this folder?",
                            buttonNameAndFunctionMap: {
                              "Cancel": Navigator.of(context).pop,
                              "Delete": () async {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  final favouritesStorageProvider =
                                      Provider.of<FavouritesStorageProvider>(
                                          context,
                                          listen: false);
                                  final favouritesProvider =
                                      Provider.of<FavouritesProvider>(context,
                                          listen: false);
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    favouritesStorageProvider
                                        .removeFavouriteFolder(title);
                                    favouritesProvider
                                        .shouldNotifyListener(false);
                                    favouritesProvider.removeFolder(
                                        title, favouritesStorageProvider);
                                  });
                                }
                              }
                            },
                          );
                        },
                      )
              ],
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: wallpaperList!.data.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/empty.gif",
                    height: 200,
                    width: 300,
                    fit: BoxFit.fitWidth,
                  ),
                  const Text(
                    "Nothing Found!",
                    style: TextStyle(color: Colors.white54, fontSize: 20),
                  ),
                ],
              ),
            )
          : MasonryGridWidget(
              addPadding: true,
              listNeedsNetworkLoading: false,
              wallpaperList: wallpaperList,
            ),
    );
  }
}
