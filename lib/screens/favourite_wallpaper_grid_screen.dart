import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/widgets/masonry_grid_widget.dart';

class FavouriteWallpaperGridScreen extends StatelessWidget {
  const FavouriteWallpaperGridScreen({super.key});
  static const routeName = "/FavouritesScreen/FavouriteFolder";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favouritesStorageProvider =
        Provider.of<FavouritesStorageProvider>(context, listen: false);
    final wallpaperList = title == "System | All"
        ? favouritesProvider.allFavourites
        : favouritesProvider.favouriteFolders[title];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              title: Text(
                "Favourites: $title",
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    onPressed: () => AnimatedPopInDialog.showCustomized(
                          context: context,
                          title: "Share or Save",
                          icon: Icons.share_rounded,
                          description:
                              "Choose whether to share this folder or save it on device.",
                          buttonNameAndFunctionMap: {
                            "Cancel": Navigator.of(context).pop,
                            "Share": () {
                              favouritesStorageProvider
                                  .shareFavouriteFolder(title);
                              Navigator.of(context).pop();
                            },
                            "Save": () async {
                              if (await favouritesStorageProvider
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
                IconButton(
                  icon: const Icon(
                    IconlyLight.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () async =>
                      await AnimatedPopInDialog.showCustomized(
                    context: context,
                    title: "Warning",
                    icon: Icons.warning_amber_rounded,
                    description:
                        "Deleting this folder will also delete all favourited items inside it as well. Are you sure you want to delete this folder?",
                    buttonNameAndFunctionMap: {
                      "Cancel": Navigator.of(context).pop,
                      "Delete": () {
                        Provider.of<FavouritesStorageProvider>(context,
                                listen: false)
                            .removeFavouriteFolder(title);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Provider.of<FavouritesProvider>(context, listen: false)
                            .removeFolder(title);
                      }
                    },
                  ),
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
