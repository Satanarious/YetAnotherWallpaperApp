import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/common/models/wallpaper_list.dart';
import 'package:wallpaper_app/common/widgets/image_preview_grid_item.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/open_image/screens/open_image_screen.dart';
import 'package:wallpaper_app/settings/enums/enums.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

class MasonryGridWidget extends StatefulWidget {
  const MasonryGridWidget(
      {this.addPadding = false,
      this.wallpaperList,
      this.listNeedsNetworkLoading = true,
      super.key});
  final bool listNeedsNetworkLoading;
  final WallpaperList? wallpaperList;
  final bool addPadding;

  @override
  State<MasonryGridWidget> createState() => _MasonryGridWidgetState();
}

class _MasonryGridWidgetState extends State<MasonryGridWidget>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;
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
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final blurNSFW = settingsProvider.blurNsfw;
    final blurSketchy = settingsProvider.blurSketchy;
    final targetWidth = min(200.0, MediaQuery.of(context).size.width / 2.1);
    final topPadding = MediaQuery.of(context).padding.top;
    final roundedCorners = settingsProvider.roundedCorners;
    final gridLayoutStyle = settingsProvider.gridLayoutStyle;
    final columnSizeType = settingsProvider.columnSize;
    final columnWidth = settingsProvider.columnWidth;
    final columnNumber = settingsProvider.columnNumber;

    return LayoutBuilder(
      builder: (context, constraints) {
        final BoxConstraints layoutConstraints = constraints;
        final crossAxisCount = columnSizeType == ColumnSizeType.fixed
            ? columnNumber
            : layoutConstraints.maxWidth ~/ columnWidth;
        final masonryGrid = MasonryGridView.builder(
            padding: EdgeInsets.only(
              top: widget.addPadding
                  ? roundedCorners
                      ? topPadding + 4
                      : topPadding
                  : roundedCorners
                      ? 4
                      : 0,
              left: roundedCorners ? 4 : 0,
              right: roundedCorners ? 4 : 0,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
            ),
            crossAxisSpacing: roundedCorners ? 4 : 2,
            mainAxisSpacing: roundedCorners ? 4 : 2,
            itemCount: wallpapers.length,
            itemBuilder: (context, index) {
              final height = calculateHeight(
                gridLayoutStyle == GridLayoutStyle.fixed
                    ? 1920
                    : wallpapers[index].dimensionY ?? [1920, 1600][index % 2],
                gridLayoutStyle == GridLayoutStyle.fixed
                    ? 1080
                    : wallpapers[index].dimensionX ?? [1080, 800][index % 2],
                targetWidth,
              ).clamp(0, layoutConstraints.maxHeight * 0.7).toDouble();

              return (blurNSFW &&
                          wallpapers[index].purity == PurityType.adult) ||
                      (blurSketchy &&
                          wallpapers[index].purity == PurityType.sketchy)
                  ? Stack(
                      children: [
                        Image.asset(
                          "assets/blur.png",
                          height: height,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 2,
                          left: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            color: Colors.black54,
                            child: Text(
                              wallpapers[index].purity == PurityType.adult
                                  ? "NSFW"
                                  : "Sketchy",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 8),
                            ),
                          ),
                        )
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        if (wallpapers[index].url.isEmpty &&
                            wallpapers[index].source != Sources.local) {
                          return;
                        }

                        if (widget.listNeedsNetworkLoading) {
                          final historyLimit = Provider.of<SettingsProvider>(
                                  context,
                                  listen: false)
                              .historyLimit;
                          final added = Provider.of<HistoryProvider>(context,
                                  listen: false)
                              .addToHistory(wallpapers[index], historyLimit);
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
