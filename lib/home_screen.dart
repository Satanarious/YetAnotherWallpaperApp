import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/source_selector_dialog.dart';
import 'package:wallpaper_app/filter_dialogs/filter_dialogs.dart';
import 'package:wallpaper_app/providers/history_provider.dart';
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
  void filterButtonAction() {
    final source = Provider.of<SourceProvider>(context, listen: false).source;
    switch (source) {
      case Sources.wallhaven:
        showDialog(
          context: context,
          builder: (context) => const WallhavenFilterDialog(),
        );
        break;
      case Sources.reddit:
        showDialog(
          context: context,
          builder: (context) => const RedditFilterDialog(),
        );
        break;
      case Sources.lemmy:
        showDialog(
          context: context,
          builder: (context) => const LemmyFilterDialog(),
        );
      case Sources.deviantArt:
        showDialog(
          context: context,
          builder: (context) => const DeviantArtFilterDialog(),
        );
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
        Navigator.of(context).pushNamed(HistoryScreen.routeName);
        break;
      case 2:
        Navigator.of(context).pushNamed(FavouritesScreen.routeName);
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
              width: 180,
              height: scrollHandlingProvider.pillHeight,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 10,
                backgroundColor: Colors.black.withAlpha(210),
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.grey,
                onTap: (index) {
                  pillButtonAction(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    tooltip: "Change Source",
                    icon: Icon(Icons.wallpaper),
                    label: "Source",
                  ),
                  BottomNavigationBarItem(
                    tooltip: "History",
                    icon: Icon(Icons.history),
                    label: "History",
                  ),
                  BottomNavigationBarItem(
                    tooltip: "Favourites",
                    icon: Icon(Icons.favorite),
                    label: "Favourites",
                  ),
                  BottomNavigationBarItem(
                    tooltip: "Settings",
                    icon: Icon(Icons.settings),
                    label: "Settings",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(color: Colors.black.withAlpha(210)),
                child: IconButton(
                  onPressed: filterButtonAction,
                  tooltip: "Filter",
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.grey,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
