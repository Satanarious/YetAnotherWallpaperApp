import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/screens/favourite_wallpaper_grid_screen.dart';
import 'package:wallpaper_app/screens/open_image_screen.dart';

import '../action_dialogs/add_to_favourites_dialog.dart';
import '../models/models.dart';
import '../providers/favourites_provider.dart';

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
            if (!isFavourite) {
              favouritesProvider.addWallpaperToAllFolder(widget.wallpaper);
            } else {
              // Check and remove wallpaper in a single folder
              final cannotRemove = favouritesProvider
                  .removeWallpaperFromAllFolder(widget.wallpaper);
              // When wallpaper exists in multiple folders
              if (cannotRemove) {
                final folderName = ModalRoute.of(context)!.settings.arguments;
                // When trying to remove from a favourites folder
                if (ModalRoute.of(context)!.settings.name ==
                        FavouriteWallpaperGridScreen.routeName &&
                    folderName != "System | All") {
                  favouritesProvider.removeWallpaperFromFolder(
                      folderName as String, widget.wallpaper);
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
            }
            setState(() {});
          },
          onLongPress: () async {
            await showDialog(
              context: context,
              builder: (context) => AddToFavouritesDialog(widget.wallpaper),
            );
          },
          child: AnimatedBuilder(
            animation: rotationAnimation,
            builder: (context, child) => Transform(
              transform: Matrix4.rotationY(rotationAnimation.value * 2 * pi),
              alignment: Alignment.center,
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_outline,
                size: isOpenImageScreen ? 30 : 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
