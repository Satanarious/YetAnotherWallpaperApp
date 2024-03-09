import 'package:equatable/equatable.dart';
import 'package:wallpaper_app/enums/file_type.dart';
import 'package:wallpaper_app/enums/purity.dart';
import '../providers/source_provider.dart';
import './models.dart';
import 'package:gal/gal.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Wallpaper extends Equatable {
  const Wallpaper({
    this.title,
    this.author,
    this.postUrl,
    this.dimensionX,
    this.dimensionY,
    this.colors,
    this.source,
    required this.id,
    required this.url,
    required this.purity,
    required this.fileSize,
    required this.fileType,
    required this.thumbs,
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

  static const empty = Wallpaper(
      id: '',
      url: '',
      purity: PurityType.general,
      fileSize: 0,
      fileType: FileType.invalid,
      thumbs: Thumbs.empty);

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'purity': purity,
        'dimension_x': dimensionX,
        'dimension_y': dimensionY,
        'file_size': fileSize,
        'file_type': fileType,
        'thumbs': thumbs.toJson(),
      };

  @override
  List<Object?> get props => [id];

  @override
  String toString() =>
      'Wallpaper(id: $id, url: $url, purity: $purity, dimensionX: $dimensionX, dimensionY: $dimensionY, fileSize: $fileSize, fileType: $fileType, colors: $colors, thumbs: $thumbs)';
}
