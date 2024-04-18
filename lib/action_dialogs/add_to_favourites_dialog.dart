import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/models.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/screens/favourites_screen.dart';

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
      child: SizedBox(
        height: 270,
        width: 360,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: const Color.fromRGBO(50, 50, 50, 1),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(FavouritesScreen.routeName),
                                child: Text(
                                  "Goto Favourites",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: favourites.keys.length,
                          itemBuilder: (context, index) {
                            final folderName = favourites.keys.elementAt(index);
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
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FilledButton(
                        onPressed: () {
                          // Clear All Selected
                          setState(() {
                            _favouriteFoldersWhereWallpaperNeedsAdding.clear();
                          });
                        },
                        child: const Text("Clear All"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FilledButton(
                        onPressed: () {
                          final isFavourite =
                              favouritesProvider.manageFavouriteFolders(
                            widget.wallpaper,
                            _initialSelection,
                            _favouriteFoldersWhereWallpaperNeedsAdding,
                          );
                          Navigator.of(context).pop(isFavourite);
                        },
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          child: Text(
                              _favouriteFoldersWhereWallpaperNeedsAdding.isEmpty
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
    return ListTile(
        onTap: onTap,
        title: Text(
          widget.folderName,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        leading: Checkbox(
          value: _selected,
          onChanged: (value) => onTap(),
        ));
  }
}
