import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/common/models/models.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';

class FolderImagePreview extends StatelessWidget {
  const FolderImagePreview({
    super.key,
    required this.top,
    required this.right,
    this.wallpaper,
  });
  final double top;
  final double right;
  final Wallpaper? wallpaper;
  static const itemHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: right,
      child: Container(
          height: itemHeight,
          width: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white60,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: wallpaper == null
              ? Container()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: wallpaper!.source == Sources.local
                      ? Image.file(
                          File(wallpaper!.localPath!),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: wallpaper!.thumbs.large,
                          fit: BoxFit.cover,
                        ),
                )),
    );
  }
}
