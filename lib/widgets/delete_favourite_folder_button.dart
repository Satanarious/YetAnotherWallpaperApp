import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/storage/favourites_storage_provider.dart';

class DeleteFavouriteFolderButton extends StatelessWidget {
  const DeleteFavouriteFolderButton(
    this.folderTitle, {
    super.key,
  });

  final String folderTitle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        IconlyLight.delete,
        color: Colors.white,
        size: 20,
      ),
      onPressed: () async => await AnimatedPopInDialog.show(
        context,
        Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 220,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            "Warning",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                    const Text(
                      "Deleting this folder will also delete all favourited items inside it as well. Are you sure you want to delete this folder?",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.resolveWith((states) =>
                                const BorderSide(color: Colors.white)),
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Theme.of(context)
                                    .primaryColor
                                    .withAlpha(120)),
                          ),
                          child: const Text("Cancel"),
                        ),
                        FilledButton(
                          onPressed: () {
                            Provider.of<FavouritesStorageProvider>(context,
                                    listen: false)
                                .removeFavouriteFolder(folderTitle);
                            Provider.of<FavouritesProvider>(context,
                                    listen: false)
                                .removeFolder(folderTitle);
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.resolveWith((states) =>
                                const BorderSide(color: Colors.white)),
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Theme.of(context)
                                    .primaryColor
                                    .withAlpha(120)),
                          ),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
