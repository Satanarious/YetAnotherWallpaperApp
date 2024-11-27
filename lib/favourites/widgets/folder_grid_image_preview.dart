import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FolderGridImagePreview extends StatelessWidget {
  const FolderGridImagePreview({
    super.key,
    this.url,
  });
  final String? url;
  static const itemHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemHeight,
      width: itemHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white60,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: url == null
          ? Container()
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
