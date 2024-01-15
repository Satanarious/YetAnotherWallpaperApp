import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget(this.url, {super.key});
  final String url;

  Future<Widget> loadImage(String url) async {
    final image = CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) =>
          const Center(child: Text("Error Loading Image")),
      placeholder: (context, url) => Center(
        child: Image.asset(
          "assets/loading.gif",
          height: 20,
        ),
      ),
    );
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadImage(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
