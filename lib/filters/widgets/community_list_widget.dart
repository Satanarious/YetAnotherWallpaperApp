import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommunityListWidget extends StatefulWidget {
  const CommunityListWidget({
    super.key,
    required this.communityNameController,
    required this.tabController,
    required this.communityList,
  });

  final TextEditingController communityNameController;
  final TabController tabController;
  final List<Map<String, dynamic>> communityList;

  @override
  State<CommunityListWidget> createState() => _CommunityListWidgetState();
}

class _CommunityListWidgetState extends State<CommunityListWidget> {
  var searchQuery = '';
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    var filteredList = searchQuery.isEmpty
        ? widget.communityList
        : widget.communityList
            .where((subreddit) => subreddit['name']!.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ))
            .toList();
    return CustomScrollView(slivers: [
      SliverFillRemaining(
        child: Column(
          children: [
            Expanded(
              flex: 0,
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
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: filteredList.length,
                controller: _scrollController,
                itemBuilder: (context, index) => Card(
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
            ),
          ],
        ),
      ),
    ]);
  }
}
