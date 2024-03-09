import 'package:flutter/material.dart';

enum Sources {
  wallhaven,
  reddit,
  deviantArt,
  oWalls,
  googlePixel,
  lemmy,
  bingDaily,
}

const sourceMaps = [
  {
    "name": "Reddit",
    "icon": Icons.reddit,
    "colour": Colors.deepOrange,
    "value": Sources.reddit,
  },
  {
    "name": "Wallhaven",
    "icon": Icons.landscape,
    "colour": Colors.purple,
    "value": Sources.wallhaven,
  },
  {
    "name": "Lemmy",
    "icon": Icons.pest_control_rodent,
    "colour": Colors.amber,
    "value": Sources.lemmy,
  },
  {
    "name": "Deviant Art",
    "icon": Icons.attractions_outlined,
    "colour": Color.fromRGBO(0, 229, 155, 1),
    "value": Sources.deviantArt,
  },
  {
    "name": "OWalls",
    "icon": Icons.air,
    "colour": Colors.red,
    "value": Sources.oWalls,
  },
  {
    "name": "Google Pixel",
    "icon": Icons.grid_view_rounded,
    "colour": Colors.pink,
    "value": Sources.googlePixel,
  },
  {
    "name": "Bing Daily",
    "icon": Icons.search,
    "colour": Colors.blue,
    "value": Sources.bingDaily,
  },
];

class SourceProvider with ChangeNotifier {
  Sources source = Sources.deviantArt;

  void changeSource(Sources newSource) {
    if (source == newSource) {
      return;
    }
    source = newSource;
    notifyListeners();
  }
}
