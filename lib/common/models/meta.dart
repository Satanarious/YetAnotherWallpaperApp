import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Meta extends Equatable {
  const Meta({
    this.currentPage,
    this.lastPage,
    required this.perPage,
    this.after,
    this.hasMore,
    this.offset,
  });

  factory Meta.fromWallhavenJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      perPage: json['per_page'].runtimeType == String
          ? int.parse(json['per_page'])
          : json['per_page'],
      lastPage: json['last_page'],
    );
  }

  factory Meta.fromRedditJson(Map<String, dynamic> json) => Meta(
        after: json['after'],
        perPage: json['dist'] as int,
      );
  factory Meta.fromLemmyJson(Map<String, dynamic> json) => Meta(
        after: json['next_page'],
        perPage: (json['posts'] as List<dynamic>).length,
      );
  factory Meta.fromDeviantArtJson(Map<String, dynamic> json) => Meta(
        offset: json['next_offset'] as int,
        hasMore: json['has_more'] as bool,
        perPage: (json['results'] as List<dynamic>).length,
      );

  final int? currentPage;
  final int? lastPage;
  final int perPage;
  final String? after;
  final bool? hasMore;
  final int? offset;

  static const empty = Meta(perPage: 0);

  @override
  List<Object?> get props {
    return [
      currentPage,
      lastPage,
      perPage,
      after,
      hasMore,
      offset,
    ];
  }

  @override
  String toString() {
    return 'Meta(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, after: $after, hasMore: $hasMore, offset: $offset)';
  }

  Meta copyWith({
    ValueGetter<int?>? currentPage,
    ValueGetter<int?>? lastPage,
    int? perPage,
    ValueGetter<String?>? after,
    ValueGetter<bool?>? hasMore,
    ValueGetter<int?>? offset,
  }) {
    return Meta(
      currentPage: currentPage != null ? currentPage() : this.currentPage,
      lastPage: lastPage != null ? lastPage() : this.lastPage,
      perPage: perPage ?? this.perPage,
      after: after != null ? after() : this.after,
      hasMore: hasMore != null ? hasMore() : this.hasMore,
      offset: offset != null ? offset() : this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentPage': currentPage,
      'lastPage': lastPage,
      'perPage': perPage,
      'after': after,
      'hasMore': hasMore,
      'offset': offset,
    };
  }

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      currentPage: map['currentPage']?.toInt(),
      lastPage: map['lastPage']?.toInt(),
      perPage: map['perPage']?.toInt() ?? 0,
      after: map['after'],
      hasMore: map['hasMore'],
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Meta.fromJson(String source) => Meta.fromMap(json.decode(source));
}
