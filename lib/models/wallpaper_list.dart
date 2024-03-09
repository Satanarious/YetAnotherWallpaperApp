import 'package:equatable/equatable.dart';
import './models.dart';

class WallpaperList extends Equatable {
  const WallpaperList({required this.data, required this.meta});

  factory WallpaperList.fromWallhavenJson(Map<String, dynamic> json) =>
      WallpaperList(
        data: json['data'] == null
            ? []
            : (json['data'] as List<dynamic>)
                .map(
                  (dynamic e) =>
                      Wallpaper.fromWallhavenJson(e as Map<String, dynamic>),
                )
                .toList(),
        meta: json['meta'] == null
            ? Meta.empty
            : Meta.fromJson(json['meta'] as Map<String, dynamic>),
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

  final List<Wallpaper> data;
  final Meta meta;

  static const empty = WallpaperList(data: [], meta: Meta.empty);

  void addWallpaper(Wallpaper wallpaper) {
    data.add(wallpaper);
  }

  void removeWallpaper(Wallpaper wallpaper) {
    data.remove(wallpaper);
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((Wallpaper e) => e.toJson()).toList(),
        'meta': meta.toJson(),
      };

  @override
  List<Object?> get props => [data, meta];

  @override
  String toString() => 'WallpaperList(data: $data, meta: $meta)';
}
