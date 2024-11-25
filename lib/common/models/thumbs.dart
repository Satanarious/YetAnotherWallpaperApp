import 'dart:convert';

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

  @override
  List<Object> get props => [large, original, small];

  @override
  String toString() =>
      'Thumbs(large: $large, original: $original, small: $small)';

  Thumbs copyWith({
    String? large,
    String? original,
    String? small,
  }) {
    return Thumbs(
      large: large ?? this.large,
      original: original ?? this.original,
      small: small ?? this.small,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'large': large,
      'original': original,
      'small': small,
    };
  }

  factory Thumbs.fromMap(Map<String, dynamic> map) {
    return Thumbs(
      large: map['large'] ?? '',
      original: map['original'] ?? '',
      small: map['small'] ?? '',
    );
  }

  factory Thumbs.fromJson(String source) => Thumbs.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
