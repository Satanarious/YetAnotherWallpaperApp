import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

class Query extends Equatable {
  final Sources source;
  final bool matureContent;
  final String? tag;
  final String? topic;
  final String? communityName;
  final String? subredditName;
  final WallhavenSortingType? wallhavenSortType;
  final WallhavenTopRange? wallhavenSortRange;
  final List<PurityType>? purities;
  final RedditSortType? redditSortType;
  final RedditSortRange? redditSortRange;
  final LemmySortType? lemmySortType;
  final String? tag1;
  final String? tag2;
  final bool? includeTag1;
  final bool? includeTag2;
  final List<WallhavenCategory>? categories;
  final WallhavenAspectRatioType? ratio;

  Query({
    required this.source,
    required this.matureContent,
    this.tag,
    this.topic,
    this.communityName,
    this.subredditName,
    this.wallhavenSortType,
    this.wallhavenSortRange,
    this.purities,
    this.redditSortType,
    this.redditSortRange,
    this.lemmySortType,
    this.tag1,
    this.tag2,
    this.includeTag1,
    this.includeTag2,
    this.categories,
    this.ratio,
  }) {
    switch (source) {
      case Sources.wallhaven:
        break;
      case Sources.reddit:
        break;
      case Sources.lemmy:
        break;
      case Sources.deviantArt:
        break;
      default:
        throw Exception("Source not supported yet!!");
    }
  }

  Query copyWith({
    ValueGetter<Sources?>? source,
    ValueGetter<bool?>? matureContent,
    ValueGetter<String?>? tag,
    ValueGetter<String?>? topic,
    ValueGetter<String?>? communityName,
    ValueGetter<String?>? subredditName,
    ValueGetter<WallhavenSortingType?>? wallhavenSortType,
    ValueGetter<WallhavenTopRange?>? wallhavenSortRange,
    ValueGetter<List<PurityType>?>? purities,
    ValueGetter<RedditSortType?>? redditSortType,
    ValueGetter<RedditSortRange?>? redditSortRange,
    ValueGetter<LemmySortType?>? lemmySortType,
    ValueGetter<String?>? tag1,
    ValueGetter<String?>? tag2,
    ValueGetter<bool?>? includeTag1,
    ValueGetter<bool?>? includeTag2,
    ValueGetter<List<WallhavenCategory>?>? categories,
    ValueGetter<WallhavenAspectRatioType?>? ratio,
  }) {
    return Query(
      source: this.source,
      matureContent: this.matureContent,
      tag: tag != null ? tag() : this.tag,
      topic: topic != null ? topic() : this.topic,
      communityName:
          communityName != null ? communityName() : this.communityName,
      subredditName:
          subredditName != null ? subredditName() : this.subredditName,
      wallhavenSortType: wallhavenSortType != null
          ? wallhavenSortType()
          : this.wallhavenSortType,
      wallhavenSortRange: wallhavenSortRange != null
          ? wallhavenSortRange()
          : this.wallhavenSortRange,
      purities: purities != null ? purities() : this.purities,
      redditSortType:
          redditSortType != null ? redditSortType() : this.redditSortType,
      redditSortRange:
          redditSortRange != null ? redditSortRange() : this.redditSortRange,
      lemmySortType:
          lemmySortType != null ? lemmySortType() : this.lemmySortType,
      tag1: tag1 != null ? tag1() : this.tag1,
      tag2: tag2 != null ? tag2() : this.tag2,
      includeTag1: includeTag1 != null ? includeTag1() : this.includeTag1,
      includeTag2: includeTag2 != null ? includeTag2() : this.includeTag2,
      categories: categories != null ? categories() : this.categories,
      ratio: ratio != null ? ratio() : this.ratio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source.index,
      'matureContent': matureContent,
      'tag': tag,
      'topic': topic,
      'communityName': communityName,
      'subredditName': subredditName,
      'wallhavenSortType': wallhavenSortType?.index,
      'wallhavenSortRange': wallhavenSortRange?.index,
      'purities': purities?.map((x) => x.index).toList(),
      'redditSortType': redditSortType?.index,
      'redditSortRange': redditSortRange?.index,
      'lemmySortType': lemmySortType?.index,
      'tag1': tag1,
      'tag2': tag2,
      'includeTag1': includeTag1,
      'includeTag2': includeTag2,
      'categories': categories?.map((x) => x.index).toList(),
      'ratio': ratio?.index,
    };
  }

  factory Query.fromMap(Map<String, dynamic> map) {
    return Query(
      source: Sources.values[map['source']],
      matureContent: map['matureContent'],
      tag: map['tag'],
      topic: map['topic'],
      communityName: map['communityName'],
      subredditName: map['subredditName'],
      wallhavenSortType: map['wallhavenSortType'] != null
          ? WallhavenSortingType.values[map['wallhavenSortType']]
          : null,
      wallhavenSortRange: map['wallhavenSortRange'] != null
          ? WallhavenTopRange.values[map['wallhavenSortRange']]
          : null,
      purities: map['purities'] != null
          ? List<PurityType>.from(
              map['purities']?.map((x) => PurityType.values[x]))
          : null,
      redditSortType: map['redditSortType'] != null
          ? RedditSortType.values[map['redditSortType']]
          : null,
      redditSortRange: map['redditSortRange'] != null
          ? RedditSortRange.values[map['redditSortRange']]
          : null,
      lemmySortType: map['lemmySortType'] != null
          ? LemmySortType.values[map['lemmySortType']]
          : null,
      tag1: map['tag1'],
      tag2: map['tag2'],
      includeTag1: map['includeTag1'],
      includeTag2: map['includeTag2'],
      categories: map['categories'] != null
          ? List<WallhavenCategory>.from(
              map['categories']?.map((x) => WallhavenCategory.values[x]))
          : null,
      ratio: map['ratio'] != null
          ? WallhavenAspectRatioType.values[map['ratio']]
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Query.fromJson(String source) => Query.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Query(source: $source, matureContent: $matureContent, tag: $tag, topic: $topic, communityName: $communityName, subredditName: $subredditName, wallhavenSortType: $wallhavenSortType, wallhavenSortRange: $wallhavenSortRange, purities: $purities, redditSortType: $redditSortType, redditSortRange: $redditSortRange, lemmySortType: $lemmySortType, tag1: $tag1, tag2: $tag2, includeTag1: $includeTag1, includeTag2: $includeTag2, categories: $categories, ratio: $ratio)';
  }

  @override
  List<Object?> get props {
    return [
      source,
      matureContent,
      tag,
      topic,
      communityName,
      subredditName,
      wallhavenSortType,
      wallhavenSortRange,
      purities,
      redditSortType,
      redditSortRange,
      lemmySortType,
      tag1,
      tag2,
      includeTag1,
      includeTag2,
      categories,
      ratio,
    ];
  }
}
