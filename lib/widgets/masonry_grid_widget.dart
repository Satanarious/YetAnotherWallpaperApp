import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import 'image_preview_grid_item.dart';
import '../screens/open_image_screen.dart';

class MasonryGridWidget extends StatefulWidget {
  const MasonryGridWidget({super.key});
  @override
  State<MasonryGridWidget> createState() => _MasonryGridWidgetState();
}

class _MasonryGridWidgetState extends State<MasonryGridWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final BoxConstraints layoutConstraints = constraints;
        return Container(
          color: const Color.fromRGBO(50, 50, 50, 1),
          child: CustomGridView(layoutConstraints: layoutConstraints),
        );
      },
    );
  }
}

class CustomGridView extends StatefulWidget {
  const CustomGridView({
    required this.layoutConstraints,
    super.key,
  });
  final BoxConstraints layoutConstraints;

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  @override
  bool get wantKeepAlive => true;

  double calculateHeight(int imageHeight, int imageWidth, double targetWidth) {
    final aspectRatio = imageWidth / imageHeight;
    final targetHeight = targetWidth / aspectRatio;
    return targetHeight;
  }

  bool _loading = false;

  void _loadWallpapers(WallpaperListProvider wallpaperListProvider) async {
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    final query = Provider.of<QueryProvider>(context, listen: false).query;
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
  Widget build(BuildContext context) {
    super.build(context);
    final wallpaperListProvider = Provider.of<WallpaperListProvider>(context);
    final wallpapers = wallpaperListProvider.wallpapers;
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          _loadWallpapers(wallpaperListProvider);
        }
        Provider.of<ScrollHandlingProvider>(context, listen: false)
            .setScrollOffset(notification.metrics.pixels);

        return true;
      },
      child: Stack(
        children: [
          MasonryGridView.builder(
              padding: const EdgeInsets.only(top: 0),
              controller: _scrollController,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                final height = calculateHeight(
                  wallpapers[index].dimensionY ?? [1920, 1600][index % 2],
                  wallpapers[index].dimensionX ?? [1080, 800][index % 2],
                  widget.layoutConstraints.maxWidth / 2,
                );

                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      OpenImageScreen.routeName,
                      arguments: wallpapers[index]),
                  child: ImagePreviewGridItem(
                    wallpapers[index].thumbs.original,
                    height,
                  ),
                );
              }),
          _loading
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: LinearProgressIndicator(
                    backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                    color: Theme.of(context).primaryColor,
                  ))
              : Container(),
        ],
      ),
    );
  }
}
