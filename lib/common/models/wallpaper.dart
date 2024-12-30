import 'dart:convert';
import 'dart:io' as io;

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:wallpaper_app/common/enums/file_type.dart';
import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/common/models/thumbs.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

class Wallpaper extends Equatable {
  const Wallpaper({
    this.title,
    this.author,
    required this.id,
    required this.url,
    this.postUrl,
    required this.purity,
    this.dimensionX,
    this.dimensionY,
    required this.fileSize,
    required this.fileType,
    this.colors,
    required this.thumbs,
    this.source,
    this.localPath,
  });

  factory Wallpaper.fromWallhavenJson(Map<String, dynamic> json) => Wallpaper(
        id: json['id'] == null
            ? DateTime.now().toString()
            : json['id'] as String,
        url: json['path'] ?? '',
        source: Sources.wallhaven,
        postUrl: json['url'],
        purity: json['purity'] == null
            ? PurityType.general
            : Purity.fromString(json['purity']),
        dimensionX:
            json['dimension_x'] == null ? 0 : json['dimension_x'] as int,
        dimensionY:
            json['dimension_y'] == null ? 0 : json['dimension_y'] as int,
        fileSize: json['file_size'] ?? 0,
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
    final String? url = imageProps['source']['url'];
    final fileType = url == null
        ? FileType.invalid
        : File.fromString("image/${url.split("?").first.split(".").last}");
    final isGif = fileType == FileType.gif;
    return Wallpaper(
        title: json['title'],
        author: json['author'] ?? '',
        source: Sources.reddit,
        postUrl: json['url'] ?? json['url_overridden_by_dest'],
        id: imageProps['id'] ?? DateTime.now().toString(),
        url: isGif
            ? imageProps['variants']['gif']['source']['url']
            : imageProps['source']['url'],
        purity: json['over_18'] == null
            ? PurityType.general
            : Purity.fromBool(json['over_18'] as bool),
        dimensionX: imageProps['source']['width'] ?? 0,
        dimensionY: imageProps['source']['height'] ?? 0,
        fileSize: 0,
        fileType: fileType,
        thumbs: imageProps["resolutions"] == null ||
                (imageProps["resolutions"] as List).isEmpty
            ? Thumbs.empty
            : Thumbs.fromRedditResolutionsList(isGif
                ? imageProps['variants']['gif']['resolutions']
                : imageProps['resolutions']));
  }

  factory Wallpaper.fromLemmyJson(Map<String, dynamic> json) {
    final post = json['post'] as Map<String, dynamic>;
    final creator = json['creator'] as Map<String, dynamic>;
    final String? url = post['url'];
    return Wallpaper(
        title: post['name'],
        author: creator['name'] ?? '',
        source: Sources.lemmy,
        postUrl: post['ap_id'],
        id: post['id'] == null
            ? DateTime.now().toString()
            : (post['id'] as int).toString(),
        url: url ?? '',
        purity: post['nsfw'] == null
            ? PurityType.general
            : Purity.fromBool(post['nsfw'] as bool),
        fileSize: 0,
        fileType: url == null
            ? FileType.invalid
            : File.fromString("image/${url.split("?").first.split(".").last}"),
        thumbs: post['thumbnail_url'] == null
            ? Thumbs.empty
            : Thumbs.fromOneUrl(
                "${post['thumbnail_url']}?format=jpg&thumbnail=800"));
  }

  factory Wallpaper.fromDeviantArtJson(Map<String, dynamic> json) {
    final imageProps = json['content'];
    if (imageProps == null) {
      return Wallpaper.empty;
    }
    final String? url = imageProps['src'];
    return Wallpaper(
      id: json['deviationid'] ?? DateTime.now().toString(),
      source: Sources.deviantArt,
      title: json['title'],
      author: json['author']['username'],
      postUrl: json['url'],
      url: url ?? '',
      dimensionX: imageProps['width'] ?? 0,
      dimensionY: imageProps['height'] ?? 0,
      fileSize: imageProps['filesize'] ?? 0,
      purity: json['is_mature'] == null
          ? PurityType.general
          : Purity.fromBool(json['is_mature'] as bool),
      fileType: url == null
          ? FileType.invalid
          : File.fromString(
              "image/${url.split("?token=").first.split(".").last}"),
      thumbs: json['thumbs'] == null
          ? Thumbs.empty
          : Thumbs.fromDeviantArtJson(json['thumbs']),
    );
  }

  Future<void> downloadToGallery() async {
    if (source == Sources.local) {
      final file = io.File(localPath!);
      final hasAccess = await Gal.hasAccess();
      await Gal.requestAccess();
      if (hasAccess) {
        await Gal.putImageBytes(file.readAsBytesSync(),
            album: "YetAnotherWallpaperApp", name: file.path.split("/").last);
      }
    } else {
      var response = await http.get(Uri.parse(url));
      // Generate random uuid if title doesn't exist
      final fileName = title ?? const Uuid().v4();
      final hasAccess = await Gal.hasAccess();
      await Gal.requestAccess();
      if (hasAccess) {
        await Gal.putImageBytes(response.bodyBytes,
            album: "YetAnotherWallpaperApp", name: fileName);
      }
    }
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
  final List<String>? colors;
  final Thumbs thumbs;
  final Sources? source;
  final String? localPath;

  static const empty = Wallpaper(
      id: '',
      url: '',
      purity: PurityType.general,
      fileSize: 0,
      fileType: FileType.invalid,
      thumbs: Thumbs.empty);

  @override
  List<Object?> get props {
    return [id];
  }

  @override
  String toString() {
    return 'Wallpaper(title: $title, author: $author, id: $id, url: $url, postUrl: $postUrl, purity: $purity, dimensionX: $dimensionX, dimensionY: $dimensionY, fileSize: $fileSize, fileType: $fileType, colors: $colors, thumbs: $thumbs, source: $source, localPath: $localPath)';
  }

  Wallpaper copyWith({
    ValueGetter<String?>? title,
    ValueGetter<String?>? author,
    String? id,
    String? url,
    ValueGetter<String?>? postUrl,
    PurityType? purity,
    ValueGetter<int?>? dimensionX,
    ValueGetter<int?>? dimensionY,
    int? fileSize,
    FileType? fileType,
    ValueGetter<List<String>?>? colors,
    Thumbs? thumbs,
    ValueGetter<Sources?>? source,
    ValueGetter<String?>? localPath,
  }) {
    return Wallpaper(
      title: title != null ? title() : this.title,
      author: author != null ? author() : this.author,
      id: id ?? this.id,
      url: url ?? this.url,
      postUrl: postUrl != null ? postUrl() : this.postUrl,
      purity: purity ?? this.purity,
      dimensionX: dimensionX != null ? dimensionX() : this.dimensionX,
      dimensionY: dimensionY != null ? dimensionY() : this.dimensionY,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      colors: colors != null ? colors() : this.colors,
      thumbs: thumbs ?? this.thumbs,
      source: source != null ? source() : this.source,
      localPath: localPath != null ? localPath() : this.localPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'id': id,
      'url': url,
      'postUrl': postUrl,
      'purity': purity.index,
      'dimensionX': dimensionX,
      'dimensionY': dimensionY,
      'fileSize': fileSize,
      'fileType': fileType.index,
      'colors': colors,
      'thumbs': thumbs.toMap(),
      'source': source?.index,
      'localPath': localPath,
    };
  }

  factory Wallpaper.fromMap(Map<String, dynamic> map) {
    return Wallpaper(
      title: map['title'],
      author: map['author'],
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      postUrl: map['postUrl'],
      purity: PurityType.values[map['purity']],
      dimensionX: map['dimensionX']?.toInt(),
      dimensionY: map['dimensionY']?.toInt(),
      fileSize: map['fileSize']?.toInt() ?? 0,
      fileType: FileType.values[map['fileType']],
      colors: map['color'] == null ? [] : List<String>.from(map['colors']),
      thumbs: Thumbs.fromMap(map['thumbs']),
      source: map['source'] != null ? Sources.values[map['source']] : null,
      localPath: map['localPath'],
    );
  }
  String toJson() => json.encode(toMap());

  factory Wallpaper.fromJson(String source) =>
      Wallpaper.fromMap(json.decode(source));
}
