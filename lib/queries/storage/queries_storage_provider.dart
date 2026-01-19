import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:wallpaper_app/queries/models/query.dart';

class QueriesStorageProvider with ChangeNotifier {
  static const _savedKey = 'SavedQueries';
  static const _historyKey = 'HistoryQueries';

  List<Query> fetchSavedQueries() {
    final raw = localStorage.getItem(_savedKey);
    if (raw != null) {
      return List<Query>.from((json.decode(raw) as List)
          .map((rawQuery) => Query.fromJson(rawQuery)));
    } else {
      return [];
    }
  }

  List<Query> fetchHistoryQueries() {
    final raw = localStorage.getItem(_historyKey);
    if (raw != null) {
      return List<Query>.from((json.decode(raw) as List)
          .map((rawQuery) => Query.fromJson(rawQuery)));
    } else {
      return [];
    }
  }

  void addSavedQuery(Query query) {
    final raw = localStorage.getItem(_savedKey);
    if (raw == null) {
      localStorage.setItem(_savedKey, json.encode([query.toJson()]));
    } else {
      final prevList = json.decode(raw) as List;
      prevList.insert(0, query.toJson());
      localStorage.setItem(_savedKey, json.encode(prevList));
    }
  }

  void addHistoryQuery(Query query) {
    final raw = localStorage.getItem(_historyKey);
    if (raw == null) {
      localStorage.setItem(_historyKey, json.encode([query.toJson()]));
    } else {
      final prevList = json.decode(raw) as List;
      prevList.insert(0, query.toJson());
      localStorage.setItem(_historyKey, json.encode(prevList));
    }
  }

  void removeSavedQuery(Query query) {
    final raw = localStorage.getItem(_savedKey);
    final prevList = (json.decode(raw!) as List)
        .map((rawQuery) => Query.fromJson(rawQuery))
        .toList();
    prevList.remove(query);
    localStorage.setItem(_savedKey, json.encode(prevList));
  }

  void removeHistoryQuery(Query query) {
    final raw = localStorage.getItem(_historyKey);
    final prevList = (json.decode(raw!) as List)
        .map((rawQuery) => Query.fromJson(rawQuery))
        .toList();
    prevList.remove(query);
    localStorage.setItem(_historyKey, json.encode(prevList));
  }

  void clearHistoryQueries() {
    localStorage.removeItem(_historyKey);
  }

  void clearSavedQueries() {
    localStorage.removeItem(_savedKey);
  }
}
