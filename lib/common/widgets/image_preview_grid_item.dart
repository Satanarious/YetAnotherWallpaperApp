import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/models/wallpaper.dart';
import 'package:wallpaper_app/common/enums/file_type.dart' as ft;
import 'package:wallpaper_app/favourites/widgets/favourite_button_widget.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/screens/history_screen.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/widgets/image_pop_in_animation_widget.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

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

class _ImagePreviewGridItemState extends State<ImagePreviewGridItem> {
  @override
  Widget build(BuildContext context) {
    final showDeletButton =
        ModalRoute.of(context)!.settings.name == HistoryScreen.routeName;
    final isGif = widget.wallpaper.fileType == ft.FileType.gif;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final roundedCorners = settingsProvider.roundedCorners;

    return ImagePopInAnimation(
      ClipRRect(
        borderRadius: BorderRadius.circular(roundedCorners ? 10 : 0),
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              height: widget.height,
              width: double.infinity,
              child: widget.wallpaper.source == Sources.local
                  ? Image.file(File(widget.wallpaper.localPath!),
                      fit: BoxFit.cover)
                  : CachedNetworkImage(
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
                              Image.network(
                                widget.wallpaper.url,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
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
                                    const Center(
                                        child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                )),
                              )),
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
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: showDeletButton ? 25 : 40,
                    height: showDeletButton ? 25 : 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                    ),
                    child: showDeletButton
                        ? IconButton(
                            padding: const EdgeInsets.all(1),
                            onPressed: () {
                              Provider.of<HistoryProvider>(context,
                                      listen: false)
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
                        style: TextStyle(color: Colors.white, fontSize: 8),
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
