import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';

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
          color: Colors.grey,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Validate for empty string
                        return "Enter a valid name";
                      } else if (favouritesProvider.favouriteFolders.keys
                          .contains(value)) {
                        // Validate for folder duplicate
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
