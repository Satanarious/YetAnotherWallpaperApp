import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/favourites/screens/favourites_screen.dart';
import 'package:wallpaper_app/history/screens/history_screen.dart';
import 'package:wallpaper_app/home/dialogs/source_selector_dialog.dart';
import 'package:wallpaper_app/home/enums/pill_actions.dart';
import 'package:wallpaper_app/home/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/queries/dialogs/query_dialog.dart';
import 'package:wallpaper_app/settings/screens/settings_screen.dart';

import '../../filters/dialogs/filter_dialogs.dart';

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
        AnimatedPopInDialog.showGeneral(context, const WallhavenFilterDialog());
        break;
      case Sources.reddit:
        AnimatedPopInDialog.showGeneral(context, const RedditFilterDialog());
        break;
      case Sources.lemmy:
        AnimatedPopInDialog.showGeneral(context, const LemmyFilterDialog());
        break;
      case Sources.deviantArt:
        AnimatedPopInDialog.showGeneral(
            context, const DeviantArtFilterDialog());
        break;
      default:
        throw Exception("Source not supported yet!!");
    }
  }

  void pillButtonAction(PillAction pillAction) {
    switch (pillAction) {
      case PillAction.sourceSelector:
        showDialog(
            context: context,
            builder: (context) => const SourceSelectorDialog());
        break;
      case PillAction.favourites:
        Navigator.of(context).pushNamed(FavouritesScreen.routeName);
        break;
      case PillAction.history:
        Navigator.of(context).pushNamed(HistoryScreen.routeName);
        break;
      case PillAction.queries:
        AnimatedPopInDialog.showGeneral(context, const QueryDialog());
        break;
      case PillAction.settings:
        Navigator.of(context).pushNamed(SettingsScreen.routeName);
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
                          onPressed: () =>
                              pillButtonAction(PillAction.sourceSelector),
                          tooltip: "Sources",
                          icon: const Icon(
                            IconlyLight.category,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () =>
                              pillButtonAction(PillAction.favourites),
                          tooltip: "Favourites",
                          icon: const Icon(
                            IconlyLight.heart,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => pillButtonAction(PillAction.history),
                          tooltip: "History",
                          icon: const Icon(
                            IconlyLight.time_circle,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => pillButtonAction(PillAction.queries),
                          tooltip: "Queries",
                          icon: const Icon(
                            IconlyLight.document,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () =>
                              pillButtonAction(PillAction.settings),
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
