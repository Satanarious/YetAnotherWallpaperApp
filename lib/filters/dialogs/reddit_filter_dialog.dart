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

class RedditFilterDialog extends StatefulWidget {
  const RedditFilterDialog({super.key});

  @override
  State<RedditFilterDialog> createState() => _RedditFilterDialogState();
}

class _RedditFilterDialogState extends State<RedditFilterDialog>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final subredditNameController =
      TextEditingController(text: 'Verticalwallpapers');
  final sortSelected = List.generate(4, (index) => false);
  final rangeSelected = List.generate(6, (index) => false);

  static const sortList = [
    {"name": "Top", "icon": Icons.arrow_upward_rounded},
    {"name": "New", "icon": Icons.new_releases_outlined},
    {"name": "Hot", "icon": Icons.fireplace_rounded},
    {"name": "Rising", "icon": Icons.upload_rounded},
  ];
  static const rangeList = [
    {"name": "All", "icon": Icons.date_range_rounded},
    {"name": "Year", "icon": Icons.calendar_month_outlined},
    {"name": "Month", "icon": Icons.calendar_view_month},
    {"name": "Week", "icon": Icons.calendar_view_week},
    {"name": "Day", "icon": Icons.today},
    {"name": "Hour", "icon": Icons.timer},
  ];

  static const subredditList = [
    {
      "name": "Amoled Backgrounds",
      "value": "Amoledbackgrounds",
      "description":
          "Backgrounds for OLED phones, mainly black for screen power saving and contrast.",
      "url": "https://imgur.com/t1XTFuk.png",
    },
    {
      "name": "Anime Phone Wallpapers",
      "value": "AnimePhoneWallpapers",
      "description":
          "Subreddit dedicated exclusively to anime background images designed for mobile phones.",
      "url": "https://imgur.com/QmeFwcd.png",
    },
    {
      "name": "Anime Wallpaper",
      "value": "Animewallpaper",
      "description": "Subreddit for Anime and anime-style wallpapers.",
      "url": "https://imgur.com/u1OyICv.png",
    },
    {
      "name": "Anime Wallpaper NSFW",
      "value": "AnimeWallpaperNSFW",
      "description": "Not Safe for Work Anime Wallpapers.",
      "url": "https://imgur.com/QmeFwcd.png",
    },
    {
      "name": "Anime Wallpapers SFW",
      "value": "AnimeWallpapersSFW",
      "description":
          "Anime wallpapers you'd be comfortable using in the public.",
      "url": "https://imgur.com/wuNYgzg.png",
    },
    {
      "name": "Architecture Porn",
      "value": "ArchitecturePorn",
      "description":
          "High quality images of architecture and the beautiful impossibilities that we want to live in.",
      "url": "https://imgur.com/tkIDfb8.png",
    },
    {
      "name": "Art",
      "value": "art",
      "description": "This is a subreddit about art.",
      "url": "https://imgur.com/Nv2mwDS.png",
    },
    {
      "name": "Car Porn",
      "value": "carporn",
      "description": "The best car photography sub on reddit.",
      "url": "https://imgur.com/otA1QMK.png",
    },
    {
      "name": "Celebs Wallpaper",
      "value": "CelebsWallpaper",
      "description": "Wallpapers of your favorite celebrities!",
      "url": "https://imgur.com/QxFtzaB.png",
    },
    {
      "name": "Comic Walls",
      "value": "comicwalls",
      "description":
          "This is the place for wallpapers (both desktop and mobile) related to comic books, comic strips, cartoons & comic-related movies/television shows/video games, and cosplay!",
      "url": "https://imgur.com/w3gRs77.png",
    },
    {
      "name": "Daily Wallpaper",
      "value": "DailyWallpaper",
      "description": "Your daily dose of mobile aesthetics.",
      "url": "https://imgur.com/xMc4kLx.png",
    },
    {
      "name": "Earth Porn",
      "value": "EarthPorn",
      "description":
          "The internet's largest community of landscape photographers and Earth lovers.",
      "url": "https://imgur.com/zqiMxAF.png",
    },
    {
      "name": "Genshin Wallpapers",
      "value": "Genshin_Wallpaper",
      "description":
          "Computer or Phone Background Images (Wallpaper) related to HoYoverse's Genshin Impact.",
      "url": "https://imgur.com/C2uTghM.png",
    },
    {
      "name": "Honkai Wallpaper",
      "value": "HonkaiWallpaper",
      "description": "Honkai wallpaper and art.",
      "url": "https://imgur.com/tEeP4Vn.png",
    },
    {
      "name": "Imaginary Landscapes",
      "value": "ImaginaryLandscapes",
      "description":
          "Reddit community for your favourite digital or natural media creations of landscapes or scenery. Including, Overgrown jungles, barren planets, futuristic cityscapes, or interiors and more.",
      "url": "https://imgur.com/hYp3ddg.png",
    },
    {
      "name": "iPhone Wallpapers",
      "value": "iphonewallpapers",
      "description": "A place to share your favourite phone wallpapers.",
      "url": "https://imgur.com/dhoG6m3.png",
    },
    {
      "name": "Mobile Wallpaper",
      "value": "MobileWallpaper",
      "description": "Wallpapers for your Phone, and or tablet.",
      "url": "https://imgur.com/n3soGTk.png",
    },
    {
      "name": "Mobile Wallpapers",
      "value": "mobilewallpapers",
      "description":
          "A place to discover wallpapers that work well for mobile devices.",
      "url": "https://imgur.com/cPxYVyH.png",
    },
    {
      "name": "Minimal Wallpaper",
      "value": "MinimalWallpaper",
      "description": "Wallpapers that have a simple and minimalist design.",
      "url": "https://imgur.com/U5THOkb.png",
    },
    {
      "name": "Phone Wallpapers",
      "value": "phonewallpapers",
      "description": "Wallpaper images for people's phones.",
      "url": "https://imgur.com/fOM3qZl.png",
    },
    {
      "name": "Sky Porn",
      "value": "SkyPorn",
      "description": "High quality images of the sky.",
      "url": "https://imgur.com/lmTujsl.png",
    },
    {
      "name": "Spec Art",
      "value": "SpecArt",
      "description":
          "SF, fantasy, and post-apocalypse visual arts. Explore the visual aspects of imagined worlds. All speculative visual arts are welcome, from space vistas to fantasy landscapes to ruined cities to psychedelic paintings to dreaded monsters to f'ing dinosaurs!",
      "url": "https://imgur.com/JFTaoDr.png",
    },
    {
      "name": "Ultra HD Wallpapers",
      "value": "ultrahdwallpapers",
      "description":
          "A new standard is coming to the world of pixel resolutions: Ultra HD or 4K. Here you will find wallpapers to go along with your new gadgets and devices. We'll try to feature ONLY UHD wallpapers.",
      "url": "https://imgur.com/ig0Ns0T.png",
    },
    {
      "name": "Vertical Wallpapers",
      "value": "Verticalwallpapers",
      "description": "A haven for vertical wallpapers.",
      "url": "https://imgur.com/kraaCbt.png",
    },
    {
      "name": "Wallpaper",
      "value": "wallpaper",
      "description": "Computer desktop/background images.",
      "url": "https://imgur.com/KcZ36nl.png",
    },
    {
      "name": "Wallpaper Requests",
      "value": "WallpaperRequests",
      "description":
          "Have an image that just doesn't fit you wallpaper needs? Look no further!",
      "url": "https://imgur.com/TT0onVW.png",
    },
    {
      "name": "Wallpapers",
      "value": "wallpapers",
      "description": "Work-safe wallpapers from all over!",
      "url": "https://imgur.com/b1dvUyw.png",
    },
    {
      "name": "Wallpapers Android",
      "value": "WallpapersAndroid",
      "description":
          "This is a Subreddit for Unique Wallpapers. Including Amoled Wallpapers, Artwork Wallpapers, Graffiti and much more.",
      "url": "https://imgur.com/koP3g09.png",
    },
    {
      "name": "Wallpapers Pro",
      "value": "wallpaperspro",
      "description": "High Definition Wallpapers only.",
      "url": "https://imgur.com/oU19sVo.png",
    },
    {
      "name": "WQHD Wallpaper",
      "value": "WQHD_Wallpaper",
      "description":
          "A subreddit dedicated to the collection of high quality wallpapers for high resolution WQHD and 4K displays.",
      "url": "https://imgur.com/nqenHYe.png",
    }
  ];

  RedditSortType get sortType {
    return RedditSortType.values[sortSelected.indexOf(true)];
  }

  RedditSortRange get sortRange {
    return RedditSortRange.values[rangeSelected.indexOf(true)];
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    final savedFilters =
        Provider.of<RedditFiltersStorageProvider>(context, listen: false)
            .fetch();
    subredditNameController.text = savedFilters['subreddit'];
    sortSelected[savedFilters['sort_type']] = true;
    rangeSelected[savedFilters['sort_range']] = true;
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
                height: 370,
                width: 350,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Filters",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      const Text(
                                        "Subreddit",
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
                                              controller:
                                                  subredditNameController,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  prefixText: "r/",
                                                  suffixIcon: IconButton(
                                                    tooltip: "Presets",
                                                    icon: const Icon(
                                                      Icons.list_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () =>
                                                        tabController
                                                            .animateTo(1),
                                                  ),
                                                  hintText: "Subreddit Name",
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
                                                          BorderRadius.circular(
                                                              20))),
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
                                        selectOnlyOne: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Sort Range",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TogglableButtons(
                                        buttonList: rangeList,
                                        selected: rangeSelected,
                                        selectOnlyOne: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FilledButton(
                                            onPressed:
                                                Navigator.of(context).pop,
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .resolveWith((states) =>
                                                            Theme.of(context)
                                                                .primaryColor
                                                                .withAlpha(
                                                                    120)),
                                                side: WidgetStateBorderSide
                                                    .resolveWith((states) =>
                                                        const BorderSide(
                                                          color: Colors.white,
                                                        ))),
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
                                              final wallpaperListProvider =
                                                  Provider.of<
                                                          WallpaperListProvider>(
                                                      context,
                                                      listen: false);
                                              final redditFilterStorageProvider =
                                                  Provider.of<
                                                          RedditFiltersStorageProvider>(
                                                      context,
                                                      listen: false);

                                              // Save Current Query to History
                                              Provider.of<QueriesStorageProvider>(
                                                      context,
                                                      listen: false)
                                                  .addHistoryQuery(queryProvider
                                                      .currentQuery);
                                              Provider.of<QueriesProvider>(
                                                      context,
                                                      listen: false)
                                                  .addHistoryQuery(queryProvider
                                                      .currentQuery);

                                              redditFilterStorageProvider
                                                  .update(
                                                subreddit:
                                                    subredditNameController
                                                        .text,
                                                sortType:
                                                    sortSelected.indexOf(true),
                                                sortRange:
                                                    rangeSelected.indexOf(true),
                                              );
                                              wallpaperListProvider
                                                  .emptyWallpaperList();
                                              queryProvider.setRedditQuery(
                                                  subredditName:
                                                      subredditNameController
                                                          .text,
                                                  sortType: sortType,
                                                  sortRange: sortRange);
                                              Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .resolveWith((states) =>
                                                            Theme.of(context)
                                                                .primaryColor
                                                                .withAlpha(
                                                                    120)),
                                                side: WidgetStateBorderSide
                                                    .resolveWith((states) =>
                                                        const BorderSide(
                                                          color: Colors.white,
                                                        ))),
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
                            communityNameController: subredditNameController,
                            tabController: tabController,
                            communityList: subredditList,
                            communityStorage:
                                Provider.of<RedditUserCommunitiesStorage>(
                                    context,
                                    listen: false),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
