import 'dart:ui';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/common/models/wallpaper.dart';
import 'package:wallpaper_app/favourites/widgets/favourite_button_widget.dart';
import 'package:wallpaper_app/home/providers/deviant_art_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallhaven_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/open_image/widgets/wallpaper_info_sheet.dart';

class WallpaperActionsWidget extends StatefulWidget {
  const WallpaperActionsWidget(this.wallpaper, {super.key});
  final Wallpaper wallpaper;

  @override
  State<WallpaperActionsWidget> createState() => _WallpaperActionsWidgetState();
}

class _WallpaperActionsWidgetState extends State<WallpaperActionsWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    final scrollHandlingProvider =
        Provider.of<ScrollHandlingProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final tags = widget.wallpaper.source == Sources.wallhaven
        ? WallhavenProvider.getTags(widget.wallpaper.id)
        : widget.wallpaper.source == Sources.deviantArt
            ? DeviantArtProvider().getDeviationTags(widget.wallpaper.id)
            : null;
    final moreLikeThis =
        DeviantArtProvider().getDeviationMoreLikeThis(widget.wallpaper.id);
    final buttons = <ActionWidget>[
      ActionWidget(
        label: "Info",
        child: IconButton(
          onPressed: () => showBottomSheet(
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(
              maxHeight: size.height * 0.9,
              maxWidth: 500,
            ),
            context: context,
            builder: (context) =>
                WallpaperInfoSheet(widget.wallpaper, tags, moreLikeThis),
          ),
          icon: const Icon(
            IconlyLight.info_circle,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      ActionWidget(
        label: "Similar",
        child: IconButton(
          onPressed: () {
            queryProvider.setWallhavenQuery(wallpaperId: widget.wallpaper.id);
            wallpaperListProvider.emptyWallpaperList();

            scrollHandlingProvider.resetOffsets();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconlyLight.search,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      ActionWidget(
        label: "Set",
        child: IconButton(
            onPressed: () async {
              bool needSetting = false;

              // Show warning dialog
              await AnimatedPopInDialog.showCustomized(
                context: context,
                title: "Warning",
                icon: Icons.warning_amber_rounded,
                description:
                    "Setting the wallpaper might reset the app on some android versions and you might lose any progress in the wallpaper feed. To avoid this, download the wallpaper and set it manually.",
                buttonNameAndFunctionMap: {
                  "Cancel": Navigator.of(context).pop,
                  "Continue": () {
                    needSetting = true;
                    Navigator.of(context).pop();
                  }
                },
              );

              if (!needSetting) {
                return;
              }
              // Set wallpaper
              final imageFile = await DefaultCacheManager()
                  .getSingleFile(widget.wallpaper.url);
              final imagePath = imageFile.path;
              await AsyncWallpaper.setWallpaperFromFileNative(
                filePath: imagePath,
                goToHome: true,
              );
            },
            icon: const Icon(
              IconlyLight.image,
              size: 30,
              color: Colors.white,
            )),
      ),
      ActionWidget(label: "Download", child: DownloadButton(widget.wallpaper)),
      ActionWidget(
        label: "Favourite",
        child: FavouriteButton(wallpaper: widget.wallpaper),
      ),
    ];
    late List<Widget> validButtons;
    if (source == Sources.wallhaven) {
      validButtons = buttons;
    } else {
      final list = List<Widget>.from(buttons);
      list.removeAt(1);
      validButtons = list;
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          color: Colors.black.withAlpha(50),
          height: 80,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: validButtons,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionWidget extends StatelessWidget {
  const ActionWidget({required this.label, required this.child, super.key});

  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class DownloadButton extends StatefulWidget {
  const DownloadButton(
    this.wallpaper, {
    super.key,
  });

  final Wallpaper wallpaper;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton>
    with SingleTickerProviderStateMixin {
  var isDownloading = false;
  var downloadingComplete = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isDownloading
        ? Padding(
            padding: const EdgeInsets.all(6),
            child: Transform.scale(
                scale: 0.7,
                child: const CircularProgressIndicator(color: Colors.white)),
          )
        : downloadingComplete
            ? Padding(
                padding: const EdgeInsets.all(9),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform.scale(
                    scale: _controller.value,
                    child: const Icon(
                      Icons.check_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : IconButton(
                onPressed: () async {
                  setState(() {
                    isDownloading = true;
                  });
                  await widget.wallpaper.downloadToGallery();
                  setState(() {
                    isDownloading = false;
                    downloadingComplete = true;
                    _controller.forward();
                  });
                },
                tooltip: "Download",
                icon: const Icon(
                  IconlyLight.download,
                  size: 30,
                  color: Colors.white,
                ),
              );
  }
}
