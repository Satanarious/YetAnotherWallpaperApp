import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';

class RenameFolderDialog extends StatefulWidget {
  const RenameFolderDialog(this.originalFolderName, {super.key});
  final String originalFolderName;

  @override
  State<RenameFolderDialog> createState() => _RenameFolderDialogState();
}

class _RenameFolderDialogState extends State<RenameFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  String? name = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconlyLight.edit,
                              color: Colors.white,
                            ),
                            Text(
                              "Rename",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                      const SizedBox(height: 10),
                      const Text(
                        "Edit the folder to take a different name",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            IconlyLight.folder,
                            color: Colors.white.withAlpha(180),
                          ),
                          hintText: "Enter folder name",
                          contentPadding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 10, vertical: 2),
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          final favouritesProvider =
                              Provider.of<FavouritesProvider>(context,
                                  listen: false);
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
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                final favouritesStorageProvider =
                                    Provider.of<FavouritesStorageProvider>(
                                        context,
                                        listen: false);
                                favouritesStorageProvider
                                    .renameFavouritesFolder(
                                        widget.originalFolderName, name!);

                                final favouritesProvider =
                                    Provider.of<FavouritesProvider>(context,
                                        listen: false);

                                await Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  favouritesProvider
                                      .shouldNotifyListener(false);
                                  favouritesProvider.renameFavouritesFolder(
                                      widget.originalFolderName,
                                      name!,
                                      favouritesStorageProvider);
                                });
                                favouritesProvider.shouldNotifyListener(true);
                              }
                            },
                            style: ButtonStyle(
                              side: WidgetStateProperty.resolveWith((states) =>
                                  const BorderSide(color: Colors.white)),
                              backgroundColor: WidgetStateProperty.resolveWith(
                                  (states) => Theme.of(context)
                                      .primaryColor
                                      .withAlpha(120)),
                            ),
                            child: const Text("Rename"),
                          ),
                          const SizedBox(width: 10),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
