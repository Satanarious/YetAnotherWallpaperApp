import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SettingsStorageProvider with ChangeNotifier {
  static const String settingsKey = 'Settings';

  void saveSettings(String settings) {
    localStorage.setItem(settingsKey, settings);
  }

  Map<String, dynamic> fetchSettings() {
    final raw = localStorage.getItem(settingsKey);
    if (raw != null) {
      return jsonDecode(raw);
    } else {
      return {};
    }
  }
}
