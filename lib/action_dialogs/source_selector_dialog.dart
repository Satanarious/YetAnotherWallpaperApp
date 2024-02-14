import 'package:flutter/material.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:provider/provider.dart';

class SourceSelectorDialog extends StatelessWidget {
  const SourceSelectorDialog({super.key});
  static const sources = [
    {
      "name": "Reddit",
      "icon": Icons.reddit,
      "color": Colors.deepOrange,
      "value": Sources.reddit,
    },
    {
      "name": "Wallpaper Haven",
      "icon": Icons.landscape,
      "color": Colors.purple,
      "value": Sources.wallhaven,
    },
    {
      "name": "Lemmy",
      "icon": Icons.book,
      "color": Colors.green,
      "value": Sources.lemmy,
    },
    {
      "name": "OWalls",
      "icon": Icons.air,
      "color": Colors.red,
      "value": Sources.oWalls,
    },
    {
      "name": "Google Pixel",
      "icon": Icons.grid_view_rounded,
      "color": Colors.pink,
      "value": Sources.googlePixel,
    },
    {
      "name": "Bing Daily",
      "icon": Icons.search,
      "color": Colors.blue,
      "value": Sources.bingDaily,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final sourceProvider = Provider.of<SourceProvider>(context, listen: false);
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);

    return Dialog(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: const Color.fromRGBO(50, 50, 50, 1),
        height: height * 0.5,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: sources.map((source) {
            final isSelected = source['value'] == sourceProvider.source;
            return GestureDetector(
              onTap: () {
                sourceProvider.changeSource(source['value'] as Sources);
                queryProvider.emptyQuery();
                Navigator.of(context).pop();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: isSelected ? Colors.white : null,
                  padding: const EdgeInsets.all(0.2),
                  child: Card(
                      color: source['color'] as Color,
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
