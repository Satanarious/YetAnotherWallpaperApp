import 'package:flutter/material.dart';

class FloatingButtonProvider with ChangeNotifier {
  dynamic buttonAction;
  IconData buttonIcon = Icons.filter_alt;

  void indexChanged(int index) {
    if (index == 1) {
      buttonIcon = Icons.add;
    } else if (index > 1) {
      buttonIcon = Icons.filter_alt;
    } else {
      buttonIcon = Icons.settings;
    }
    notifyListeners();
  }
}
