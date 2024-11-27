import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FolderImagePreview extends StatelessWidget {
  const FolderImagePreview({
    super.key,
    required this.top,
    required this.right,
    this.url,
  });
  final double top;
  final double right;
  final String? url;
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
          child: url == null
              ? Container()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: url!,
                    fit: BoxFit.cover,
                  ),
                )),
    );
  }
}
