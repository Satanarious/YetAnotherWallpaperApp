import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreviewGridItem extends StatefulWidget {
  const ImagePreviewGridItem(this.url, this.height, {super.key});
  final String url;
  final double height;

  @override
  State<ImagePreviewGridItem> createState() => _ImagePreviewGridItemState();
}

class _ImagePreviewGridItemState extends State<ImagePreviewGridItem>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late AnimationController _controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _controller.value,
        child: Container(
          color: Colors.black,
          height: widget.height,
          width: double.infinity,
          child: CachedNetworkImage(
            filterQuality: FilterQuality.high,
            imageUrl: widget.url,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                const Center(child: Text("Error Loading Image")),
            placeholder: (context, url) => Center(
              child: Image.asset(
                "assets/loading.gif",
                height: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
