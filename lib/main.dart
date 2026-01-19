import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/screens/favourite_wallpaper_grid_screen.dart';
import 'package:wallpaper_app/favourites/screens/favourites_screen.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/filters/storage/user_communities_storage.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/screens/history_screen.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/home/screens/home_screen.dart';
import 'package:wallpaper_app/open_image/screens/open_image_screen.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';
import 'package:wallpaper_app/settings/screens/settings_screen.dart';
import 'package:wallpaper_app/settings/storage/settings_storage_provider.dart';
import 'package:wallpaper_app/splash_screen.dart';

Future<void> main() async {
  // Initialize modules before running the app
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
        ChangeNotifierProvider.value(value: FavouritesStorageProvider()),
        ChangeNotifierProvider.value(value: SourceProvider()),
        ChangeNotifierProvider.value(value: QueryProvider()),
        ChangeNotifierProvider.value(value: QueriesProvider()),
        ChangeNotifierProvider.value(value: QueriesStorageProvider()),
        ChangeNotifierProvider.value(value: HistoryProvider()),
        ChangeNotifierProvider.value(value: HistoryStorageProvider()),
        ChangeNotifierProvider.value(value: FiltersStorageProvider()),
        ChangeNotifierProvider.value(value: RedditFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: RedditUserCommunitiesStorage()),
        ChangeNotifierProvider.value(value: LemmyFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: LemmyUserCommunitiesStorage()),
        ChangeNotifierProvider.value(value: WallhavenFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: DeviantArtFiltersStorageProvider()),
        ChangeNotifierProvider.value(value: SettingsProvider()),
        ChangeNotifierProvider.value(value: SettingsStorageProvider()),
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
          SettingsScreen.routeName: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
