import 'package:flutter/material.dart';
import 'package:wallpaper_app/enums/purity.dart';

enum WallhavenCategory { general, anime, people }

enum WallhavenSortingType {
  dateAdded,
  relevance,
  random,
  views,
  favourites,
  toplist
}

enum WallhavenTopRange {
  oneDay,
  threeDays,
  oneWeek,
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear
}

enum WallhavenAspectRatioType { portrait, landscape, all }

class WallhavenEnumToValue {
  static String ratio(WallhavenAspectRatioType ratioType) {
    switch (ratioType) {
      case WallhavenAspectRatioType.portrait:
        return "portrait";
      case WallhavenAspectRatioType.landscape:
        return "landscape";
      case WallhavenAspectRatioType.all:
        return "";
    }
  }

  static String category(List<WallhavenCategory> categories) {
    var categoryInt = 0;
    if (categories.contains(WallhavenCategory.general)) {
      categoryInt += 100;
    }
    if (categories.contains(WallhavenCategory.anime)) {
      categoryInt += 10;
    }
    if (categories.contains(WallhavenCategory.people)) {
      categoryInt += 1;
    }
    // Calculate number of leading zeroes
    final zeroCount = 3 - categoryInt.toString().length;

    return "${"0" * zeroCount}$categoryInt";
  }

  static String purity(List<PurityType> purities) {
    var purityInt = 0;
    if (purities.contains(PurityType.general)) {
      purityInt += 100;
    }
    if (purities.contains(PurityType.sketchy)) {
      purityInt += 10;
    }
    if (purities.contains(PurityType.adult)) {
      purityInt += 1;
    }
    // Calculate number of leading zeroes
    final zeroCount = 3 - purityInt.toString().length;

    return "${"0" * zeroCount}$purityInt";
  }

  static String sorting(WallhavenSortingType sortType) {
    switch (sortType) {
      case WallhavenSortingType.dateAdded:
        return "date_added";
      case WallhavenSortingType.relevance:
        return "relevance";
      case WallhavenSortingType.random:
        return "random";
      case WallhavenSortingType.views:
        return "views";
      case WallhavenSortingType.favourites:
        return "favourites";
      case WallhavenSortingType.toplist:
        return "toplist";
    }
  }

  static String topRange(WallhavenTopRange range) {
    switch (range) {
      case WallhavenTopRange.oneDay:
        return "1d";
      case WallhavenTopRange.threeDays:
        return "3d";
      case WallhavenTopRange.oneWeek:
        return "1w";
      case WallhavenTopRange.oneMonth:
        return "1M";
      case WallhavenTopRange.threeMonths:
        return "3M";
      case WallhavenTopRange.sixMonths:
        return "6M";
      case WallhavenTopRange.oneYear:
        return "1y";
    }
  }
}

class QueryProvider with ChangeNotifier {
  Map<String, dynamic> _query = {};

  Map<String, dynamic> get query {
    return {..._query};
  }

  void _setQuery(Map<String, dynamic> query) {
    if (_query == query) {
      return;
    }
    _query = query;
    notifyListeners();
  }

  void emptyQuery() {
    _query = {};
  }

  void checkAndSetWallhavenInitialQuery() {
    if (_query.isEmpty) {
      const categories = [
        WallhavenCategory.general,
        WallhavenCategory.anime,
        WallhavenCategory.people,
      ];
      const purities = [PurityType.general];
      const sorting = WallhavenSortingType.toplist;

      _query['categories'] = WallhavenEnumToValue.category(categories);
      _query['purity'] = WallhavenEnumToValue.purity(purities);
      _query['sorting'] = WallhavenEnumToValue.sorting(sorting);
    }
  }

  void setWallhavenQuery({
    String? tag1,
    String? tag2,
    bool includeTag1 = true,
    bool includeTag2 = true,
    String? wallpaperId,
    List<WallhavenCategory> categories = const [
      WallhavenCategory.general,
      WallhavenCategory.anime,
      WallhavenCategory.people,
    ],
    List<PurityType> purities = const [PurityType.general],
    WallhavenSortingType sorting = WallhavenSortingType.toplist,
    WallhavenTopRange topRange = WallhavenTopRange.oneMonth,
    String? color,
    WallhavenAspectRatioType ratio = WallhavenAspectRatioType.all,
    String? pageIndex,
  }) {
    Map<String, String> query = {};

    if (tag1 != null || tag2 != null || wallpaperId != null) {
      query['q'] = "";
    }

    // Tags and ID (Query Params)
    if (tag1 != null) {
      query['q'] = "${query['q']}${(includeTag1 ? "+" : "-")}$tag1}";
    }

    if (tag2 != null) {
      query['q'] = "${query['q']}${(includeTag2 ? "+" : "-")}$tag2}";
    }

    if (wallpaperId != null) {
      query['q'] = "like:$wallpaperId"; // * Generally accessible through image
    }

    // Mandatory Params
    query['categories'] = WallhavenEnumToValue.category(categories);
    query['purity'] = WallhavenEnumToValue.purity(purities);
    query['sorting'] = WallhavenEnumToValue.sorting(sorting);

    // Conditional Params
    if (color != null) {
      query['colors'] = color; // * Generally accessible through image
    }
    if (sorting == WallhavenSortingType.toplist) {
      query['topRange'] = WallhavenEnumToValue.topRange(topRange);
    }
    if (ratio != WallhavenAspectRatioType.all) {
      query['ratios'] = WallhavenEnumToValue.ratio(ratio);
    }
    if (pageIndex != null) {
      query['page'] = pageIndex;
    }
    _setQuery(query);
  }
}
