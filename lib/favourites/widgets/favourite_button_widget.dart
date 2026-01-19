import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/favourites/dialogs/add_to_favourites_dialog.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/screens/favourite_wallpaper_grid_screen.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/open_image/screens/open_image_screen.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    required this.wallpaper,
    super.key,
  });

  final Wallpaper wallpaper;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> rotationAnimation =
        Tween<double>(begin: 0, end: pi * 0.3).animate(_controller);
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final isFavourite =
        favouritesProvider.allFavourites.data.contains(widget.wallpaper);
    final isOpenImageScreen =
        ModalRoute.of(context)!.settings.name == OpenImageScreen.routeName;
    return SizedBox(
      width: isOpenImageScreen ? 46 : 40,
      height: isOpenImageScreen ? 46 : 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            _controller.forward(from: 0);
            final favouritesStorageProvider =
                Provider.of<FavouritesStorageProvider>(context, listen: false);
            if (!isFavourite) {
              favouritesProvider.addWallpaperToAllFolder(widget.wallpaper);
              favouritesStorageProvider.updateFavouritesFolder(
                  "System | All", favouritesProvider.allFavourites);
            } else {
              final folderName = ModalRoute.of(context)!.settings.arguments;
              if (folderName != FavouritesProvider.systemFolderName) {
                favouritesProvider.shouldNotifyListener(false);
              }
              // Check and remove wallpaper in a single folder
              final cannotRemove =
                  favouritesProvider.removeWallpaperFromAllFolder(
                      widget.wallpaper, favouritesStorageProvider);
              favouritesProvider.shouldNotifyListener(true);

              // When wallpaper exists in multiple folders
              if (cannotRemove) {
                // When trying to remove from a favourites folder
                if (ModalRoute.of(context)!.settings.name ==
                        FavouriteWallpaperGridScreen.routeName &&
                    folderName != "System | All") {
                  favouritesProvider.removeWallpaperFromFolder(
                      folderName as String, widget.wallpaper);
                  favouritesStorageProvider.updateFavouritesFolder(folderName,
                      favouritesProvider.favouriteFolders[folderName]!);
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Attention: Remove wallpaper from all folders to proceed"),
                    ),
                  );
                }
              }
              // When wallpaper exists in only one folder
              else {
                if (folderName == FavouritesProvider.systemFolderName ||
                    folderName == null) {
                } else {
                  favouritesProvider.removeWallpaperFromFolder(
                      folderName as String, widget.wallpaper);
                  favouritesStorageProvider.updateFavouritesFolder(folderName,
                      favouritesProvider.favouriteFolders[folderName]!);
                }
              }
            }
            setState(() {});
          },
          onLongPress: () async {
            await showGeneralDialog(
                barrierColor: Colors.black.withValues(alpha: 0.5),
                transitionBuilder: (context, a1, a2, wid) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: Builder(
                          builder: (context) =>
                              AddToFavouritesDialog(widget.wallpaper)),
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) => Container());
          },
          child: AnimatedBuilder(
            animation: rotationAnimation,
            builder: (context, child) => Transform(
              transform: Matrix4.rotationY(rotationAnimation.value * 2 * pi),
              alignment: Alignment.center,
              child: Icon(
                isFavourite ? IconlyBold.heart : IconlyLight.heart,
                size: isOpenImageScreen ? 30 : 23,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
