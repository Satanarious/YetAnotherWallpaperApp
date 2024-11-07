import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/home_screen.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:wallpaper_app/screens/screens.dart';
import 'package:wallpaper_app/screens/splash_screen.dart';
import 'package:wallpaper_app/storage/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
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
        ChangeNotifierProvider.value(value: HistoryStorageProvider()),
        ChangeNotifierProvider.value(value: FavouritesStorageProvider()),
        ChangeNotifierProvider.value(value: RedditFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: LemmyFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: WallhavenFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: DeviantArtFiltersStorageProvider()),
      ],
      child: MaterialApp(
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
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
