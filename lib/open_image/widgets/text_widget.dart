import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
