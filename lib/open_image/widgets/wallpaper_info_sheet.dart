import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/models/wallpaper.dart';
import 'package:wallpaper_app/common/models/wallpaper_list.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/open_image/widgets/label_widget.dart';
import 'package:wallpaper_app/open_image/widgets/link_widget.dart';
import 'package:wallpaper_app/open_image/widgets/more_like_this_widget.dart';
import 'package:wallpaper_app/open_image/widgets/tag_widget.dart';
import 'package:wallpaper_app/open_image/widgets/text_widget.dart';

class WallpaperInfoSheet extends StatefulWidget {
  const WallpaperInfoSheet(this.wallpaper, this.tags, this.moreLikeThis,
      {super.key});
  final Wallpaper wallpaper;
  final Future<List<String>>? tags;
  final Future<List<WallpaperList>> moreLikeThis;

  @override
  State<WallpaperInfoSheet> createState() => _WallpaperInfoSheetState();
}

class _WallpaperInfoSheetState extends State<WallpaperInfoSheet> {
  @override
  Widget build(BuildContext context) {
    final sourceInfo = widget.wallpaper.source == Sources.local
        ? {
            "name": "Local",
            "icon": Icons.folder,
            "colour": Colors.white,
          }
        : sourceMaps
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: double.infinity,
          color: Colors.black.withAlpha(100),
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
                        color: Colors.white,
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
                            child: TagWidget(
                              tags: widget.tags,
                              wallpaper: widget.wallpaper,
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
                    widget.wallpaper.colors != null &&
                            widget.wallpaper.colors!.isNotEmpty
                        ? TableRow(children: [
                            const TableCell(child: LabelWidget("Colours")),
                            TableCell(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: widget.wallpaper.colors!.map((color) {
                                  final r = int.parse(color.substring(1, 3),
                                      radix: 16);
                                  final g = int.parse(color.substring(3, 5),
                                      radix: 16);
                                  final b =
                                      int.parse(color.substring(5), radix: 16);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
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
                ),
                MoreLikeThisWidget(widget.wallpaper, widget.moreLikeThis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
