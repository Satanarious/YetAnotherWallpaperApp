import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/widgets/masonry_grid_widget.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

class WallpaperGridScreen extends StatelessWidget {
  const WallpaperGridScreen({super.key});

  Map<String, dynamic> initialFilters(BuildContext context, Sources source) {
    switch (source) {
      case Sources.wallhaven:
        return Provider.of<WallhavenFiltersStorageProvider>(context,
                listen: false)
            .fetch();
      case Sources.reddit:
        return Provider.of<RedditFiltersStorageProvider>(context, listen: false)
            .fetch();
      case Sources.lemmy:
        return Provider.of<LemmyFiltersStorageProvider>(context, listen: false)
            .fetch();
      case Sources.deviantArt:
        return Provider.of<DeviantArtFiltersStorageProvider>(context,
                listen: false)
            .fetch();
      default:
        throw Exception("Source not supported");
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final source = Provider.of<SourceProvider>(context).source;
    final queryProvider = Provider.of<QueryProvider>(context);
    final wallhavenApiKey =
        Provider.of<SettingsProvider>(context, listen: false).wallhavenApiKey;

    queryProvider.setInitialQuery(
        source, initialFilters(context, source), wallhavenApiKey);

    return FutureBuilder(
        future: wallpaperListProvider.loadMoreWallpapers(
          newSource: source,
          query: queryProvider.query,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return wallpaperListProvider.wallpapers.data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/empty.gif",
                          height: 200,
                          width: 300,
                          fit: BoxFit.fitWidth,
                        ),
                        const Text(
                          "Nothing Found!",
                          style: TextStyle(color: Colors.white54, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : const MasonryGridWidget();
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/loading.gif",
                    height: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Loading",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
