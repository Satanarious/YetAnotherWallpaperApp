import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:wallpaper_app/providers/wallhaven_provider.dart';

import '../models/wallpaper.dart';

class WallpaperInfoSheet extends StatefulWidget {
  const WallpaperInfoSheet(this.wallpaper, {super.key});
  final Wallpaper wallpaper;

  @override
  State<WallpaperInfoSheet> createState() => _WallpaperInfoSheetState();
}

class _WallpaperInfoSheetState extends State<WallpaperInfoSheet> {
  @override
  Widget build(BuildContext context) {
    final sourceInfo = sourceMaps
        .firstWhere((source) => source['value'] == widget.wallpaper.source);
    final emptyRow = TableRow(children: [Container(), Container()]);
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final scrollHandlingProvider =
        Provider.of<ScrollHandlingProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: double.infinity,
        color: const Color.fromRGBO(50, 50, 50, 1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      height: 4,
                      width: 40,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              widget.wallpaper.source == Sources.wallhaven ||
                      widget.wallpaper.source == Sources.deviantArt
                  ? Center(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 100),
                        child: SizedBox(
                          width: double.infinity,
                          child: FutureBuilder(
                            future: widget.wallpaper.source == Sources.wallhaven
                                ? WallhavenProvider.getTags(widget.wallpaper.id)
                                : DeviantArtProvider()
                                    .getDeviationTags(widget.wallpaper.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Wrap(
                                  alignment: WrapAlignment.center,
                                  children: snapshot.data!
                                      .map(
                                        (tag) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              widget.wallpaper.source ==
                                                      Sources.wallhaven
                                                  ? queryProvider
                                                      .setWallhavenQuery(
                                                          tag1: tag)
                                                  : queryProvider
                                                      .setDeviantArtQuery(
                                                          tag: tag);
                                              wallpaperListProvider
                                                  .emptyWallpaperList();
                                              scrollHandlingProvider
                                                  .resetOffsets();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromRGBO(
                                                      50, 50, 50, 1),
                                                ),
                                                child: Text(
                                                  "#$tag",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              } else {
                                return Wrap(
                                  alignment: WrapAlignment.center,
                                  children: List.generate(8, (index) => index)
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Shimmer.fromColors(
                                              enabled: true,
                                              baseColor: Colors.grey,
                                              highlightColor: Colors.white70,
                                              child: Container(
                                                height: 38,
                                                width: 70,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  widget.wallpaper.title != null
                      ? TableRow(
                          children: [
                            const TableCell(child: LabelWidget("Title")),
                            TableCell(
                                child: TextWidget(widget.wallpaper.title!)),
                          ],
                        )
                      : emptyRow,
                  TableRow(
                    children: [
                      const TableCell(child: LabelWidget("Source")),
                      TableCell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              sourceInfo['icon'] as IconData,
                              color: sourceInfo['colour'] as Color,
                            ),
                            TextWidget(sourceInfo['name'] as String),
                          ],
                        ),
                      ),
                    ],
                  ),
                  widget.wallpaper.colors != null
                      ? TableRow(children: [
                          const TableCell(child: LabelWidget("Colours")),
                          TableCell(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.wallpaper.colors!.map((color) {
                                final r =
                                    int.parse(color.substring(1, 3), radix: 16);
                                final g =
                                    int.parse(color.substring(3, 5), radix: 16);
                                final b =
                                    int.parse(color.substring(5), radix: 16);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: GestureDetector(
                                    onTap: () {
                                      queryProvider.setWallhavenQuery(
                                          color: color.substring(1));
                                      wallpaperListProvider
                                          .emptyWallpaperList();
                                      scrollHandlingProvider.resetOffsets();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            Color.fromRGBO(r, g, b, 1),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ])
                      : emptyRow,
                  widget.wallpaper.postUrl != null &&
                          widget.wallpaper.postUrl!.isNotEmpty
                      ? TableRow(children: [
                          const TableCell(child: LabelWidget("Post URL")),
                          TableCell(
                              child: LinkWidget(widget.wallpaper.postUrl!)),
                        ])
                      : emptyRow,
                  widget.wallpaper.url.isNotEmpty
                      ? TableRow(children: [
                          const TableCell(child: LabelWidget("Image URL")),
                          TableCell(child: LinkWidget(widget.wallpaper.url)),
                        ])
                      : emptyRow,
                  widget.wallpaper.author != null
                      ? TableRow(children: [
                          const TableCell(child: LabelWidget("Uploader")),
                          TableCell(
                              child: TextWidget(widget.wallpaper.author!)),
                        ])
                      : emptyRow,
                  widget.wallpaper.dimensionX != null &&
                          widget.wallpaper.dimensionX! > 0
                      ? TableRow(children: [
                          const TableCell(child: LabelWidget("Resolution")),
                          TableCell(
                              child: TextWidget(
                                  "${widget.wallpaper.dimensionX} x ${widget.wallpaper.dimensionY}")),
                        ])
                      : emptyRow,
                  widget.wallpaper.fileSize > 0
                      ? TableRow(children: [
                          const TableCell(child: LabelWidget("Size")),
                          TableCell(
                              child: TextWidget(
                                  "${(widget.wallpaper.fileSize / 1048567).toStringAsFixed(2)} MB")),
                        ])
                      : emptyRow,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LabelWidget extends StatelessWidget {
  const LabelWidget(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class LinkWidget extends StatelessWidget {
  const LinkWidget(this.link, {super.key});
  final String link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async => launchUrlString(link),
        child: Text(
          link,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            decorationStyle: TextDecorationStyle.solid,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
