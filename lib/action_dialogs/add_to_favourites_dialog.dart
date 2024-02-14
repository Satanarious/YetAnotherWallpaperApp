import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/models.dart';
import '../providers/favourites_provider.dart';

class AddToFavouritesDialog extends StatefulWidget {
  const AddToFavouritesDialog(this.wallpaper, {super.key});
  final Wallpaper wallpaper;

  @override
  State<AddToFavouritesDialog> createState() => _AddToFavouritesDialogState();
}

class _AddToFavouritesDialogState extends State<AddToFavouritesDialog> {
  bool _showAddFolderOptions = false;
  final List<String> _favouriteFoldersWhereWallpaperExists = [];

  void setShowAddFolderOptions() {
    setState(() {
      _showAddFolderOptions = false;
    });
  }

  void toggleFavourite(String folderName) {
    if (_favouriteFoldersWhereWallpaperExists.contains(folderName)) {
      _favouriteFoldersWhereWallpaperExists.remove(folderName);
    } else {
      _favouriteFoldersWhereWallpaperExists.add(folderName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favourites = favouritesProvider.favouriteFolders;

    final dialogHeight = height /
        (favourites.keys.length >= 3
            ? 3
            : favourites.keys.length == 2
                ? 4
                : favourites.keys.length == 1
                    ? 5
                    : 6);
    var bottomChild = _showAddFolderOptions
        ? Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 15, top: 10, left: 10, right: 10),
              child: FolderForm(
                setShowAddFolderOptions,
              ),
            ))
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => setState(() {
                    _showAddFolderOptions =
                        _showAddFolderOptions == !_showAddFolderOptions;
                  }),
                  child: const Text("Add New Folder"),
                ),
                SizedBox(width: favourites.keys.isEmpty ? 0 : 20),
                favourites.keys.isEmpty
                    ? Container()
                    : OutlinedButton(
                        onPressed: () {
                          for (var folderName
                              in _favouriteFoldersWhereWallpaperExists) {
                            (favourites[folderName] as WallpaperList)
                                .addWallpaper(widget.wallpaper);
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok"),
                      ),
              ],
            ),
          );

    return Dialog(
      child: SizedBox(
          height: dialogHeight,
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: FolderForm(setShowAddFolderOptions),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: favourites.keys.length,
                            itemBuilder: (context, index) {
                              return FavouriteFolderTile(
                                  favourites.keys.elementAt(index),
                                  toggleFavourite);
                            },
                          ),
                        ),
                  favourites.keys.isEmpty ? Container() : bottomChild
                ],
              ),
            ),
          )),
    );
  }
}

class FavouriteFolderTile extends StatefulWidget {
  const FavouriteFolderTile(this.folderName, this.toggleFavourite, {super.key});
  final String folderName;
  final dynamic toggleFavourite;

  @override
  State<FavouriteFolderTile> createState() => _FavouriteFolderTileState();
}

class _FavouriteFolderTileState extends State<FavouriteFolderTile> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => setState(() {
        _selected = !_selected;
        widget.toggleFavourite(widget.folderName);
      }),
      title: Text(
        widget.folderName,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      leading: Icon(_selected ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.white),
    );
  }
}

class FolderForm extends StatefulWidget {
  const FolderForm(this.removeFolderOption, {super.key});
  final dynamic removeFolderOption;

  @override
  State<FolderForm> createState() => _FolderFormState();
}

class _FolderFormState extends State<FolderForm> {
  final _formState = GlobalKey<FormState>();
  String folderName = '';

  @override
  Widget build(BuildContext context) {
    final favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    final favourites = favouritesProvider.favouriteFolders;
    return Form(
      key: _formState,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter a folder name";
                } else if (favourites.keys.contains(value)) {
                  return "Folder already exists";
                } else {
                  folderName = value;
                  return null;
                }
              },
              autofocus: true,
              decoration: const InputDecoration(labelText: "Folder Name"),
            ),
          ),
          TextButton(
              onPressed: () {
                if (_formState.currentState!.validate()) {
                  favouritesProvider.createFolder(folderName);
                  widget.removeFolderOption();
                }
              },
              child: const Text("Create"))
        ],
      ),
    );
  }
}
