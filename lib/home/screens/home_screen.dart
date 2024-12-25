import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/favourites/providers/favourites_provider.dart';
import 'package:wallpaper_app/favourites/storage/favourites_storage_provider.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';
import 'package:wallpaper_app/home/screens/wallpaper_grid_screen.dart';
import 'package:wallpaper_app/home/widgets/pill_tab_bar.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = "/Home";

  void initializeStorageProviders(BuildContext context) {
    // Set Queries from Storage
    final queryStorageProvider =
        Provider.of<QueriesStorageProvider>(context, listen: false);
    final queriesProvider =
        Provider.of<QueriesProvider>(context, listen: false);
    queriesProvider.savedQueries = queryStorageProvider.fetchSavedQueries();
    queriesProvider.historyQueries = queryStorageProvider.fetchHistoryQueries();

    // Set History from Storage
    final history = Provider.of<HistoryStorageProvider>(context, listen: false)
        .fetchHistory();
    Provider.of<HistoryProvider>(context, listen: false).history = history;

    // Set Favourites from Storage
    final favouritesStorageProvider =
        Provider.of<FavouritesStorageProvider>(context, listen: false);
    final favouriteProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    for (var folder in favouritesStorageProvider.fetchFavourites()) {
      favouriteProvider.favouriteFolders[folder["name"]] = folder["list"];
    }
    favouriteProvider.allFavourites.data.addAll(
        favouritesStorageProvider.getFavouriteFolder("System | All").data);
  }

  @override
  Widget build(BuildContext context) {
    initializeStorageProviders(context);
    DateTime? currentBackPressTime;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        final now = DateTime.now();
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Press back again to exit'),
            backgroundColor: Color.fromRGBO(50, 50, 50, 1),
            duration: Duration(seconds: 2),
          ));
        } else {
          SystemNavigator.pop();
        }
      },
      child: const Scaffold(
        backgroundColor: Color.fromRGBO(50, 50, 50, 1),
        extendBody: true,
        body: Stack(children: [
          WallpaperGridScreen(),
          PillTabBar(),
        ]),
      ),
    );
  }
}
