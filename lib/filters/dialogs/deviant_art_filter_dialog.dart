import 'dart:async';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/filters/widgets/community_list_widget.dart';
import 'package:wallpaper_app/filters/widgets/togglable_buttons.dart';
import 'package:wallpaper_app/home/providers/deviant_art_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';

class DeviantArtFilterDialog extends StatefulWidget {
  const DeviantArtFilterDialog({super.key});

  @override
  State<DeviantArtFilterDialog> createState() => _DeviantArtFilterDialogState();
}

class _DeviantArtFilterDialogState extends State<DeviantArtFilterDialog>
    with SingleTickerProviderStateMixin {
  late bool matureContent;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    final savedFilters =
        Provider.of<DeviantArtFiltersStorageProvider>(context, listen: false)
            .fetch();
    matureContent = savedFilters['mature_content'] as bool;
    final int page = savedFilters['page'];
    tabController.animateTo(duration: Duration.zero, page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
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
                            side: const BorderSide(color: Colors.white),
                            checkColor: Theme.of(context).primaryColor,
                            activeColor: Colors.white,
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
                      SizedBox(
                        height: 370,
                        child: SingleChildScrollView(
                            child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                controller: tabController,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Text(
                                    "By Tag",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "By Topic",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 330,
                                child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TagTab(matureContent),
                                      ),
                                      TopicTab(matureContent),
                                    ]),
                              )
                            ],
                          ),
                        )),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicTab extends StatefulWidget {
  const TopicTab(this.matureContent, {super.key});
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
  bool refreshList = false;

  @override
  void initState() {
    final savedFilters =
        Provider.of<DeviantArtFiltersStorageProvider>(context, listen: false)
            .fetch();
    String? topic = savedFilters['topic'];
    if (topic == null || topic.isEmpty) {
      topic = "characterillustration";
    }
    topicController = TextEditingController(text: topic);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    topicController.dispose();
    super.dispose();
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(
                      Icons.label_important_outline_rounded,
                      color: Colors.white.withAlpha(180),
                    ),
                    suffixIcon: IconButton(
                      tooltip: "Topic List",
                      icon: const Icon(Icons.list_rounded),
                      color: Colors.white,
                      onPressed: () => tabController.animateTo(1),
                    ),
                    hintText: "Enter predefined topic",
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10, vertical: 2),
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_upward_rounded, color: Colors.white)
                    ]),
                const Text(
                  "Top Topics",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder(
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
                              (e) => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Shimmer.fromColors(
                                  enabled: true,
                                  baseColor: Colors.grey.withAlpha(80),
                                  highlightColor: Colors.white70,
                                  child: Container(
                                    height: 35,
                                    width: 60,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
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
                style: ButtonStyle(
                  side: WidgetStateProperty.resolveWith(
                      (states) => const BorderSide(color: Colors.white)),
                  backgroundColor: WidgetStateProperty.resolveWith((states) =>
                      Theme.of(context).primaryColor.withAlpha(120)),
                ),
                child: const Text("Cancel"),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton(
                onPressed: () {
                  final queryProvider =
                      Provider.of<QueryProvider>(context, listen: false);
                  final filterStorageProvider =
                      Provider.of<DeviantArtFiltersStorageProvider>(context,
                          listen: false);
                  final savedFilters =
                      Provider.of<DeviantArtFiltersStorageProvider>(context,
                              listen: false)
                          .fetch();

                  // Save Current Query to History
                  Provider.of<QueriesStorageProvider>(context, listen: false)
                      .addHistoryQuery(queryProvider.currentQuery);
                  Provider.of<QueriesProvider>(context, listen: false)
                      .addHistoryQuery(queryProvider.currentQuery);

                  filterStorageProvider.update(
                    topic: topicController.text,
                    tag: savedFilters['tag'],
                    page: 1,
                    matureContent: widget.matureContent,
                  );
                  wallpaperListProvider.emptyWallpaperList();
                  queryProvider.setDeviantArtQuery(
                      topic: topicController.text,
                      matureContent: widget.matureContent);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  side: WidgetStateProperty.resolveWith(
                      (states) => const BorderSide(color: Colors.white)),
                  backgroundColor: WidgetStateProperty.resolveWith((states) =>
                      Theme.of(context).primaryColor.withAlpha(120)),
                ),
                child: const Text("Ok"),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ]),
        FutureBuilder(
            future: deviantArtProvider.deviantArtAllTopics(
                deviantArtFiltersStorageProvider:
                    Provider.of<DeviantArtFiltersStorageProvider>(context,
                        listen: false),
                refreshList: refreshList),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return CommunityListWidget(
                  communityNameController: topicController,
                  tabController: tabController,
                  communityList: snapshot.data!,
                  refreshMethod: () {
                    setState(() {
                      refreshList = true;
                    });
                  },
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                            enabled: true,
                            baseColor: Colors.grey.withAlpha(80),
                            highlightColor: Colors.white70,
                            child: Card(
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                height: 40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Shimmer.fromColors(
                          enabled: true,
                          baseColor: Colors.grey.withAlpha(80),
                          highlightColor: Colors.white70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black, shape: BoxShape.circle),
                              margin: const EdgeInsets.all(3),
                              width: 45,
                              height: 45,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Shimmer.fromColors(
                          enabled: true,
                          baseColor: Colors.grey.withAlpha(80),
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
                        padding: const EdgeInsets.only(top: 5),
                      ),
                    ),
                  ],
                );
              }
            })
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
    final savedFilters =
        Provider.of<DeviantArtFiltersStorageProvider>(context, listen: false)
            .fetch();
    final String? tag = savedFilters['tag'];
    tagController = TextEditingController(text: tag);
    super.initState();
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
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
            Expanded(
              child: TextFormField(
                controller: tagController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(
                    Icons.label_outline_rounded,
                    color: Colors.white.withAlpha(180),
                  ),
                  hintText: "3 or more characters without spaces",
                  contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 2),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
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
                      : FutureBuilder(
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
                                  : Expanded(
                                      child: SingleChildScrollView(
                                          child: TogglableButtons(
                                        buttonList: tags,
                                        selected: tagsSelected,
                                        controller: tagController,
                                        selectOnlyOne: true,
                                        wrapChildren: true,
                                      )),
                                    );
                            } else {
                              return Wrap(
                                children: List.generate(7, (index) => index)
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Shimmer.fromColors(
                                            enabled: true,
                                            baseColor:
                                                Colors.grey.withAlpha(80),
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
                ],
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
            style: ButtonStyle(
              side: WidgetStateProperty.resolveWith(
                  (states) => const BorderSide(color: Colors.white)),
              backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => Theme.of(context).primaryColor.withAlpha(120)),
            ),
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
              final filterStorageProvider =
                  Provider.of<DeviantArtFiltersStorageProvider>(context,
                      listen: false);
              final savedFilters =
                  Provider.of<DeviantArtFiltersStorageProvider>(context,
                          listen: false)
                      .fetch();

              // Save Current Query to History
              Provider.of<QueriesProvider>(context, listen: false)
                  .addHistoryQuery(queryProvider.currentQuery);

              filterStorageProvider.update(
                tag: tagController.text,
                topic: savedFilters['topic'],
                page: 0,
                matureContent: widget.matureContent,
              );
              wallpaperListProvider.emptyWallpaperList();
              queryProvider.setDeviantArtQuery(
                tag: tagController.text,
                matureContent: widget.matureContent,
              );
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              side: WidgetStateProperty.resolveWith(
                  (states) => const BorderSide(color: Colors.white)),
              backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => Theme.of(context).primaryColor.withAlpha(120)),
            ),
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
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(10.0),
          dashPattern: const [6, 12],
          strokeCap: StrokeCap.round,
          strokeWidth: 3,
          padding: const EdgeInsets.all(5),
          color: Colors.grey,
        ),
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
