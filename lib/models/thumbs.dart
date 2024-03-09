import 'package:equatable/equatable.dart';

class Thumbs extends Equatable {
  const Thumbs({
    required this.large,
    required this.original,
    required this.small,
  });

  factory Thumbs.fromWallhavenJson(Map<String, dynamic> json) => Thumbs(
        large: json['large'] == null ? '' : json['large'] as String,
        original: json['original'] == null ? '' : json['original'] as String,
        small: json['small'] == null ? '' : json['small'] as String,
      );
  factory Thumbs.fromRedditResolutionsList(List previewImages) {
    final length = previewImages.length;
    if (length < 3) {
      return Thumbs(
        original: (previewImages[length - 1]['url'] as String),
        large: (previewImages[length - 1]['url'] as String),
        small: (previewImages[length - 1]['url'] as String),
      );
    } else {
      return Thumbs(
        original: (previewImages[length - 1]['url'] as String),
        large: (previewImages[length - 2]['url'] as String),
        small: (previewImages[length - 3]['url'] as String),
      );
    }
  }
  factory Thumbs.fromOneUrl(String url) => Thumbs(
        large: url,
        original: url,
        small: url,
      );

  final String large;
  final String original;
  final String small;

  static const empty = Thumbs(
    large: '',
    original: '',
    small: '',
  );

  factory Thumbs.fromDeviantArtJson(List thumbImages) => Thumbs(
        original: thumbImages[2]['src'],
        large: thumbImages[1]['src'],
        small: thumbImages[0]['src'],
      );

  Map<String, dynamic> toJson() => {
        'large': large,
        'original': original,
        'small': small,
      };

  @override
  List<Object?> get props => [large, original, small];

  @override
  String toString() =>
      'Thumbs(large: $large, original: $original, small: $small)';
}
