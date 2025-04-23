import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/filters/storage/user_communities_storage.dart';
import 'package:wallpaper_app/filters/widgets/community_list_widget.dart';
import 'package:wallpaper_app/filters/widgets/togglable_buttons.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';

class LemmyFilterDialog extends StatefulWidget {
  const LemmyFilterDialog({super.key});

  @override
  State<LemmyFilterDialog> createState() => _LemmyFilterDialogState();
}

class _LemmyFilterDialogState extends State<LemmyFilterDialog>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TextEditingController communityNameController;
  final List<bool> sortSelected = List.generate(10, (index) => false);

  static const sortList = [
    {"name": "Active", "icon": Icons.arrow_upward_rounded},
    {"name": "New", "icon": Icons.new_releases_outlined},
    {"name": "Hot", "icon": Icons.fireplace_rounded},
    {"name": "Old", "icon": Icons.download_rounded},
    {"name": "Top Hour", "icon": Icons.timer_rounded},
    {"name": "Top Day", "icon": Icons.calendar_view_day_rounded},
    {"name": "Top Week", "icon": Icons.calendar_view_week_rounded},
    {"name": "Top Month", "icon": Icons.calendar_view_month_rounded},
    {"name": "Top Year", "icon": Icons.calendar_today_rounded},
    {"name": "Top All", "icon": Icons.all_inbox_rounded},
  ];

  static const communityList = [
    {
      'name': 'AI Generated',
      'value': 'imageai@sh.itjust.works',
      'description': 'Community for AI image generation',
      'url': "https://imgur.com/JFTaoDr.png"
    },
    {
      'name': 'Amoled Backgrounds',
      'value': 'amoledbackgrounds@lemmy.world',
      'description':
          'A community for posting AMOLED background images, these backgrounds are mostly true black which, on (am)oled displays, turns the pixels off entirely.',
      'url': "https://imgur.com/t1XTFuk.png"
    },
    {
      'name': 'Anime Wallpapers',
      'value': 'animewallpapers@ani.social',
      'description':
          'Unleash your otaku spirit and explore a treasure trove of breathtaking anime wallpapers. Join our passionate community and let your screen come alive with the captivating beauty of anime art!',
      'url': "https://imgur.com/u1OyICv.png"
    },
    {
      'name': 'Apocalyptical Art',
      'value': 'apocalypticalart@feddit.de',
      'description':
          'This is where the remnants of humanity’s past meet the promise of an uncertain future. This is the place for apocalyptic wastelands, remains of once-thriving metropolises and forgotten relics of a bygone era.',
      'url': "https://imgur.com/tkIDfb8.png"
    },
    {
      'name': 'Digital Art',
      'value': 'digitalart@lemmy.world',
      'description': 'A community for posting digital art',
      'url': "https://imgur.com/Nv2mwDS.png"
    },
    {
      'name': 'Earth Porn',
      'value': 'earthporn@lemmy.world',
      'description':
          'A community to post pictures of beautiful landscapes and earth in general.',
      'url': "https://imgur.com/zqiMxAF.png"
    },
    {
      'name': 'Mobile Wallpapers',
      'value': 'mobilewallpaper@lemmy.world',
      'description': 'This is a community for sharing mobile wallpapers.',
      'url': "https://imgur.com/dhoG6m3.png"
    },
    {
      'name': "Nature's Patterns",
      'value': 'natures_patterns@lemmy.world',
      'description':
          'Lots of communities are dedicated to nature’s big pictures, the breathtaking vistas and scenic landscapes. Those are all great, but I find the details of the natural world to be just as much of a draw.',
      'url': "https://imgur.com/lmTujsl.png"
    },
    {
      'name': 'Wallpapers',
      'value': 'wallpapers',
      'description': 'A community for posting wallpapers',
      'url': "https://imgur.com/b1dvUyw.png"
    },
    {
      'name': 'Wallpapers(Canada)',
      'value': 'wallpapers@lemmy.ca',
      'description': 'A community for posting wallpapers from Canada',
      'url': "https://imgur.com/KcZ36nl.png"
    },
    {
      'name': 'Wallpapers(World)',
      'value': 'wallpapers@lemmy.world',
      'description':
          'A community for posting wallpapers from all around the world',
      'url': "https://imgur.com/ig0Ns0T.png"
    }
  ];

  LemmySortType get sortType {
    return LemmySortType.values[sortSelected.indexOf(true)];
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    final savedFilters =
        Provider.of<LemmyFiltersStorageProvider>(context, listen: false)
            .fetch();
    communityNameController =
        TextEditingController(text: savedFilters['community']);
    sortSelected[savedFilters['sort_type'] as int] = true;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 14, vertical: 10),
            height: 430,
            width: 350,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Filters",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  const Text(
                                    "Community",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: communityNameController,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                          decoration: InputDecoration(
                                            prefixText: "!",
                                            suffixIcon: IconButton(
                                              tooltip: "Presets",
                                              icon: const Icon(
                                                Icons.list_rounded,
                                                color: Colors.white,
                                              ),
                                              onPressed: () =>
                                                  tabController.animateTo(1),
                                            ),
                                            hintText: "Community Name",
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .symmetric(
                                                    horizontal: 10,
                                                    vertical: 2),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Sort Type",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TogglableButtons(
                                    buttonList: sortList,
                                    selected: sortSelected,
                                    wrapChildren: true,
                                    selectOnlyOne: true,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FilledButton(
                                        onPressed: Navigator.of(context).pop,
                                        style: ButtonStyle(
                                          side: WidgetStateProperty.resolveWith(
                                              (states) => const BorderSide(
                                                  color: Colors.white)),
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) => Theme.of(context)
                                                      .primaryColor
                                                      .withAlpha(120)),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          final queryProvider =
                                              Provider.of<QueryProvider>(
                                                  context,
                                                  listen: false);
                                          final wallpaperListProvider = Provider
                                              .of<WallpaperListProvider>(
                                                  context,
                                                  listen: false);
                                          final lemmyFilterStorageProvider =
                                              Provider.of<
                                                      LemmyFiltersStorageProvider>(
                                                  context,
                                                  listen: false);

                                          // Save Current Query to History
                                          Provider.of<QueriesStorageProvider>(
                                                  context,
                                                  listen: false)
                                              .addHistoryQuery(
                                                  queryProvider.currentQuery);
                                          Provider.of<QueriesProvider>(context,
                                                  listen: false)
                                              .addHistoryQuery(
                                                  queryProvider.currentQuery);

                                          lemmyFilterStorageProvider.update(
                                              community:
                                                  communityNameController.text,
                                              sortType:
                                                  sortSelected.indexOf(true));
                                          wallpaperListProvider
                                              .emptyWallpaperList();
                                          queryProvider.setLemmyQuery(
                                              communityName:
                                                  communityNameController.text,
                                              sortType: sortType);
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          side: WidgetStateProperty.resolveWith(
                                              (states) => const BorderSide(
                                                  color: Colors.white)),
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) => Theme.of(context)
                                                      .primaryColor
                                                      .withAlpha(120)),
                                        ),
                                        child: const Text("Ok"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      CommunityListWidget(
                          communityNameController: communityNameController,
                          tabController: tabController,
                          communityList: communityList,
                          height: 300,
                          communityStorage:
                              Provider.of<LemmyUserCommunitiesStorage>(context,
                                  listen: false)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
