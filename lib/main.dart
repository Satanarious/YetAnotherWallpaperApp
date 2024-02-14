import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/favourites_screen.dart';
import '../screens/open_image_screen.dart';
import './providers/providers.dart';
import 'home_screen.dart';

void main() {
  runApp(const WallpaperApp());
}

// ! Bug: Lemmy and Reddit next pages not showing
// ! Reddit stops at 1 page
// ! Lemmy shows the same page again and again
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
      ],
      child: MaterialApp(
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          FavouritesScreen.routeName: (context) => const FavouritesScreen(),
          OpenImageScreen.routeName: (context) => const OpenImageScreen(),
        },
      ),
    );
  }
}
