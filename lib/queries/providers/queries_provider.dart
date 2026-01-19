import 'package:flutter/material.dart';
import 'package:wallpaper_app/queries/models/query.dart';

class QueriesProvider with ChangeNotifier {
  List<Query> savedQueries = [];
  List<Query> historyQueries = [];
  final historyLimit = 100;

  void addSavedQuery(Query query) {
    savedQueries.insert(0, query);
    notifyListeners();
  }

  void removeSavedQuery(Query query) {
    savedQueries.remove(query);
    notifyListeners();
  }

  void clearSavedQueries() {
    savedQueries.clear();
    notifyListeners();
  }

  void addHistoryQuery(Query query) {
    if (historyQueries.length == historyLimit) {
      historyQueries.removeLast();
    }

    historyQueries.insert(0, query);
    notifyListeners();
  }

  void removeHistoryQuery(Query query) {
    historyQueries.remove(query);
    notifyListeners();
  }

  void clearHistoryQueries() {
    historyQueries.clear();
    notifyListeners();
  }
}
