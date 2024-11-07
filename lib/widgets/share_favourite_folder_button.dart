import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/storage/favourites_storage_provider.dart';

class ShareFavouriteFolderButton extends StatelessWidget {
  const ShareFavouriteFolderButton(
    this.folderTitle, {
    super.key,
  });

  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () =>
            Provider.of<FavouritesStorageProvider>(context, listen: false)
                .shareFavouriteFolder(folderTitle),
        icon: const Icon(
          Icons.share_rounded,
          color: Colors.white,
          size: 20,
        ));
  }
}
