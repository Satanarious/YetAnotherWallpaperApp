import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/enums/purity.dart';
import '../providers/providers.dart';

class WallhavenFilterDialog extends StatefulWidget {
  const WallhavenFilterDialog({super.key});

  @override
  State<WallhavenFilterDialog> createState() => _WallhavenFilterDialogState();
}

class _WallhavenFilterDialogState extends State<WallhavenFilterDialog> {
  bool isTop = true;
  var tag1 = "";
  var includeTag1 = true;
  var tag2 = "";
  var includeTag2 = true;
  var categorySelected = [true, true, true];
  var puritySelected = [true, false, false];
  var sortBy = WallhavenSortingType.toplist;
  var topRange = WallhavenTopRange.oneMonth;
  var ratioSelected = [false, false, true];

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
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: const Color.fromRGBO(50, 50, 50, 1),
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 14, vertical: 10),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
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
                    children: [
                      const SizedBox(
                        height: 14,
                      ),
                      const Text(
                        "Tags",
                        style: TextStyle(color: Colors.white, fontSize: 14),
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
                                  hintText: "Primary Tag",
                                  contentPadding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 10, vertical: 2),
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          InclusionSwitch((bool value) => includeTag1 = value),
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
                              decoration: InputDecoration(
                                  hintText: "Secondary Tag",
                                  contentPadding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 10, vertical: 2),
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          InclusionSwitch((bool value) => includeTag2 = value),
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
                      Row(
                        children: [
                          ThreeChlildrenToggleButtons(
                            buttonTexts: const ["General", "Anime", "People"],
                            selected: categorySelected,
                          ),
                        ],
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
                      Row(
                        children: [
                          ThreeChlildrenToggleButtons(
                            buttonTexts: const ["General", "Sketchy", "NSFW"],
                            selected: puritySelected,
                          ),
                        ],
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
                      Row(
                        children: [
                          SizedBox(
                            child: DropdownMenu(
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
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isTop
                          ? Column(
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
                                  Row(
                                    children: [
                                      DropdownMenu(
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
                                      )
                                    ],
                                  ),
                                ])
                          : Container(),
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
                      Row(
                        children: [
                          ThreeChlildrenToggleButtons(
                            buttonTexts: const ["Portrait", "Landscape", "All"],
                            selected: ratioSelected,
                            selectOnlyOne: true,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
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
                        final queryProvider =
                            Provider.of<QueryProvider>(context, listen: false);
                        final wallpaperListProvider =
                            Provider.of<WallpaperListProvider>(context,
                                listen: false);
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
      ),
    );
  }
}

class ThreeChlildrenToggleButtons extends StatefulWidget {
  const ThreeChlildrenToggleButtons({
    required this.buttonTexts,
    required this.selected,
    super.key,
    this.selectOnlyOne = false,
  });
  final List<String> buttonTexts;
  final List<bool> selected;
  final bool selectOnlyOne;

  @override
  State<ThreeChlildrenToggleButtons> createState() =>
      _ThreeChlildrenToggleButtonsState();
}

class _ThreeChlildrenToggleButtonsState
    extends State<ThreeChlildrenToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      renderBorder: false,
      fillColor: const Color.fromRGBO(50, 50, 50, 1),
      isSelected: widget.selected,
      children: widget.buttonTexts
          .map((buttonText) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color:
                        widget.selected[widget.buttonTexts.indexOf(buttonText)]
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ))
          .toList(),
      onPressed: (index) {
        if (widget.selected.where((element) => element == true).length == 1 &&
            widget.selected[index]) {
          return; // Insure selection of atleast one button
        }
        if (widget.selectOnlyOne) {
          // Allow one selection at a time
          setState(() {
            for (int i = 0; i < 3; i++) {
              widget.selected[i] = (i == index);
            }
          });
        } else {
          setState(() {
            widget.selected[index] = !widget.selected[index];
          });
        }
      },
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
    return GestureDetector(
      onTap: () {
        setState(() {
          val = !val;
        });
        widget.onValueChange(val);
      },
      child: Container(
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(50, 50, 50, 1)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: Colors.white),
                    color: val
                        ? Colors.white
                        : const Color.fromRGBO(50, 50, 50, 1)),
                child: Center(
                    child: Text(
                  '+',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: val ? Colors.black : Colors.white),
                )),
              ),
              Container(
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: Colors.white),
                    color: val
                        ? const Color.fromRGBO(50, 50, 50, 1)
                        : Colors.white),
                child: Center(
                    child: Text(
                  '-',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: val ? Colors.white : Colors.black),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
