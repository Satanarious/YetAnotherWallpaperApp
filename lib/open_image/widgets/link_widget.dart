import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget(this.link, {super.key});
  final String link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async => launchUrlString(link),
        child: Text(
          link,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            decorationStyle: TextDecorationStyle.solid,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
