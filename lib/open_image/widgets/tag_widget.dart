import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/common/models/wallpaper.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/home/screens/home_screen.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.tags,
    required this.wallpaper,
  });

  final Future<List<String>>? tags;
  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final scrollHandlingProvider =
        Provider.of<ScrollHandlingProvider>(context, listen: false);
    return FutureBuilder(
      future: tags,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final trimmedTags = snapshot.data!.length < 11
              ? snapshot.data!
              : snapshot.data!.sublist(0, 9);
          return Wrap(
            alignment: WrapAlignment.center,
            children: trimmedTags
                .map(
                  (tag) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        if (wallpaper.source == Sources.wallhaven) {
                          queryProvider.setWallhavenQuery(tag1: tag);
                          Provider.of<FiltersStorageProvider>(context,
                                  listen: false)
                              .updateFilters(
                            source: Sources.wallhaven,
                            matureContent: false,
                            categories: WallhavenCategory.values,
                            includeTag1: true,
                            includeTag2: true,
                            tag1: tag,
                            purities: [PurityType.general, PurityType.sketchy],
                            ratio: WallhavenAspectRatioType.all,
                            wallhavenSortType: WallhavenSortingType.toplist,
                            wallhavenSortRange: WallhavenTopRange.oneMonth,
                            wallhavenFiltersStorageProvider:
                                Provider.of<WallhavenFiltersStorageProvider>(
                                    context,
                                    listen: false),
                          );
                        } else {
                          queryProvider.setDeviantArtQuery(tag: tag);
                          Provider.of<FiltersStorageProvider>(context,
                                  listen: false)
                              .updateFilters(
                            source: Sources.deviantArt,
                            matureContent: false,
                            tag: tag,
                            deviantArtFiltersStorageProvider:
                                Provider.of<DeviantArtFiltersStorageProvider>(
                                    context,
                                    listen: false),
                          );
                        }
                        wallpaperListProvider.emptyWallpaperList();
                        scrollHandlingProvider.resetOffsets();
                        Navigator.of(context).popUntil((route) {
                          return route.settings.name == HomeScreen.routeName ||
                              route.settings.name == null;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withAlpha(50),
                          ),
                          child: Text(
                            "#$tag",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Shimmer.fromColors(
                        enabled: true,
                        baseColor: Colors.grey.withAlpha(80),
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
    );
  }
}
