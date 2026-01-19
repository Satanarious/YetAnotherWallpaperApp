import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/screens/favourites_screen.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

class AddToFavouritesDialog extends StatefulWidget {
  const AddToFavouritesDialog(this.wallpaper, {super.key});
  final Wallpaper wallpaper;

  @override
  State<AddToFavouritesDialog> createState() => _AddToFavouritesDialogState();
}

class _AddToFavouritesDialogState extends State<AddToFavouritesDialog> {
  late List _favouriteFoldersWhereWallpaperNeedsAdding;
  late List _initialSelection;
  var isFirst = true;

  void toggleFavourite(String folderName) {
    if (_favouriteFoldersWhereWallpaperNeedsAdding.contains(folderName)) {
      setState(() {
        _favouriteFoldersWhereWallpaperNeedsAdding.remove(folderName);
      });
    } else {
      setState(() {
        _favouriteFoldersWhereWallpaperNeedsAdding.add(folderName);
      });
    }
  }

  @override
  void initState() {
    _initialSelection = Provider.of<FavouritesProvider>(context, listen: false)
        .foldersWhereWallpaperExists(widget.wallpaper);
    _favouriteFoldersWhereWallpaperNeedsAdding = [..._initialSelection];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favourites = favouritesProvider.favouriteFolders;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 350,
        width: 360,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Add to Favourites",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  favourites.keys.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Add folders in the favourites screen to proceed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(FavouritesScreen.routeName),
                                  child: const Text(
                                    "Goto Favourites",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: favourites.keys.length,
                            itemBuilder: (context, index) {
                              final folderName =
                                  favourites.keys.elementAt(index);
                              return FavouriteFolderTile(
                                  folderName,
                                  toggleFavourite,
                                  _favouriteFoldersWhereWallpaperNeedsAdding
                                      .contains(folderName));
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: Navigator.of(context).pop,
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
                        const SizedBox(
                          width: 5,
                        ),
                        FilledButton(
                          onPressed: () {
                            // Clear All Selected
                            setState(() {
                              _favouriteFoldersWhereWallpaperNeedsAdding
                                  .clear();
                            });
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.resolveWith((states) =>
                                const BorderSide(color: Colors.white)),
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Theme.of(context)
                                    .primaryColor
                                    .withAlpha(120)),
                          ),
                          child: const Text("Clear All"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        FilledButton(
                          onPressed: () {
                            final favouritesStorageProvider =
                                Provider.of<FavouritesStorageProvider>(context,
                                    listen: false);
                            final isFavourite =
                                favouritesProvider.manageFavouriteFolders(
                              widget.wallpaper,
                              _initialSelection,
                              _favouriteFoldersWhereWallpaperNeedsAdding,
                              favouritesStorageProvider,
                            );
                            Navigator.of(context).pop(isFavourite);
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.resolveWith((states) =>
                                const BorderSide(color: Colors.white)),
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Theme.of(context)
                                    .primaryColor
                                    .withAlpha(120)),
                          ),
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 100),
                            child: Text(
                                _favouriteFoldersWhereWallpaperNeedsAdding
                                        .isEmpty
                                    ? "Remove"
                                    : "Ok"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavouriteFolderTile extends StatefulWidget {
  const FavouriteFolderTile(
    this.folderName,
    this.toggleFavourite,
    this.initialSelection, {
    super.key,
  });
  final String folderName;
  final dynamic toggleFavourite;
  final bool initialSelection;

  @override
  State<FavouriteFolderTile> createState() => _FavouriteFolderTileState();
}

class _FavouriteFolderTileState extends State<FavouriteFolderTile> {
  late bool _selected;

  void onTap() {
    setState(() {
      // Toggle selection state
      _selected = !_selected;
      widget.toggleFavourite(widget.folderName);
    });
  }

  @override
  Widget build(BuildContext context) {
    _selected = widget.initialSelection;
    final favourites = Provider.of<FavouritesProvider>(context, listen: false)
        .favouriteFolders[widget.folderName];
    const tileSize = 40.0;
    return ListTile(
      onTap: onTap,
      title: Text(
        widget.folderName,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      leading: Checkbox(
        value: _selected,
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        checkColor: Theme.of(context).primaryColor,
        activeColor: Colors.white,
        onChanged: (value) => onTap(),
      ),
      subtitle: SizedBox(
        width: 210,
        height: tileSize,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            final folderIndex = favourites!.data.length - 1;
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: tileSize,
                width: tileSize,
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(80),
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(8)),
                child: index > folderIndex
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: favourites.data.isEmpty
                            ? null
                            : favourites.data[folderIndex - index].source ==
                                    Sources.local
                                ? Image.file(
                                    File(favourites
                                        .data[folderIndex - index].localPath!),
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: favourites
                                        .data[folderIndex - index].url,
                                    fit: BoxFit.cover,
                                    width: tileSize,
                                    height: tileSize,
                                  ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
