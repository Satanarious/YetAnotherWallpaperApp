import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/enums/file_type.dart';
import 'package:wallpaper_app/providers/history_provider.dart';
import 'package:wallpaper_app/widgets/favourite_button_widget.dart';

import '../models/wallpaper.dart';

class ImagePreviewGridItem extends StatefulWidget {
  const ImagePreviewGridItem({
    required this.wallpaper,
    required this.height,
    this.showDeletButton = false,
    super.key,
  });
  final Wallpaper wallpaper;
  final double height;
  final bool showDeletButton;

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
              bottom: widget.showDeletButton ? null : 5,
              top: widget.showDeletButton ? 5 : null,
              right: 5,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                      width: 30,
                      height: 30,
                      color: Colors.black87,
                      child: widget.showDeletButton
                          ? IconButton(
                              padding: const EdgeInsets.all(1),
                              onPressed: () => Provider.of<HistoryProvider>(
                                      context,
                                      listen: false)
                                  .removeFromHistory(widget.wallpaper),
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                                size: 20,
                              ))
                          : FavouriteButton(
                              wallpaper: widget.wallpaper,
                              size: 20,
                            ))),
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
