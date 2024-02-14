import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../widgets/wallpaper_action_widget.dart';
import '../providers/source_provider.dart';

class OpenImageScreen extends StatelessWidget {
  const OpenImageScreen({super.key});
  static const String routeName = "/OpenImageScreen";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final Wallpaper wallpaper =
        ModalRoute.of(context)!.settings.arguments as Wallpaper;
    final source = Provider.of<SourceProvider>(context, listen: false).source;

    return Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(children: [
          PhotoView(
            imageProvider: NetworkImage(wallpaper.url),
            initialScale: PhotoViewComputedScale.covered,
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

              if (progress == 0 && source == Sources.lemmy) {
                progress = null;
              }
              return Stack(
                children: [
                  Image.network(
                    wallpaper.thumbs.original,
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width,
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
                              value: progress,
                              color: Colors.black87,
                              strokeWidth: 6,
                            ),
                            CircularProgressIndicator(
                              value: progress,
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        wallpaper.fileSize == 0
                            ? Container()
                            : Text(
                                "$fileSizeDownloaded MB / $totalFileSize MB"),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: statusBarHeight + 10,
            left: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.black87,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          WallpaperActionsWidget(wallpaper)
        ]));
  }
}
