import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/add_folder_dialog.dart';
import 'package:wallpaper_app/models/wallpaper_list.dart';
import 'package:wallpaper_app/providers/favourites_provider.dart';
import 'package:wallpaper_app/screens/favourite_wallpaper_grid_screen.dart';
import 'package:wallpaper_app/widgets/delete_favourite_folder_button.dart';
import 'package:wallpaper_app/widgets/share_favourite_folder_button.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});
  static const String routeName = "/FavouritesScreen";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final favouriteFolders = favouritesProvider.favouriteFolders;
    final Iterable<String> favouritefolderTitles = favouriteFolders.keys;
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width ~/ 200;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              title: const Text(
                "Favourites",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: FloatingActionButton(
                onPressed: () => showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, wid) {
                      return Transform.scale(
                        scale: a1.value,
                        child: Opacity(
                          opacity: a1.value,
                          child: const AddFolderDialog(),
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) =>
                        Container()),
                backgroundColor: Colors.white.withAlpha(50),
                child: const Icon(
                  IconlyLight.folder,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: favouriteFolders.isEmpty &&
              favouritesProvider.allFavourites.data.isEmpty
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
          : GridView.count(
              mainAxisSpacing: 10,
              crossAxisCount: crossAxisCount,
              children: [
                    FavouriteFolderWidget(
                      crossAxisCount: crossAxisCount,
                      wallpapersList: favouritesProvider.allFavourites,
                      folderTitle: "System | All",
                      isGrid: true,
                    ),
                  ] +
                  favouritefolderTitles
                      .map((folderTitle) => FavouriteFolderWidget(
                            crossAxisCount: crossAxisCount,
                            wallpapersList: favouriteFolders[folderTitle]!,
                            folderTitle: folderTitle,
                            isGrid: false,
                          ))
                      .toList(),
            ),
    );
  }
}

class FavouriteFolderWidget extends StatefulWidget {
  const FavouriteFolderWidget({
    super.key,
    required this.crossAxisCount,
    required this.wallpapersList,
    required this.folderTitle,
    required this.isGrid,
  });

  final int crossAxisCount;
  final WallpaperList wallpapersList;
  final String folderTitle;
  final bool isGrid;

  @override
  State<FavouriteFolderWidget> createState() => _FavouriteFolderWidgetState();
}

class _FavouriteFolderWidgetState extends State<FavouriteFolderWidget>
    with SingleTickerProviderStateMixin {
  bool showFolderOptions = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 10).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.stop();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
          FavouriteWallpaperGridScreen.routeName,
          arguments: widget.folderTitle),
      onLongPress: () {
        if (widget.folderTitle == "System | All") return;
        setState(() => showFolderOptions = !showFolderOptions);
        _controller.forward();
      },
      child: SizedBox(
        height: size.width / widget.crossAxisCount,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (size.width / widget.crossAxisCount) - 45,
                child: widget.isGrid
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FolderGridImagePreview(
                                url: widget.wallpapersList.data.isNotEmpty
                                    ? widget.wallpapersList.data[0].thumbs.large
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              FolderGridImagePreview(
                                url: widget.wallpapersList.data.length > 1
                                    ? widget.wallpapersList.data[1].thumbs.large
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FolderGridImagePreview(
                                url: widget.wallpapersList.data.length > 2
                                    ? widget.wallpapersList.data[2].thumbs.large
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              FolderGridImagePreview(
                                url: widget.wallpapersList.data.length > 3
                                    ? widget.wallpapersList.data[3].thumbs.large
                                    : null,
                              ),
                            ],
                          )
                        ],
                      )
                    : Stack(
                        children: [
                          FolderImagePreview(
                            top: 0,
                            right: constraints.maxWidth / 4,
                            url: widget.wallpapersList.data.length > 2
                                ? widget.wallpapersList.data[2].thumbs.large
                                : null,
                          ),
                          FolderImagePreview(
                            top: 15,
                            right: (constraints.maxWidth / 4) - 15,
                            url: widget.wallpapersList.data.length > 1
                                ? widget.wallpapersList.data[1].thumbs.large
                                : null,
                          ),
                          FolderImagePreview(
                            top: 30,
                            right: (constraints.maxWidth / 4) - 30,
                            url: widget.wallpapersList.data.isEmpty
                                ? null
                                : widget.wallpapersList.data[0].thumbs.large,
                          ),
                          Positioned(
                            top: -15,
                            left: 0,
                            child: Visibility(
                              visible: showFolderOptions,
                              child: Transform.translate(
                                offset: Offset(
                                    _animation.value *
                                        sin(_controller.value * pi * 2),
                                    0),
                                child: ShareFavouriteFolderButton(
                                    widget.folderTitle),
                              ),
                            ),
                          ),
                          Positioned(
                              top: -15,
                              right: -5,
                              child: Visibility(
                                visible: showFolderOptions,
                                child: Transform.translate(
                                  offset: Offset(
                                      _animation.value *
                                          sin(_controller.value * pi * 2),
                                      0),
                                  child: DeleteFavouriteFolderButton(
                                      widget.folderTitle),
                                ),
                              ))
                        ],
                      ),
              ),
              Text(
                widget.folderTitle,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
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
  static const itemHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: right,
      child: Container(
          height: itemHeight,
          width: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white60,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: url == null
              ? Container()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: url!,
                    fit: BoxFit.cover,
                  ),
                )),
    );
  }
}

class FolderGridImagePreview extends StatelessWidget {
  const FolderGridImagePreview({
    super.key,
    this.url,
  });
  final String? url;
  static const itemHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemHeight,
      width: itemHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white60,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: url == null
          ? Container()
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
