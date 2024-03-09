import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/widgets/masonry_grid_widget.dart';

class FavouriteWallpaperGridScreen extends StatelessWidget {
  const FavouriteWallpaperGridScreen({super.key});
  static const routeName = "/FavouritesScreen/FavouriteFolder";

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final wallpaperList = title == "System | All"
        ? favouritesProvider.allFavourites
        : favouritesProvider.favouriteFolders[title];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      appBar: AppBar(
        title: Text(
          "Favourites: $title",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
              listNeedsNetworkLoading: false,
              wallpaperList: wallpaperList,
            ),
    );
  }
}
