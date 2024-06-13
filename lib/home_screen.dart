import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/source_selector_dialog.dart';
import 'package:wallpaper_app/filter_dialogs/filter_dialogs.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:wallpaper_app/screens/screens.dart';
import 'package:wallpaper_app/storage/storage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = "/";

  void initializeStorageProviders(BuildContext context) {
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
      onPopInvoked: (didPop) {
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

class PillTabBar extends StatefulWidget {
  const PillTabBar({super.key});

  @override
  State<PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<PillTabBar> {
  Future animatedPopInOutDialog(Widget dialog) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, wid) {
          return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: dialog,
              ));
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => Container());
  }

  void filterButtonAction() {
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    switch (source) {
      case Sources.wallhaven:
        animatedPopInOutDialog(const WallhavenFilterDialog());
        break;
      case Sources.reddit:
        animatedPopInOutDialog(const RedditFilterDialog());
        break;
      case Sources.lemmy:
        animatedPopInOutDialog(const LemmyFilterDialog());
        break;
      case Sources.deviantArt:
        animatedPopInOutDialog(const DeviantArtFilterDialog());
        break;
      default:
        throw Exception("Source not supported yet!!");
    }
  }

  void pillButtonAction(int tabIndex) {
    switch (tabIndex) {
      case 0:
        showDialog(
            context: context,
            builder: (context) => const SourceSelectorDialog());
        break;
      case 1:
        Navigator.of(context).pushNamed(FavouritesScreen.routeName);
        break;
      case 2:
        Navigator.of(context).pushNamed(HistoryScreen.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollHandlingProvider = Provider.of<ScrollHandlingProvider>(context);
    return Positioned(
      left: 0,
      right: 0,
      bottom: scrollHandlingProvider.pillOffset,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: SizedBox(
              width: 242,
              height: scrollHandlingProvider.pillHeight,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(50),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => pillButtonAction(0),
                          tooltip: "Sources",
                          icon: const Icon(
                            IconlyLight.category,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => pillButtonAction(1),
                          tooltip: "Favourites",
                          icon: const Icon(
                            IconlyLight.heart,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => pillButtonAction(2),
                          tooltip: "History",
                          icon: const Icon(
                            IconlyLight.time_circle,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => 1,
                          tooltip: "Queries",
                          icon: const Icon(
                            IconlyLight.document,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => 1,
                          tooltip: "Settings",
                          icon: const Icon(
                            IconlyLight.setting,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(50),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    onPressed: filterButtonAction,
                    tooltip: "Filter",
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Lottie {}
