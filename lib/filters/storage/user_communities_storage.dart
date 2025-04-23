import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class RedditUserCommunitiesStorage with ChangeNotifier {
  static const _key = 'reddit_user_communities';

  List fetch() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return json.decode(raw);
    } else {
      return [];
    }
  }

  void update(List userCommunities) {
    localStorage.setItem(_key, json.encode(userCommunities));
    notifyListeners();
  }
}

class LemmyUserCommunitiesStorage with ChangeNotifier {
  static const _key = 'lemmy_user_communities';

  List fetch() {
    final raw = localStorage.getItem(_key);
    if (raw != null) {
      return json.decode(raw);
    } else {
      return [];
    }
  }

  void update(List userCommunities) {
    localStorage.setItem(_key, json.encode(userCommunities));
    notifyListeners();
  }
}
