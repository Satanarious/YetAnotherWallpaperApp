import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/widgets/wallpaper_info_sheet.dart';
import '../providers/providers.dart';
import '../models/wallpaper.dart';
import 'favourite_button_widget.dart';

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
    final buttons = <ActionWidget>[
      ActionWidget(
        label: "Info",
        child: IconButton(
          onPressed: () => showBottomSheet(
            context: context,
            builder: (context) => WallpaperInfoSheet(widget.wallpaper),
          ),
          icon: const Icon(
            Icons.info,
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
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      ActionWidget(
        label: "Set",
        child: IconButton(
            onPressed: () => null,
            icon: const Icon(
              Icons.landscape,
              size: 30,
              color: Colors.white,
            )),
      ),
      ActionWidget(label: "Download", child: DownloadButton(widget.wallpaper)),
      ActionWidget(
          label: "Favourite",
          child: FavouriteButton(
            wallpaper: widget.wallpaper,
            size: 30,
          )),
    ];
    late List<Widget> validButtons;
    if (source == Sources.wallhaven) {
      validButtons = buttons;
    } else {
      final list = List<Widget>.from(buttons);
      list.removeAt(1);
      validButtons = list;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      color: Colors.black.withAlpha(210),
      height: 80,
      child: Column(
        children: [
          // const Icon(
          //   Icons.keyboard_arrow_down_sharp,
          //   color: Colors.white,
          // ),
          // source == Sources.wallhaven
          //     ? Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 15),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           mainAxisSize: MainAxisSize.max,
          //           children: widget.wallpaper.colors!.map((color) {
          //             final r =
          //                 int.parse(color.substring(1, 3), radix: 16);
          //             final g =
          //                 int.parse(color.substring(3, 5), radix: 16);
          //             final b =
          //                 int.parse(color.substring(5), radix: 16);
          //             return GestureDetector(
          //               onTap: () {
          //                 queryProvider.setWallhavenQuery(
          //                     color: color.substring(1));
          //                 wallpaperListProvider.emptyWallpaperList();
          //                 scrollHandlingProvider.resetOffsets();
          //                 Navigator.of(context).pop();
          //               },
          //               child: CircleAvatar(
          //                 radius: 17,
          //                 backgroundColor: Colors.white,
          //                 child: CircleAvatar(
          //                   radius: 15,
          //                   backgroundColor:
          //                       Color.fromRGBO(r, g, b, 1),
          //                 ),
          //               ),
          //             );
          //           }).toList(),
          //         ),
          //       )
          //     : Expanded(
          //         child: Padding(
          //           padding:
          //               const EdgeInsets.symmetric(horizontal: 5),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment:
          //                 MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Text(
          //                 widget.wallpaper.title!,
          //                 textAlign: TextAlign.center,
          //                 style: const TextStyle(
          //                   color: Color.fromRGBO(255, 255, 255, 1),
          //                   fontSize: 13,
          //                 ),
          //                 maxLines: 2,
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //               Row(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment:
          //                     MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   SizedBox(
          //                     width: 100,
          //                     child: Text(
          //                       "${widget.wallpaper.author}",
          //                       textAlign: TextAlign.right,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: const TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 13,
          //                       ),
          //                     ),
          //                   ),
          //                   const Text(
          //                     "  |  ",
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 13,
          //                     ),
          //                   ),
          //                   GestureDetector(
          //                     onTap: () => launchUrlString(
          //                         widget.wallpaper.postUrl!),
          //                     child: const SizedBox(
          //                       width: 110,
          //                       child: Text(
          //                         "Open in Browser",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.cyan,
          //                           fontSize: 13,
          //                         ),
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: validButtons,
          ),
        ],
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
                      Icons.check,
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
                  Icons.download,
                  size: 30,
                  color: Colors.white,
                ),
              );
  }
}
