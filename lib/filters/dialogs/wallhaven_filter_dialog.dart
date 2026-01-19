import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/common/widgets/custom_drop_down_menu.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/filters/widgets/togglable_buttons.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/wallhaven_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

class WallhavenFilterDialog extends StatefulWidget {
  const WallhavenFilterDialog({super.key});

  @override
  State<WallhavenFilterDialog> createState() => _WallhavenFilterDialogState();
}

class _WallhavenFilterDialogState extends State<WallhavenFilterDialog>
    with SingleTickerProviderStateMixin {
  bool isTop = true;
  String tag1 = '';
  late TabController tabController;
  var includeTag1 = true;
  var tag2 = "";
  var includeTag2 = true;
  var categorySelected = [false, false, false];
  var puritySelected = [false, false, false];
  var sortBy = WallhavenSortingType.toplist;
  var topRange = WallhavenTopRange.oneMonth;
  var ratioSelected = [false, false, false];

  static const categoryList = [
    {"name": "General", "icon": Icons.all_inbox_rounded},
    {"name": "Anime", "icon": Icons.wallet_giftcard_rounded},
    {"name": "People", "icon": Icons.people_outline_rounded},
  ];
  static const ratioList = [
    {"name": "Portrait", "icon": Icons.tablet_android_rounded},
    {"name": "Landscape", "icon": Icons.tablet_rounded},
    {"name": "All", "icon": Icons.filter_rounded},
  ];
  static const purityList = [
    {"name": "General", "icon": Icons.all_inbox_rounded},
    {"name": "Sketchy", "icon": Icons.strikethrough_s_rounded},
    {"name": "NSFW", "icon": Icons.no_adult_content_rounded},
  ];
  static const sortByList = [
    {'label': 'Date Added', 'value': WallhavenSortingType.dateAdded},
    {'label': 'Favourites', 'value': WallhavenSortingType.favourites},
    {'label': 'Random', 'value': WallhavenSortingType.random},
    {'label': 'Relevance', 'value': WallhavenSortingType.relevance},
    {'label': 'Top', 'value': WallhavenSortingType.toplist},
    {'label': 'Views', 'value': WallhavenSortingType.views},
  ];
  static const topRangeList = [
    {'label': 'One Day', 'value': WallhavenTopRange.oneDay},
    {'label': 'Three Days', 'value': WallhavenTopRange.threeDays},
    {'label': 'One Week', 'value': WallhavenTopRange.oneWeek},
    {'label': 'One Month', 'value': WallhavenTopRange.oneMonth},
    {'label': 'Three Months', 'value': WallhavenTopRange.threeMonths},
    {'label': 'Six Months', 'value': WallhavenTopRange.sixMonths},
    {'label': 'One Year', 'value': WallhavenTopRange.oneYear},
  ];

  late ScrollController _scrollController;

  List<WallhavenCategory> get categories {
    final List<WallhavenCategory> categoryList = [];
    for (int i = 0; i < 3; i++) {
      if (categorySelected[i]) {
        categoryList.add(WallhavenCategory.values[i]);
      }
    }
    return categoryList;
  }

  List<PurityType> get purities {
    final List<PurityType> purityList = [];
    for (int i = 0; i < 3; i++) {
      if (puritySelected[i]) {
        purityList.add(PurityType.values[i]);
      }
    }
    return purityList;
  }

  WallhavenAspectRatioType get ratio {
    return WallhavenAspectRatioType.values[ratioSelected.indexOf(true)];
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    final savedFilters =
        Provider.of<WallhavenFiltersStorageProvider>(context, listen: false)
            .fetch();
    tag1 = savedFilters['primary_tag'];
    tag2 = savedFilters['secondary_tag'];
    includeTag1 = savedFilters['include_tag1'];
    includeTag2 = savedFilters['include_tag2'];
    for (int i = 0; i < 3; i++) {
      categorySelected[i] = savedFilters['category'][i];
      puritySelected[i] = savedFilters['purity'][i];
    }
    sortBy = WallhavenSortingType.values[savedFilters['sort']];
    topRange = WallhavenTopRange.values[savedFilters['top_range']];
    ratioSelected[savedFilters['ratio']] = true;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
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
            height: 500,
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Tags",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: "Popular Tags",
                                  icon: const Icon(
                                    Icons.list_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => tabController.animateTo(1),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: tag1,
                                    onChanged: (value) => tag1 = value,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        prefixIcon: InclusionSwitch(
                                            includeTag1,
                                            (bool value) =>
                                                includeTag1 = value),
                                        hintText: "Primary Tag",
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .symmetric(
                                                horizontal: 10, vertical: 2),
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: tag2,
                                    onChanged: (value) => tag2 = value,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        prefixIcon: InclusionSwitch(
                                            includeTag2,
                                            (bool value) =>
                                                includeTag2 = value),
                                        hintText: "Secondary Tag",
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .symmetric(
                                                horizontal: 10, vertical: 2),
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Category",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TogglableButtons(
                              buttonList: categoryList,
                              selected: categorySelected,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Purity",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TogglableButtons(
                              buttonList: purityList,
                              selected: puritySelected,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Sort by",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomDropDownMenu(
                                icon: Icons.sort,
                                dropdownMenuEntries: sortByList
                                    .map((item) => DropdownMenuEntry(
                                          value: item['value'],
                                          label: item['label'] as String,
                                          style: ButtonStyle(
                                            foregroundColor:
                                                WidgetStateColor.resolveWith(
                                                    (states) => Colors.white),
                                          ),
                                        ))
                                    .toList(),
                                initialSelection: sortBy,
                                onSelected: (sortType) {
                                  sortBy = (sortType as WallhavenSortingType);
                                  setState(() {
                                    isTop = sortType ==
                                        WallhavenSortingType.toplist;
                                  });
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isTop ? 80 : 0,
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Top range",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      DropdownMenu(
                                        leadingIcon: Icon(Icons.date_range,
                                            color: Colors.white.withAlpha(180)),
                                        initialSelection: topRange,
                                        textStyle: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        menuStyle: MenuStyle(
                                            backgroundColor: WidgetStateColor
                                                .resolveWith((states) =>
                                                    WidgetStateColor.resolveWith(
                                                        (states) => Colors.black
                                                            .withAlpha(210))),
                                            shape: WidgetStateProperty.resolveWith(
                                                (states) => RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(20))),
                                            side: WidgetStateBorderSide.resolveWith((states) => const BorderSide(
                                                  color: Colors.white,
                                                ))),
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                          constraints: BoxConstraints.tight(
                                              const Size.fromHeight(50)),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        dropdownMenuEntries: topRangeList
                                            .map((item) => DropdownMenuEntry(
                                                  value: item['value'],
                                                  label:
                                                      item['label'] as String,
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                        WidgetStateColor
                                                            .resolveWith(
                                                                (states) =>
                                                                    Colors
                                                                        .white),
                                                  ),
                                                ))
                                            .toList(),
                                        onSelected: (topRangeType) => topRange =
                                            (topRangeType as WallhavenTopRange),
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Ratio",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TogglableButtons(
                              buttonList: ratioList,
                              selected: ratioSelected,
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
                                    child: const Text("Cancel")),
                                const SizedBox(
                                  width: 10,
                                ),
                                FilledButton(
                                    onPressed: () {
                                      final wallhavenFilterStorageProvider =
                                          Provider.of<
                                                  WallhavenFiltersStorageProvider>(
                                              context,
                                              listen: false);
                                      final wallhavenApiKey =
                                          Provider.of<SettingsProvider>(context,
                                                  listen: false)
                                              .wallhavenApiKey;

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

                                      wallhavenFilterStorageProvider.update(
                                        primaryTag: tag1,
                                        secondaryTag: tag2,
                                        includeTag1: includeTag1,
                                        includeTag2: includeTag2,
                                        category: categorySelected,
                                        purity: puritySelected,
                                        sort: sortBy.index,
                                        topRange: topRange.index,
                                        ratio: ratioSelected.indexOf(true),
                                      );
                                      wallpaperListProvider
                                          .emptyWallpaperList();
                                      queryProvider.setWallhavenQuery(
                                          tag1: tag1 == "" ? null : tag1,
                                          includeTag1: includeTag1,
                                          tag2: tag2 == "" ? null : tag2,
                                          includeTag2: includeTag2,
                                          categories: categories,
                                          purities: purities,
                                          sorting: sortBy,
                                          topRange: topRange,
                                          ratio: ratio,
                                          apiKey: wallhavenApiKey);
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
                                    child: const Text("Ok")),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: WallhavenProvider.getPopularTags(),
                        builder: (context, snapshot) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Scroll animation after list builds
                            _scrollController.jumpTo(150);
                            _scrollController.animateTo(
                              -150,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.decelerate,
                            );
                          });
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              controller: _scrollController,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: snapshot.data!
                                    .map((tag) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 6),
                                          child: GestureDetector(
                                            onTap: () {
                                              queryProvider.setWallhavenQuery(
                                                  tagId: tag['id']);
                                              wallpaperListProvider
                                                  .emptyWallpaperList();
                                              Navigator.of(context).pop();
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 6, sigmaY: 6),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black
                                                        .withAlpha(50),
                                                  ),
                                                  child: Text(
                                                    tag['name'] as String,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: List.generate(90, (index) => index)
                                    .map((index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 6),
                                          child: Shimmer.fromColors(
                                            enabled: true,
                                            baseColor:
                                                Colors.grey.withAlpha(80),
                                            highlightColor: Colors.white70,
                                            child: Container(
                                              height: 35,
                                              width: index % 3 == 0
                                                  ? 50
                                                  : index % 3 == 1
                                                      ? 40
                                                      : 60,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color.fromRGBO(
                                                    50, 50, 50, 1),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InclusionSwitch extends StatefulWidget {
  const InclusionSwitch(this.initialValue, this.onValueChange, {super.key});
  final bool initialValue;
  final dynamic onValueChange;

  @override
  State<InclusionSwitch> createState() => _InclusionSwitchState();
}

class _InclusionSwitchState extends State<InclusionSwitch> {
  late bool val;

  @override
  void initState() {
    val = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "Toggle Inclusion",
        onPressed: () {
          setState(() {
            val = !val;
          });
          widget.onValueChange(val);
        },
        icon: Icon(
          val ? Icons.add : Icons.remove,
          color: Colors.white,
        ));
  }
}
