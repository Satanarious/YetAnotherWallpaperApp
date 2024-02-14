import 'package:flutter/material.dart';

enum Sources {
  wallhaven,
  reddit,
  oWalls,
  googlePixel,
  lemmy,
  bingDaily,
}

class SourceProvider with ChangeNotifier {
  Sources source = Sources.wallhaven;

  void changeSource(Sources newSource) {
    if (source == newSource) {
      return;
    }
    source = newSource;
    notifyListeners();
  }
}
