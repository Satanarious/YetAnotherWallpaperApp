import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:wallpaper_app/widgets/masonry_grid_widget.dart';

class WallpaperGridScreen extends StatelessWidget {
  const WallpaperGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final source = Provider.of<SourceProvider>(context).source;
    final queryProvider = Provider.of<QueryProvider>(context);
    queryProvider.setInitialQuery(source);

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
