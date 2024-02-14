import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../providers/providers.dart';
import '../action_dialogs/add_to_favourites_dialog.dart';
import '../models/wallpaper.dart';

class WallpaperActionsWidget extends StatefulWidget {
  const WallpaperActionsWidget(this.wallpaper, {super.key});
  final Wallpaper wallpaper;

  @override
  State<WallpaperActionsWidget> createState() => _WallpaperActionsWidgetState();
}

class _WallpaperActionsWidgetState extends State<WallpaperActionsWidget> {
  static const _draggableHeight = 200;
  static const _bottomSpacing = 40;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    final scrollHandlingProvider =
        Provider.of<ScrollHandlingProvider>(context, listen: false);
    final ValueNotifier<Offset> notifier =
        ValueNotifier(Offset(0, size.height - _bottomSpacing));
    return ValueListenableBuilder<Offset>(
        valueListenable: notifier,
        builder: (context, draggingOffset, child) {
          final rotationAngle =
              (size.height - _draggableHeight - draggingOffset.dy) /
                  (_draggableHeight - _bottomSpacing) *
                  pi;

          return Positioned(
            top: draggingOffset.dy,
            left: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dy > 0) {
                  if (notifier.value.dy < size.height - _bottomSpacing) {
                    notifier.value += details.delta;
                  }
                } else {
                  if (notifier.value.dy > size.height - _draggableHeight) {
                    notifier.value += details.delta;
                  }
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            color: Colors.black87,
                            height: 160,
                            width: size.width / 1.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform(
                                      transform: Matrix4.identity()
                                        ..rotateX(rotationAngle),
                                      alignment: FractionalOffset.center,
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    source == Sources.wallhaven
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: widget.wallpaper.colors
                                                  .map((color) {
                                                final r = int.parse(
                                                    color.substring(1, 3),
                                                    radix: 16);
                                                final g = int.parse(
                                                    color.substring(3, 5),
                                                    radix: 16);
                                                final b = int.parse(
                                                    color.substring(5),
                                                    radix: 16);
                                                return GestureDetector(
                                                  onTap: () {
                                                    queryProvider
                                                        .setWallhavenQuery(
                                                            color: color
                                                                .substring(1));
                                                    wallpaperListProvider
                                                        .emptyWallpaperList();
                                                    scrollHandlingProvider
                                                        .resetOffsets();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 17,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              r, g, b, 1),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          )
                                        : Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    widget.wallpaper.title!,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${widget.wallpaper.author}  |  ",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            launchUrlString(
                                                                widget.wallpaper
                                                                    .postUrl!),
                                                        child: const Text(
                                                          "Open in Browser",
                                                          style: TextStyle(
                                                            color: Colors.cyan,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (source == Sources.wallhaven) {
                                                queryProvider.setWallhavenQuery(
                                                    wallpaperId:
                                                        widget.wallpaper.id);
                                                wallpaperListProvider
                                                    .emptyWallpaperList();

                                                scrollHandlingProvider
                                                    .resetOffsets();
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            tooltip: "Search Similar",
                                            icon: const Icon(
                                              Icons.search,
                                              size: 30,
                                              color: Colors.white,
                                            )),
                                        IconButton(
                                            onPressed: () => null,
                                            tooltip: "Set Wallpaper",
                                            icon: const Icon(
                                              Icons.landscape,
                                              size: 30,
                                              color: Colors.white,
                                            )),
                                        IconButton(
                                            onPressed: () => null,
                                            tooltip: "Download",
                                            icon: const Icon(
                                              Icons.download,
                                              size: 30,
                                              color: Colors.white,
                                            )),
                                        IconButton(
                                            onPressed: () => showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ChangeNotifierProvider.value(
                                                          value:
                                                              favouritesProvider,
                                                          child: AddToFavouritesDialog(
                                                              widget
                                                                  .wallpaper)),
                                                ),
                                            tooltip: "Add to Favourites",
                                            icon: const Icon(
                                              Icons.favorite_outline,
                                              size: 30,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ]),
                            )))
                  ]),
            ),
          );
        });
  }
}
