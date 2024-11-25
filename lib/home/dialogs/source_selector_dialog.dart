import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';

class SourceSelectorDialog extends StatefulWidget {
  const SourceSelectorDialog({super.key});

  @override
  State<SourceSelectorDialog> createState() => _SourceSelectorDialogState();
}

class _SourceSelectorDialogState extends State<SourceSelectorDialog> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll animation after list builds
      _scrollController.jumpTo(100);
      _scrollController.animateTo(
        -100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final sourceProvider = Provider.of<SourceProvider>(context, listen: false);
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);

    return Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: SizedBox(
              height: orientation == Orientation.portrait ? 400 : 200,
              width: orientation == Orientation.portrait ? 300 : 600,
              child: ListView(
                controller: _scrollController,
                scrollDirection: orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                children: sourceMaps.map((source) {
                  final isSelected = source['value'] == sourceProvider.source;
                  return GestureDetector(
                    onTap: () {
                      queryProvider.emptyQuery();
                      wallpaperListProvider.emptyWallpaperList();
                      sourceProvider.changeSource(source['value'] as Sources);
                      Navigator.of(context).pop();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: isSelected ? Colors.white : null,
                        width: orientation == Orientation.portrait
                            ? double.infinity
                            : 120,
                        padding: const EdgeInsets.all(0.2),
                        child: Stack(
                          children: [
                            Card(
                                color: source['colour'] as Color,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        source['icon'] as IconData,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        source['name'] as String,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  )),
                                )),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.white10,
                                    Colors.white12,
                                    Colors.white24,
                                    Colors.white30,
                                    Colors.white38,
                                    Colors.white54,
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ));
  }
}
