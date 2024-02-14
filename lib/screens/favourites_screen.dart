import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/add_folder_dialog.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});
  static const String routeName = "/FavouritesScreen";

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final Iterable<String> favouriteFolders =
        favouritesProvider.favouriteFolders.keys;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      appBar: AppBar(
        title: const Text(
          "Favourites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context, builder: (context) => const AddFolderDialog()),
        child: const Icon(Icons.add),
      ),
      body: favouriteFolders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/empty.gif",
                    height: 200,
                    width: 300,
                    fit: BoxFit.fitWidth,
                  ),
                  const Text(
                    "Add Folders to see them here.",
                    style: TextStyle(color: Colors.white54, fontSize: 20),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: favouriteFolders
                    .map((folderName) => GestureDetector(
                          onTap: () => null,
                          child: SizedBox(
                            height: 200,
                            child: LayoutBuilder(
                              builder: (context, constraints) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 170,
                                    child: Stack(
                                      children: [
                                        FolderImagePreview(
                                          top: 0,
                                          right: constraints.maxWidth / 4,
                                          url: favouritesProvider
                                                      .favouriteFolders[
                                                          folderName]!
                                                      .data
                                                      .length >
                                                  2
                                              ? favouritesProvider
                                                  .favouriteFolders[folderName]!
                                                  .data[2]
                                                  .thumbs
                                                  .small
                                              : null,
                                        ),
                                        FolderImagePreview(
                                          top: 15,
                                          right:
                                              (constraints.maxWidth / 4) - 15,
                                          url: favouritesProvider
                                                      .favouriteFolders[
                                                          folderName]!
                                                      .data
                                                      .length >
                                                  1
                                              ? favouritesProvider
                                                  .favouriteFolders[folderName]!
                                                  .data[1]
                                                  .thumbs
                                                  .small
                                              : null,
                                        ),
                                        FolderImagePreview(
                                          top: 30,
                                          right:
                                              (constraints.maxWidth / 4) - 30,
                                          url: favouritesProvider
                                                  .favouriteFolders[folderName]!
                                                  .data
                                                  .isEmpty
                                              ? null
                                              : favouritesProvider
                                                  .favouriteFolders[folderName]!
                                                  .data[0]
                                                  .thumbs
                                                  .small,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    folderName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
    );
  }
}

class FolderImagePreview extends StatelessWidget {
  const FolderImagePreview({
    super.key,
    required this.top,
    required this.right,
    this.url,
  });
  final double top;
  final double right;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth / 2) - (screenWidth / 5);
    return Positioned(
      top: top,
      left: right,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(itemWidth / 5),
          child: Container(
            height: itemWidth,
            width: itemWidth,
            color: Colors.white60,
            child: url == null
                ? Container()
                : Image.network(
                    url!,
                    fit: BoxFit.cover,
                  ),
          )),
    );
  }
}
