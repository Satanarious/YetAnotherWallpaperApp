import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/enums/purity.dart';
import 'package:wallpaper_app/providers/providers.dart';
import 'package:wallpaper_app/providers/wallhaven_provider.dart';
import 'package:wallpaper_app/widgets/togglable_buttons.dart';

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
  var categorySelected = [true, true, true];
  var puritySelected = [true, false, false];
  var sortBy = WallhavenSortingType.toplist;
  var topRange = WallhavenTopRange.oneMonth;
  var ratioSelected = [false, false, true];

  static const categoryList = [
    {"name": "General", "icon": Icons.all_inbox},
    {"name": "Anime", "icon": Icons.wallet_giftcard_outlined},
    {"name": "People", "icon": Icons.people},
  ];
  static const ratioList = [
    {"name": "Portrait", "icon": Icons.tablet_android},
    {"name": "Landscape", "icon": Icons.tablet},
    {"name": "All", "icon": Icons.filter},
  ];
  static const purityList = [
    {"name": "General", "icon": Icons.all_inbox_rounded},
    {"name": "Sketchy", "icon": Icons.strikethrough_s},
    {"name": "NSFW", "icon": Icons.no_adult_content},
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: const Color.fromRGBO(50, 50, 50, 1),
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
                                  Icons.list,
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
                                child: TextField(
                                  onChanged: (value) => tag1 = value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                      prefixIcon: InclusionSwitch(
                                          (bool value) => includeTag1 = value),
                                      hintText: "Primary Tag",
                                      contentPadding:
                                          const EdgeInsetsDirectional.symmetric(
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
                                child: TextField(
                                  onChanged: (value) => tag2 = value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                      prefixIcon: InclusionSwitch(
                                          (bool value) => includeTag2 = value),
                                      hintText: "Secondary Tag",
                                      contentPadding:
                                          const EdgeInsetsDirectional.symmetric(
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
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownMenu(
                            leadingIcon: const Icon(Icons.sort),
                            inputDecorationTheme: InputDecorationTheme(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(50)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            initialSelection: WallhavenSortingType.toplist,
                            textStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            dropdownMenuEntries: sortByList
                                .map((item) => DropdownMenuEntry(
                                    value: item['value'],
                                    label: item['label'] as String))
                                .toList(),
                            onSelected: (sortType) {
                              sortBy = (sortType as WallhavenSortingType);
                              setState(() {
                                isTop =
                                    sortType == WallhavenSortingType.toplist;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: isTop ? 80 : 0,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      leadingIcon: const Icon(Icons.date_range),
                                      initialSelection:
                                          WallhavenTopRange.oneMonth,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
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
                                      textStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      dropdownMenuEntries: topRangeList
                                          .map((item) => DropdownMenuEntry(
                                              value: item['value'],
                                              label: item['label'] as String))
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
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
                                  child: const Text("Cancel")),
                              const SizedBox(
                                width: 10,
                              ),
                              FilledButton(
                                  onPressed: () {
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
                                    );
                                    wallpaperListProvider.emptyWallpaperList();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Ok")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: WallhavenProvider.getPopularTags(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: snapshot.data!
                                  .map((tag) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3, vertical: 2),
                                        child: GestureDetector(
                                          onTap: () {
                                            queryProvider.setWallhavenQuery(
                                                tagId: tag['id']);
                                            wallpaperListProvider
                                                .emptyWallpaperList();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromRGBO(
                                                  50, 50, 50, 1),
                                            ),
                                            child: Text(
                                              tag['name'] as String,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
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
                                            horizontal: 3, vertical: 2),
                                        child: Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Colors.grey,
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
    );
  }
}

class InclusionSwitch extends StatefulWidget {
  const InclusionSwitch(this.onValueChange, {super.key});
  final dynamic onValueChange;

  @override
  State<InclusionSwitch> createState() => _InclusionSwitchState();
}

class _InclusionSwitchState extends State<InclusionSwitch> {
  var val = true;
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
