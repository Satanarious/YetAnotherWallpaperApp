import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/common/enums/file_type.dart' as ft;
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/open_image/widgets/wallpaper_action_widget.dart';

class OpenImageScreen extends StatefulWidget {
  const OpenImageScreen({super.key});
  static const String routeName = "/OpenImageScreen";

  @override
  State<OpenImageScreen> createState() => _OpenImageScreenState();
}

class _OpenImageScreenState extends State<OpenImageScreen> {
  var isInteracting = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final Wallpaper wallpaper =
        ModalRoute.of(context)!.settings.arguments as Wallpaper;
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    var progressString = '';

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: wallpaper.source == Sources.local
                ? Image.file(File(wallpaper.localPath!)).image
                : NetworkImage(wallpaper.url),
            initialScale: PhotoViewComputedScale.covered,
            onTapDown: (context, details, controllerValue) => setState(() {
              isInteracting = !isInteracting;
            }),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text(
                "Error loading image!",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            loadingBuilder: (context, loadingProgress) {
              double? progress = loadingProgress?.expectedTotalBytes != null
                  ? loadingProgress!.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : 0; // Calculate current progress based on bytes loaded vs total bytes
              final double fileSizeDownloaded = double.parse(
                  ((wallpaper.fileSize / 1048567) * progress)
                      .toStringAsFixed(2));
              final double totalFileSize = double.parse(
                  (wallpaper.fileSize / 1048567).toStringAsFixed(2));

              if (progress == 0 && source != Sources.wallhaven) {
                progress = null;
                progressString = "Fetching...";
              } else {
                progressString = wallpaper.fileSize != 0
                    ? "$fileSizeDownloaded MB / $totalFileSize MB"
                    : "Loading...";
              }
              return Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: wallpaper.fileType == ft.FileType.gif
                        ? wallpaper.thumbs.large
                        : wallpaper.thumbs.original,
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width,
                    errorWidget: (context, url, error) => Container(),
                  ),
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircularProgressIndicator(
                              strokeCap: StrokeCap.round,
                              value: progress,
                              color: Colors.black.withAlpha(210),
                              strokeWidth: 6,
                            ),
                            CircularProgressIndicator(
                              strokeCap: StrokeCap.round,
                              value: progress,
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(progressString),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          AnimatedPositioned(
            curve: Curves.fastEaseInToSlowEaseOut,
            duration: const Duration(milliseconds: 400),
            top: statusBarHeight + 10,
            left: isInteracting ? -60 : 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withAlpha(50),
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        IconlyLight.arrow_left_circle,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
              curve: Curves.fastEaseInToSlowEaseOut,
              duration: const Duration(milliseconds: 400),
              left: 0,
              right: 0,
              bottom: isInteracting ? -80 : 0,
              child: WallpaperActionsWidget(wallpaper)),
        ],
      ),
    );
  }
}
