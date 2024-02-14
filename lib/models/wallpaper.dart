import 'package:equatable/equatable.dart';
import 'package:wallpaper_app/enums/file_type.dart';
import 'package:wallpaper_app/enums/purity.dart';
import './models.dart';

class Wallpaper extends Equatable {
  const Wallpaper({
    this.title,
    this.author,
    this.postUrl,
    this.dimensionX,
    this.dimensionY,
    required this.id,
    required this.url,
    required this.purity,
    required this.fileSize,
    required this.fileType,
    required this.colors,
    required this.thumbs,
  });

  factory Wallpaper.fromWallhavenJson(Map<String, dynamic> json) => Wallpaper(
        id: json['id'] == null ? '' : json['id'] as String,
        url: json['url'] == null ? '' : json['path'] as String,
        purity: json['purity'] == null
            ? PurityType.general
            : Purity.fromString(json['purity']),
        dimensionX:
            json['dimension_x'] == null ? 0 : json['dimension_x'] as int,
        dimensionY:
            json['dimension_y'] == null ? 0 : json['dimension_y'] as int,
        fileSize: json['file_size'] == null ? 0 : json['file_size'] as int,
        fileType: json['file_type'] == null
            ? FileType.invalid
            : File.fromString(json['file_type']),
        colors: json['colors'] == null
            ? []
            : (json['colors'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
        thumbs: json['thumbs'] == null
            ? Thumbs.empty
            : Thumbs.fromWallhavenJson(json['thumbs'] as Map<String, dynamic>),
      );

  factory Wallpaper.fromRedditJson(Map<String, dynamic> json) {
    json = json['data'];
    final Map<String, dynamic> imageProps = json['preview']['images'][0];
    final String url =
        (imageProps['source']['url'] as String).replaceAll("&amp;", "&");
    return Wallpaper(
        title: json['title'],
        author: json['author'],
        postUrl: json['url'] ?? json['url_overridden_by_dest'],
        id: imageProps['id'],
        url: url,
        purity: Purity.fromBool(json['over_18'] as bool),
        dimensionX: imageProps['source']['width'] as int,
        dimensionY: imageProps['source']['height'] as int,
        fileSize: 0,
        fileType:
            File.fromString("image/${url.split("?").first.split(".").last}"),
        colors: const [],
        thumbs: Thumbs.fromRedditResolutionsList(imageProps["resolutions"]));
  }

  factory Wallpaper.fromLemmyJson(Map<String, dynamic> json) {
    final post = json['post'] as Map<String, dynamic>;
    final creator = json['creator'] as Map<String, dynamic>;
    final url = post['url'] as String;
    return Wallpaper(
        title: post['name'],
        author: creator['name'],
        postUrl: post['ap_id'],
        id: (post['id'] as int).toString(),
        url: url,
        purity: Purity.fromBool(post['nsfw'] as bool),
        fileSize: 0,
        fileType: File.fromString("image/${url.split(".").last}"),
        colors: const [],
        thumbs: Thumbs.fromOneUrl(
            "${post['thumbnail_url']}?format=jpg&thumbnail=800"));
  }

  final String? title;
  final String? author;
  final String id;
  final String url;
  final String? postUrl;
  final PurityType purity;
  final int? dimensionX;
  final int? dimensionY;
  final int fileSize;
  final FileType fileType;
  final List<String> colors;
  final Thumbs thumbs;

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'purity': purity,
        'dimension_x': dimensionX,
        'dimension_y': dimensionY,
        'file_size': fileSize,
        'file_type': fileType,
        'colors': colors,
        'thumbs': thumbs.toJson(),
      };

  @override
  List<Object?> get props => [id];

  @override
  String toString() =>
      'Wallpaper(id: $id, url: $url, purity: $purity, dimensionX: $dimensionX, dimensionY: $dimensionY, fileSize: $fileSize, fileType: $fileType, colors: $colors, thumbs: $thumbs)';
}
