import 'package:flutter/material.dart';
import 'package:wallpaper_app/enums/purity.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

enum WallhavenCategory { general, anime, people }

enum WallhavenSortingType {
  dateAdded,
  favourites,
  random,
  relevance,
  toplist,
  views
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

enum RedditSortType { top, new_, hot, rising }

enum RedditSortRange { all, year, month, week, day, hour }

enum LemmySortType {
  active,
  new_,
  hot,
  old,
  topHour,
  topDay,
  topWeek,
  topMonth,
  topYear,
  topAll
}

class LemmyEnumToValue {
  static String sortType(LemmySortType sorting) {
    switch (sorting) {
      case LemmySortType.active:
        return "Active";
      case LemmySortType.hot:
        return "Hot";
      case LemmySortType.new_:
        return "New";
      case LemmySortType.old:
        return "Old";
      case LemmySortType.topHour:
        return "TopHour";
      case LemmySortType.topDay:
        return "TopDay";
      case LemmySortType.topWeek:
        return "TopWeek";
      case LemmySortType.topMonth:
        return "TopMonth";
      case LemmySortType.topYear:
        return "TopYear";
      case LemmySortType.topAll:
        return "TopAll";
    }
  }
}

class RedditEnumToValue {
  static String sortType(RedditSortType sorting) {
    switch (sorting) {
      case RedditSortType.top:
        return "top";
      case RedditSortType.new_:
        return "new";
      case RedditSortType.hot:
        return "hot";
      case RedditSortType.rising:
        return "rising";
    }
  }

  static String sortRange(RedditSortRange range) {
    switch (range) {
      case RedditSortRange.all:
        return "all";
      case RedditSortRange.year:
        return "year";
      case RedditSortRange.month:
        return "month";
      case RedditSortRange.week:
        return "week";
      case RedditSortRange.day:
        return "day";
      case RedditSortRange.hour:
        return "hour";
    }
  }
}

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
  bool blurNSFW = true;

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

  void setInitialQuery(Sources source, Map<String, dynamic> initialFilters) {
    if (_query.isEmpty) {
      switch (source) {
        case Sources.wallhaven:
          // Category conversion from List<bool> to List<WallhavenCategory>
          final categories = (initialFilters['category'] as List)
              .indexed
              .where((element) => element.$2 == true)
              .map((e) => WallhavenCategory.values[e.$1])
              .toList();
          // Purity conversion from List<bool> to List<PurityType>
          final purities = (initialFilters['purity'] as List)
              .indexed
              .where((element) => element.$2 == true)
              .map((e) => PurityType.values[e.$1])
              .toList();

          setWallhavenQuery(
            tag1: initialFilters['primary_tag'] == ""
                ? null
                : initialFilters['primary_tag'],
            tag2: initialFilters['secondary_tag'] == ""
                ? null
                : initialFilters['secondary_tag'],
            includeTag1: initialFilters['include_tag1'],
            includeTag2: initialFilters['include_tag2'],
            categories: categories,
            purities: purities,
            sorting: WallhavenSortingType.values[initialFilters['sort']],
            topRange: WallhavenTopRange.values[initialFilters['top_range']],
            ratio: WallhavenAspectRatioType.values[initialFilters['ratio']],
          );
          break;
        case Sources.reddit:
          setRedditQuery(
            subredditName: initialFilters['subreddit'],
            sortType: RedditSortType.values[initialFilters['sort_type']],
            sortRange: RedditSortRange.values[initialFilters['sort_range']],
          );
          break;
        case Sources.lemmy:
          setLemmyQuery(
            communityName: initialFilters['community'],
            sortType: LemmySortType.values[initialFilters['sort_type']],
          );
          break;
        case Sources.deviantArt:
          final page = initialFilters['page'] as int;
          setDeviantArtQuery(
            tag: initialFilters['tag'] == "" || page != 0
                ? null
                : initialFilters['tag'],
            topic: initialFilters['topic'] == "" || page != 1
                ? null
                : initialFilters['topic'],
            matureContent: initialFilters['mature_content'],
          );
        default:
          throw Exception("Source not supported yet!!");
      }
    }
  }

  void setDeviantArtQuery({
    String? tag,
    String? topic,
    bool matureContent = true,
  }) {
    Map<String, String> query = {};
    if (tag != null) {
      query['tag'] = tag;
      query['path'] = '/api/v1/oauth2/browse/tags';
    } else if (topic != null) {
      query['topic'] = topic;
      query['path'] = '/api/v1/oauth2/browse/topic';
    } else {
      query['tag'] = "superheroes";
    }
    query['with_session'] = 'false';
    query['mature_content'] = matureContent.toString();
    query['limit'] = '20';

    if (_query.isEmpty) {
      _query = query;
    } else {
      _setQuery(query);
    }
  }

  void setLemmyQuery({
    String communityName = "mobilewallpaper@lemmy.world",
    LemmySortType sortType = LemmySortType.topAll,
    int limit = 20,
  }) {
    Map<String, String> query = {};
    query['community_name'] = communityName;
    query['sort'] = LemmyEnumToValue.sortType(sortType);
    query['limit'] = limit.toString();

    if (_query.isEmpty) {
      _query = query;
    } else {
      _setQuery(query);
    }
  }

  void setRedditQuery({
    String subredditName = "Verticalwallpapers",
    RedditSortType sortType = RedditSortType.top,
    RedditSortRange sortRange = RedditSortRange.all,
  }) {
    Map<String, String> query = {};
    query['subreddit'] = subredditName;
    query['sort'] = RedditEnumToValue.sortType(sortType);
    query['t'] = RedditEnumToValue.sortRange(sortRange);
    query['raw_json'] = "1";

    if (_query.isEmpty) {
      _query = query;
    } else {
      _setQuery(query);
    }
  }

  void setWallhavenQuery({
    String? tag1,
    String? tag2,
    bool includeTag1 = true,
    bool includeTag2 = true,
    String? tagId,
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

    if (tag1 != null || tag2 != null || wallpaperId != null || tagId != null) {
      query['q'] = "";
    }

    // Tags and ID (Query Params)
    if (tag1 != null) {
      query['q'] = "${query['q']}${includeTag1 ? '+' : '-'}$tag1";
    }

    if (tag2 != null) {
      query['q'] =
          "${query['q']}${tag1 != null ? " " : ""}${includeTag2 ? "+" : "-"}$tag2";
    }

    if (wallpaperId != null) {
      query['q'] = "like:$wallpaperId"; // * Generally accessible through image
    }

    if (tagId != null) {
      query['q'] = "id:$tagId";
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

    if (_query.isEmpty) {
      _query = query;
    } else {
      _setQuery(query);
    }
  }
}
