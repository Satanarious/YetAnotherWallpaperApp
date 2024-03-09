import 'package:flutter/material.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:provider/provider.dart';

class SourceSelectorDialog extends StatelessWidget {
  const SourceSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sourceProvider = Provider.of<SourceProvider>(context, listen: false);
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final isVertical = size.height > size.width;

    return Dialog(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: const Color.fromRGBO(50, 50, 50, 1),
        height: size.height * 0.4,
        width: size.width * 0.7,
        child: ListView(
          scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
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
                  width: isVertical ? double.infinity : 120,
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
