import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/history_provider.dart';
import './screens/screens.dart';
import './providers/providers.dart';
import 'home_screen.dart';

void main() {
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ScrollHandlingProvider()),
        ChangeNotifierProvider.value(value: WallpaperListProvider()),
        ChangeNotifierProvider.value(value: FavouritesProvider()),
        ChangeNotifierProvider.value(value: SourceProvider()),
        ChangeNotifierProvider.value(value: QueryProvider()),
        ChangeNotifierProvider.value(value: HistoryProvider()),
      ],
      child: MaterialApp(
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          FavouritesScreen.routeName: (context) => const FavouritesScreen(),
          OpenImageScreen.routeName: (context) => const OpenImageScreen(),
          FavouriteWallpaperGridScreen.routeName: (context) =>
              const FavouriteWallpaperGridScreen(),
          HistoryScreen.routeName: (context) => const HistoryScreen(),
        },
      ),
    );
  }
}
