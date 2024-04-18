import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/enums/file_type.dart';
import 'package:wallpaper_app/models/wallpaper.dart';
import 'package:wallpaper_app/providers/history_provider.dart';
import 'package:wallpaper_app/screens/screens.dart';
import 'package:wallpaper_app/storage/history_storage_provider.dart';
import 'package:wallpaper_app/widgets/favourite_button_widget.dart';

class ImagePreviewGridItem extends StatefulWidget {
  const ImagePreviewGridItem({
    required this.wallpaper,
    required this.height,
    super.key,
  });
  final Wallpaper wallpaper;
  final double height;

  @override
  State<ImagePreviewGridItem> createState() => _ImagePreviewGridItemState();
}

class _ImagePreviewGridItemState extends State<ImagePreviewGridItem>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late AnimationController _controller;
  @override
  Widget build(BuildContext context) {
    final showDeletButton =
        ModalRoute.of(context)!.settings.name == HistoryScreen.routeName;
    final isGif = widget.wallpaper.fileType == FileType.gif;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _controller.value,
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              height: widget.height,
              width: double.infinity,
              child: CachedNetworkImage(
                filterQuality: FilterQuality.high,
                imageUrl: isGif
                    ? widget.wallpaper.thumbs.large
                    : widget.wallpaper.thumbs.original,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.network(
                  isGif
                      ? widget.wallpaper.thumbs.large
                      : widget.wallpaper.thumbs.original,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress?.cumulativeBytesLoaded ==
                        loadingProgress?.expectedTotalBytes) {
                      return child;
                    } else {
                      return Center(
                        child: Image.asset(
                          "assets/loading.gif",
                          height: 20,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text("Error Loading Preview")),
                ),
                placeholder: (context, url) => Center(
                  child: Image.asset(
                    "assets/loading.gif",
                    height: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: showDeletButton ? null : 5,
              top: showDeletButton ? 5 : null,
              right: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: showDeletButton ? 25 : 40,
                  height: showDeletButton ? 25 : 40,
                  color: Colors.black87,
                  child: showDeletButton
                      ? IconButton(
                          padding: const EdgeInsets.all(1),
                          onPressed: () {
                            Provider.of<HistoryProvider>(context, listen: false)
                                .removeFromHistory(widget.wallpaper);
                            Provider.of<HistoryStorageProvider>(context,
                                    listen: false)
                                .removeWallpaperFromHistory(widget.wallpaper);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ))
                      : FavouriteButton(wallpaper: widget.wallpaper),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              left: 2,
              child: isGif
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      color: Colors.black54,
                      child: const Text(
                        "GIF",
                        style: TextStyle(color: Colors.white, fontSize: 6),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
