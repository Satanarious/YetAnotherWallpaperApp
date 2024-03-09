import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/widgets/community_list_widget.dart';
import 'package:wallpaper_app/widgets/togglable_buttons.dart';

import '../providers/providers.dart';

class DeviantArtFilterDialog extends StatefulWidget {
  const DeviantArtFilterDialog({super.key});

  @override
  State<DeviantArtFilterDialog> createState() => _DeviantArtFilterDialogState();
}

class _DeviantArtFilterDialogState extends State<DeviantArtFilterDialog> {
  var matureContent = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isVertical = size.height > size.width;
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: const Color.fromRGBO(50, 50, 50, 1),
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 14, vertical: 10),
          height: isVertical ? 385 : 340,
          width: 350,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Filters",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: matureContent,
                      onChanged: (value) => setState(() {
                        matureContent = !matureContent;
                      }),
                    ),
                    const Text(
                      "18+",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DefaultTabController(
                        length: 3,
                        child: SizedBox(
                          height: 330,
                          child: Column(
                            children: [
                              const TabBar(
                                labelColor: Colors.grey,
                                dividerColor: Colors.transparent,
                                tabs: [
                                  Text(
                                    "By Tag",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "By Topic",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "By Query",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 290,
                                child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      TagTab(matureContent),
                                      TopicTab(matureContent),
                                      QueryTab(matureContent),
                                    ]),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class TopicTab extends StatefulWidget {
  const TopicTab(
    this.matureContent, {
    super.key,
  });
  final bool matureContent;

  @override
  State<TopicTab> createState() => _TopicTabState();
}

class _TopicTabState extends State<TopicTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TextEditingController topicController;
  late TabController tabController;
  late List<Map<String, dynamic>> topics;
  late List<bool> topicSelected;

  @override
  void initState() {
    topicController = TextEditingController();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final wallpaperListProvider =
        Provider.of<WallpaperListProvider>(context, listen: false);
    final deviantArtProvider = DeviantArtProvider();
    super.build(context);
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Topic",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: topicController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (value) => topicController.text = value,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      tooltip: "Topic List",
                      icon: const Icon(Icons.list),
                      color: Colors.white,
                      onPressed: () => tabController.animateTo(1),
                    ),
                    hintText: "Enter predefined topic",
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10, vertical: 2),
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.arrow_upward, color: Colors.white)]),
                const Text(
                  "Top Topics",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: deviantArtProvider.deviantArtTopTopics,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        topics = snapshot.data!;
                        topicSelected =
                            List.generate(topics.length, (index) => false);
                        return SingleChildScrollView(
                            child: TogglableButtons(
                          buttonList: topics,
                          selected: topicSelected,
                          controller: topicController,
                          selectOnlyOne: true,
                          wrapChildren: true,
                        ));
                      } else {
                        return Wrap(
                          children: List.generate(7, (index) => index)
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Shimmer.fromColors(
                                      enabled: true,
                                      baseColor: Colors.grey,
                                      highlightColor: Colors.white70,
                                      child: Container(
                                        height: 35,
                                        width: 60,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Cancel"),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton(
                onPressed: () {
                  final queryProvider =
                      Provider.of<QueryProvider>(context, listen: false);

                  queryProvider.setDeviantArtQuery(
                      topic: topicController.text,
                      matureContent: widget.matureContent);
                  wallpaperListProvider.emptyWallpaperList();
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ]),
        FutureBuilder(
            future: deviantArtProvider.deviantArtAllTopics,
            builder: (context, snapshot) => snapshot.hasData
                ? CommunityListWidget(
                    communityNameController: topicController,
                    tabController: tabController,
                    communityList: snapshot.data!)
                : ListView.builder(
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      enabled: true,
                      baseColor: Colors.grey,
                      highlightColor: Colors.white70,
                      child: Card(
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          height: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    itemCount: 5,
                  ))
      ],
    );
  }
}

class TagTab extends StatefulWidget {
  const TagTab(
    this.matureContent, {
    super.key,
  });
  final bool matureContent;
  @override
  State<TagTab> createState() => _TagTabState();
}

class _TagTabState extends State<TagTab> {
  late TextEditingController tagController;
  Timer? _debounce;
  final deviantArtProvider = DeviantArtProvider();

  @override
  void initState() {
    tagController = TextEditingController();
    super.initState();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Tag",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: tagController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.label),
                hintText: "3 or more characters without spaces",
                contentPadding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 2),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Or",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Text(
              "Predefined Tags",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            tagController.text.length < 3
                ? const DottedContainer(
                    "Similar tags will load as you start writing in the tag field.")
                : Expanded(
                    child: FutureBuilder(
                      future: deviantArtProvider
                          .getDeviantArtSeachTags(tagController.text),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final tags = snapshot.data!
                            ..sort(
                              (a, b) => (a['name'] as String)
                                  .length
                                  .compareTo((b['name'] as String).length),
                            );
                          final tagsSelected =
                              List.generate(tags.length, (index) => false);
                          return tags.isEmpty
                              ? const DottedContainer(
                                  "No similar tags found for the corresponding tag")
                              : SingleChildScrollView(
                                  child: TogglableButtons(
                                  buttonList: tags,
                                  selected: tagsSelected,
                                  controller: tagController,
                                  selectOnlyOne: true,
                                  wrapChildren: true,
                                ));
                        } else {
                          return Wrap(
                            children: List.generate(7, (index) => index)
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Shimmer.fromColors(
                                        enabled: true,
                                        baseColor: Colors.grey,
                                        highlightColor: Colors.white70,
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          const SizedBox(
            width: 20,
          ),
          FilledButton(
            onPressed: () {
              final queryProvider =
                  Provider.of<QueryProvider>(context, listen: false);
              final wallpaperListProvider =
                  Provider.of<WallpaperListProvider>(context, listen: false);
              queryProvider.setDeviantArtQuery(
                tag: tagController.text,
                matureContent: widget.matureContent,
              );
              wallpaperListProvider.emptyWallpaperList();
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
    ]);
  }
}

class DottedContainer extends StatelessWidget {
  const DottedContainer(
    this.text, {
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.round,
        dashPattern: const [6, 12],
        strokeWidth: 3,
        radius: const Radius.circular(10),
        padding: const EdgeInsets.all(5),
        color: Colors.grey,
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}

class QueryTab extends StatefulWidget {
  const QueryTab(
    this.matureContent, {
    super.key,
  });
  final bool matureContent;

  @override
  State<QueryTab> createState() => _QueryTabState();
}

class _QueryTabState extends State<QueryTab> {
  static const sortList = ['Popular', 'Newest'];
  var isPopular = true;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Query",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (value) => query = value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search anything here...",
                  contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 2),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Sort Type",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownMenu(
                leadingIcon: const Icon(Icons.filter_alt),
                initialSelection: true,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  constraints: BoxConstraints.tight(const Size.fromHeight(50)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                textStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                dropdownMenuEntries: sortList
                    .map((item) => DropdownMenuEntry(
                        value: item == 'Popular', label: item))
                    .toList(),
                onSelected: (sortType) => isPopular = sortType!,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Cancel"),
            ),
            const SizedBox(
              width: 20,
            ),
            FilledButton(
              onPressed: () {
                final queryProvider =
                    Provider.of<QueryProvider>(context, listen: false);
                final wallpaperListProvider =
                    Provider.of<WallpaperListProvider>(context, listen: false);
                queryProvider.setDeviantArtQuery(
                  searchQuery: query,
                  isPopular: isPopular,
                  matureContent: widget.matureContent,
                );
                wallpaperListProvider.emptyWallpaperList();
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
