import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../action_dialogs/add_to_favourites_dialog.dart';
import '../models/models.dart';
import '../providers/favourites_provider.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    required this.wallpaper,
    required this.size,
    super.key,
  });

  final Wallpaper wallpaper;
  final double size;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final isFavourite =
        favouritesProvider.allFavourites.data.contains(widget.wallpaper);
    return SizedBox(
      width: widget.size == 20 ? 30 : 46,
      height: widget.size == 20 ? 30 : 46,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            if (!isFavourite) {
              favouritesProvider.addWallpaperToAllFolder(widget.wallpaper);
            } else {
              final cannotRemove = favouritesProvider
                  .removeWallpaperFromAllFolder(widget.wallpaper);
              if (cannotRemove) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Attention:Remove from all folders to proceed")));
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
          child: Icon(
            isFavourite ? Icons.favorite : Icons.favorite_outline,
            size: widget.size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
