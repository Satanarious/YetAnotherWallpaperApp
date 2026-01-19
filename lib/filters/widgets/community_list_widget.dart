import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommunityListWidget extends StatefulWidget {
  const CommunityListWidget({
    super.key,
    required this.communityNameController,
    required this.tabController,
    required this.communityList,
    this.refreshMethod,
    this.communityStorage,
    this.height = 250,
  });

  final TextEditingController communityNameController;
  final TabController tabController;
  final List communityList;
  final dynamic refreshMethod;
  final dynamic communityStorage;
  final double height;

  @override
  State<CommunityListWidget> createState() => _CommunityListWidgetState();
}

class _CommunityListWidgetState extends State<CommunityListWidget>
    with SingleTickerProviderStateMixin {
  var searchQuery = '';
  late ScrollController _scrollController;
  late TabController communityTabController;
  late List userAddedCommunitiesList;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    userAddedCommunitiesList = widget.communityStorage.fetch();
    communityTabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll animation after list builds
      _scrollController.jumpTo(100);
      _scrollController.animateTo(
        -100,
        duration: const Duration(milliseconds: 800),
        curve: Curves.decelerate,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildCommunitiesList({
    required List list,
    required String searchQuery,
    bool isDeletable = false,
  }) {
    final filteredList = searchQuery.isEmpty
        ? list
        : list
            .where((community) => community['name']!.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ))
            .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: filteredList.length,
            controller: _scrollController,
            itemBuilder: (context, index) => Dismissible(
              key: Key(index.toString()),
              onDismissed: (direction) {
                setState(() {
                  userAddedCommunitiesList.removeAt(index);
                });
                widget.communityStorage.update(userAddedCommunitiesList);
              },
              direction: isDeletable
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  )),
              child: Card(
                color: Colors.black54,
                elevation: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      image: filteredList[index]['url'] != null
                          ? DecorationImage(
                              opacity: 0.3,
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  filteredList[index]['url'] as String),
                            )
                          : null,
                    ),
                    child: ListTile(
                      onTap: () {
                        widget.communityNameController.text =
                            filteredList[index]["value"] as String;
                        widget.tabController.animateTo(0);
                      },
                      title: Row(
                        children: [
                          const Icon(Icons.radio_button_off,
                              color: Colors.white),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              filteredList[index]["name"] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      subtitle: filteredList[index]["description"] != null
                          ? Text(filteredList[index]["description"] as String,
                              style: const TextStyle(color: Colors.grey))
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: Image.asset(
              "assets/empty.gif",
              width: 300,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final canRefresh = widget.refreshMethod != null;
    final hasUserAddedCommunitiesList = widget.communityStorage != null;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Search by name",
                        contentPadding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10, vertical: 2),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: canRefresh || hasUserAddedCommunitiesList ? 5 : 0,
                  ),
                  canRefresh
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            tooltip: "Refresh",
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                            onPressed: widget.refreshMethod,
                          ),
                        )
                      : const SizedBox.shrink(),
                  hasUserAddedCommunitiesList
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            tooltip: "Save to User Added",
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (searchQuery.isEmpty ||
                                    userAddedCommunitiesList
                                        .contains(searchQuery)) {
                                  return;
                                }
                                userAddedCommunitiesList.insert(0, {
                                  "name": searchQuery,
                                  "value": searchQuery,
                                });
                                searchQuery = "";
                                communityTabController.animateTo(1);
                                widget.communityStorage
                                    .update(userAddedCommunitiesList);
                              });
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              !hasUserAddedCommunitiesList
                  ? Expanded(
                      child: buildCommunitiesList(
                        list: widget.communityList,
                        searchQuery: searchQuery,
                      ),
                    )
                  : Column(
                      children: [
                        TabBar(
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          tabs: const [
                            Tab(
                              text: "Recommended",
                            ),
                            Tab(text: "User Added")
                          ],
                          controller: communityTabController,
                        ),
                        SizedBox(
                          height: widget.height,
                          child: TabBarView(
                            controller: communityTabController,
                            children: [
                              buildCommunitiesList(
                                list: widget.communityList,
                                searchQuery: searchQuery,
                              ),
                              buildCommunitiesList(
                                  list: userAddedCommunitiesList,
                                  searchQuery: searchQuery,
                                  isDeletable: true),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
