// ignore: unused_import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:wallpaper_app/enums/file_type.dart';
// ignore: unused_import
import 'package:wallpaper_app/enums/purity.dart';
import 'package:wallpaper_app/models/wallpaper_list.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:wallpaper_app/screens/open_image_screen.dart';
import 'package:wallpaper_app/storage/history_storage_provider.dart';
import 'package:wallpaper_app/widgets/image_preview_grid_item.dart';

class MasonryGridWidget extends StatefulWidget {
  const MasonryGridWidget(
      {this.wallpaperList, this.listNeedsNetworkLoading = true, super.key});
  final bool listNeedsNetworkLoading;
  final WallpaperList? wallpaperList;

  @override
  State<MasonryGridWidget> createState() => _MasonryGridWidgetState();
}

class _MasonryGridWidgetState extends State<MasonryGridWidget>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;
  static const targetWidth = 200.0;
  bool _loading = false;

  double calculateHeight(int imageHeight, int imageWidth, double targetWidth) {
    final aspectRatio = imageWidth / imageHeight;
    final targetHeight = targetWidth / aspectRatio;
    return targetHeight;
  }

  void _loadWallpapers() async {
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    final query = Provider.of<QueryProvider>(context, listen: false).query;
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    setState(() {
      _loading = true;
    });
    await wallpaperListProvider.loadMoreWallpapers(
        newSource: source, query: query);
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final wallpapers = widget.listNeedsNetworkLoading
        ? Provider.of<WallpaperListProvider>(context).wallpapers.data
        : widget.wallpaperList!.data;
    final blurNSFW =
        Provider.of<QueryProvider>(context, listen: false).blurNSFW;

    return LayoutBuilder(
      builder: (context, constraints) {
        final BoxConstraints layoutConstraints = constraints;
        final crossAxisCount = layoutConstraints.maxWidth ~/ targetWidth;
        final masonryGrid = MasonryGridView.builder(
            padding: const EdgeInsets.only(top: 0),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
            ),
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            itemCount: wallpapers.length,
            itemBuilder: (context, index) {
              final height = calculateHeight(
                wallpapers[index].dimensionY ?? [1920, 1600][index % 2],
                wallpapers[index].dimensionX ?? [1080, 800][index % 2],
                targetWidth,
              ).clamp(0, layoutConstraints.maxHeight * 0.7).toDouble();

              // return blurNSFW && wallpapers[index].purity == PurityType.adult
              //     ? Stack(
              //         alignment: Alignment.center,
              //         children: [
              //           Image.asset(
              //             "assets/blur.png",
              //             height: height,
              //             width: double.infinity,
              //             fit: BoxFit.cover,
              //           ),
              //           Transform.rotate(
              //             angle: -pi / 12,
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(10),
              //               child: Container(
              //                 padding:
              //                     const EdgeInsets.symmetric(horizontal: 8),
              //                 decoration: BoxDecoration(
              //                   border: Border.all(
              //                       width: 5, color: Colors.black54),
              //                 ),
              //                 child: const Text(
              //                   "NSFW",
              //                   style: TextStyle(
              //                       color: Colors.black54,
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 30),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       )
              //     :
              return GestureDetector(
                onTap: () {
                  if (wallpapers[index].url.isEmpty) return;
                  if (widget.listNeedsNetworkLoading) {
                    final added =
                        Provider.of<HistoryProvider>(context, listen: false)
                            .addToHistory(wallpapers[index]);
                    if (added) {
                      Provider.of<HistoryStorageProvider>(context,
                              listen: false)
                          .addWallpaperToHistory(wallpapers[index]);
                    }
                  }
                  Navigator.of(context).pushNamed(
                    OpenImageScreen.routeName,
                    arguments: wallpapers[index],
                  );
                },
                child: ImagePreviewGridItem(
                  wallpaper: wallpapers[index],
                  height: height,
                ),
              );
            });

        return Container(
          color: const Color.fromRGBO(50, 50, 50, 1),
          child: widget.listNeedsNetworkLoading
              ? NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (!_loading &&
                        notification is ScrollEndNotification &&
                        notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent) {
                      _loadWallpapers();
                    }
                    if (notification is ScrollUpdateNotification) {
                      Provider.of<ScrollHandlingProvider>(context,
                              listen: false)
                          .setScrollOffset(notification.metrics.pixels);
                    }

                    return true;
                  },
                  child: Stack(
                    children: [
                      masonryGrid,
                      _loading
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: LinearProgressIndicator(
                                backgroundColor:
                                    const Color.fromRGBO(50, 50, 50, 1),
                                color: Theme.of(context).primaryColor,
                              ))
                          : Container(),
                    ],
                  ),
                )
              : masonryGrid,
        );
      },
    );
  }
}
