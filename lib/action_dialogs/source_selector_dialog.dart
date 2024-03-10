import 'package:flutter/material.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:provider/provider.dart';

class SourceSelectorDialog extends StatelessWidget {
  const SourceSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final sourceProvider = Provider.of<SourceProvider>(context, listen: false);
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);

    return Dialog(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: const Color.fromRGBO(50, 50, 50, 1),
        height: orientation == Orientation.portrait ? 400 : 200,
        width: orientation == Orientation.portrait ? 300 : 600,
        child: ListView(
          scrollDirection: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  child: Card(
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
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                      )),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ));
  }
}
