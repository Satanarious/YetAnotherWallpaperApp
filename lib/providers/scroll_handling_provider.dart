import 'package:flutter/material.dart';

class ScrollHandlingProvider with ChangeNotifier {
  double _scrollLastOffset = 0;
  double _scrollCurrentOffset = 0;

  double pillOffset = 20;
  double pillHeight = 60;

  void setScrollOffset(double scrollNewOffset) {
    _scrollCurrentOffset = scrollNewOffset;

    if (_scrollLastOffset < _scrollCurrentOffset) {
      if (pillOffset == -80) {
        _scrollLastOffset = _scrollCurrentOffset;
        return;
      }
      pillOffset -= 10;
    } else {
      if (pillOffset == 20) {
        _scrollLastOffset = _scrollCurrentOffset;
        return;
      }
      pillOffset += 10;
    }
    _scrollLastOffset = _scrollCurrentOffset;
    notifyListeners();
  }

  void resetOffsets() {
    if (pillOffset != 20) {
      pillOffset = 20;
      notifyListeners();
    }
  }
}
