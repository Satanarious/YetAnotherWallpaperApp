import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/floating_button_provider.dart';
import 'providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/tab_screen.dart';

void main() {
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ScrollHandlingProvider(),
          ),
          ChangeNotifierProvider.value(
            value: FloatingButtonProvider(),
          )
        ],
        child: const TabScreen(),
      ),
    );
  }
}
