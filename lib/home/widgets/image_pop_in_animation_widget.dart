import 'package:flutter/material.dart';

class ImagePopInAnimation extends StatefulWidget {
  const ImagePopInAnimation(this.imageWidget, {super.key});
  final Widget imageWidget;

  @override
  State<ImagePopInAnimation> createState() => _ImagePopInAnimationState();
}

class _ImagePopInAnimationState extends State<ImagePopInAnimation>
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
              child: widget.imageWidget,
            ));
  }
}
