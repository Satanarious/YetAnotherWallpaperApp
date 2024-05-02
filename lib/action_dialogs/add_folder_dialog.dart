import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/storage/favourites_storage_provider.dart';

class AddFolderDialog extends StatefulWidget {
  const AddFolderDialog({super.key});

  @override
  State<AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  String? name = '';

  @override
  Widget build(BuildContext context) {
    final favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 180,
          width: 300,
          color: const Color.fromRGBO(50, 50, 50, 1),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      // Check for empty string
                      if (value == null || value.isEmpty) {
                        return "Enter a valid name";
                        // Check for system folder name
                      } else if (value == "System | All") {
                        return "This name is prohibited";
                        // Check for duplicate folder names
                      } else if (favouritesProvider.favouriteFolders.keys
                          .contains(value)) {
                        return "Folder already exists";
                      } else {
                        name = value;
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      label: Text("Folder Name"),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                FilledButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        favouritesProvider.createFolder(name!);
                        Provider.of<FavouritesStorageProvider>(context,
                                listen: false)
                            .addFavouritesFolder(name!);
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Folder")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
