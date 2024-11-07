import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/widgets/delete_favourite_folder_button.dart';
import 'package:wallpaper_app/widgets/masonry_grid_widget.dart';
import 'package:wallpaper_app/widgets/share_favourite_folder_button.dart';

class FavouriteWallpaperGridScreen extends StatelessWidget {
  const FavouriteWallpaperGridScreen({super.key});
  static const routeName = "/FavouritesScreen/FavouriteFolder";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final wallpaperList = title == "System | All"
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
              child: FloatingActionButton(
                onPressed: () => showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, wid) {
                      return Transform.scale(
                        scale: a1.value,
                        child: Opacity(
                          opacity: a1.value,
                          child: Container(),
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) =>
                        Container()),
                backgroundColor: Colors.white.withAlpha(50),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
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
                "Favourites: $title",
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                ShareFavouriteFolderButton(title),
                DeleteFavouriteFolderButton(title)
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
