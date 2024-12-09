import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class RedditFiltersStorageProvider with ChangeNotifier {
  static const _key = 'reddit_filters';

  Map<String, dynamic> fetch() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return json.decode(raw);
    } else {
      return {
        "subreddit": "Verticalwallpapers",
        "sort_type": 0,
        "sort_range": 0,
      };
    }
  }

  void update(
      {required String subreddit, int sortType = 0, int sortRange = 0}) {
    final filters = {
      "subreddit": subreddit,
      "sort_type": sortType,
      "sort_range": sortRange,
    };
    localStorage.setItem(_key, json.encode(filters));
  }
}

class WallhavenFiltersStorageProvider with ChangeNotifier {
  static const _key = 'wallhaven_filters';

  Map<String, dynamic> fetch() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return json.decode(raw);
    } else {
      return {
        "primary_tag": "",
        "secondary_tag": "",
        "include_tag1": true,
        "include_tag2": true,
        "category": [true, true, true],
        "purity": [true, false, false],
        "sort": 4,
        "top_range": 3,
        "ratio": 2,
      };
    }
  }

  void update({
    String primaryTag = "",
    String secondaryTag = "",
    bool includeTag1 = true,
    bool includeTag2 = true,
    List<bool> category = const [true, true, true],
    List<bool> purity = const [true, false, false],
    int sort = 4,
    int topRange = 3,
    int ratio = 2,
  }) {
    final filters = {
      "primary_tag": primaryTag,
      "secondary_tag": secondaryTag,
      "include_tag1": includeTag1,
      "include_tag2": includeTag2,
      "category": category,
      "purity": purity,
      "sort": sort,
      "top_range": topRange,
      "ratio": ratio,
    };
    localStorage.setItem(_key, json.encode(filters));
  }
}

class LemmyFiltersStorageProvider with ChangeNotifier {
  static const _key = 'lemmy_filters';

  Map<String, dynamic> fetch() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return json.decode(raw);
    } else {
      return {
        "community": "mobilewallpaper@lemmy.world",
        "sort_type": 9,
      };
    }
  }

  void update({required String community, int sortType = 9}) {
    final filters = {
      "community": community,
      "sort_type": sortType,
    };
    localStorage.setItem(_key, json.encode(filters));
  }
}

class DeviantArtFiltersStorageProvider with ChangeNotifier {
  static const _key = 'deviant_art_filters';
  static const _allTopicsKey = '$_key:all_topics';

  Map<String, dynamic> fetch() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return json.decode(raw);
    } else {
      return {
        "query": "",
        "topic": "",
        "tag": "",
        "page": 0,
        "mature_content": false,
        "is_popular": true,
      };
    }
  }

  void update({
    String query = "",
    String topic = "",
    String tag = "",
    required int page,
    required bool matureContent,
    bool isPopular = true,
  }) {
    final filters = {
      "query": query,
      "topic": topic,
      "tag": tag,
      "page": page,
      "mature_content": matureContent,
      "is_popular": isPopular,
    };
    localStorage.setItem(_key, json.encode(filters));
  }

  List<Map<String, dynamic>>? getAllTopics() {
    final raw = localStorage.getItem(_allTopicsKey);
    if (raw != null) {
      final decodedList = json.decode(raw) as List<dynamic>;
      final finalList = decodedList.cast<Map<String, dynamic>>();
      return finalList;
    } else {
      return null;
    }
  }

  void updateAllTopics(List<Map<String, dynamic>> topics) async {
    localStorage.setItem(_allTopicsKey, json.encode(topics));
  }
}
