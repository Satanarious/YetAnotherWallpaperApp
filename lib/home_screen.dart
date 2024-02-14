import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/action_dialogs/source_selector_dialog.dart';
import 'package:wallpaper_app/filter_dialogs/wallhaven_filter_dialog.dart';
import 'package:wallpaper_app/screens/favourites_screen.dart';
import 'package:wallpaper_app/screens/wallpaper_grid_screen.dart';
import 'providers/providers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(50, 50, 50, 1),
      body: Stack(children: [
        WallpaperGridScreen(),
        PillTabBar(),
      ]),
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
    if (source == Sources.wallhaven) {
      showDialog(
          context: context,
          builder: (context) => const WallhavenFilterDialog());
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
              width: MediaQuery.of(context).size.width * 0.40,
              height: scrollHandlingProvider.pillHeight,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 10,
                backgroundColor: Colors.black.withAlpha(220),
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
