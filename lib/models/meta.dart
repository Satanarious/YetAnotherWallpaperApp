import 'package:equatable/equatable.dart';

class Meta extends Equatable {
  const Meta({
    this.currentPage,
    this.lastPage,
    required this.perPage,
    this.after,
    this.hasMore,
    this.offset,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage:
            json['current_page'] == null ? 0 : json['current_page'] as int,
        lastPage: json['last_page'] == null ? 0 : json['last_page'] as int,
        perPage: json['per_page'] == null ? 0 : json['per_page'] as int,
      );
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

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'after': after,
        'has_more': hasMore,
        'offset': offset,
      };

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
    return 'Meta(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, after: $after, has_more: $hasMore, offset: $offset)';
  }
}
