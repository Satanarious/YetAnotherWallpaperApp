import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:wallpaper_app/common/models/models.dart';

class WallpaperList extends Equatable {
  const WallpaperList({required this.data, required this.meta});

  factory WallpaperList.fromWallhavenJson(
          Map<String, dynamic> json, Meta meta) =>
      WallpaperList(
        data: json['data'] == null
            ? []
            : (json['data'] as List<dynamic>)
                .map(
                  (dynamic e) =>
                      Wallpaper.fromWallhavenJson(e as Map<String, dynamic>),
                )
                .toList(),
        meta: meta,
      );

  factory WallpaperList.fromRedditJson(Map<String, dynamic> json, Meta meta) {
    final children = json['data']['children'] as List;
    return WallpaperList(
      data: children.isEmpty
          ? []
          : children
              .map(
                (dynamic e) =>
                    Wallpaper.fromRedditJson(e as Map<String, dynamic>),
              )
              .toList(),
      meta: meta,
    );
  }

  factory WallpaperList.fromLemmyJson(Map<String, dynamic> json, Meta meta) =>
      WallpaperList(
        data: json['posts'] == null
            ? []
            : (json['posts'] as List<dynamic>).map((dynamic e) {
                return Wallpaper.fromLemmyJson(e as Map<String, dynamic>);
              }).toList(),
        meta: meta,
      );

  factory WallpaperList.fromDeviantArtJson(
          Map<String, dynamic> json, Meta meta) =>
      WallpaperList(
          data: json['results'] == null
              ? []
              : (json['results'] as List<dynamic>).map((dynamic e) {
                  return Wallpaper.fromDeviantArtJson(
                      e as Map<String, dynamic>);
                }).toList(),
          meta: meta);

  factory WallpaperList.emptyList() {
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    return WallpaperList(data: [], meta: Meta(perPage: 0));
  }

  final List<Wallpaper> data;
  final Meta meta;

  static const empty = WallpaperList(data: [], meta: Meta.empty);

  void addWallpaper(Wallpaper wallpaper) {
    data.add(wallpaper);
  }

  void removeWallpaper(Wallpaper wallpaper) {
    data.remove(wallpaper);
  }

  @override
  List<Object> get props => [data, meta];

  @override
  String toString() => 'WallpaperList(data: $data, meta: $meta)';

  WallpaperList copyWith({
    List<Wallpaper>? data,
    Meta? meta,
  }) {
    return WallpaperList(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
      'meta': meta.toMap(),
    };
  }

  factory WallpaperList.fromMap(Map<String, dynamic> map) {
    return WallpaperList(
      data: List<Wallpaper>.from(map['data']?.map((x) => Wallpaper.fromMap(x))),
      meta: Meta.fromMap(map['meta']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WallpaperList.fromJson(String source) =>
      WallpaperList.fromMap(json.decode(source));
}
