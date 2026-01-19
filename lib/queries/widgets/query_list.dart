import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/filters/storage/filters_storage_provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/providers/wallpaper_list_provider.dart';
import 'package:wallpaper_app/queries/models/query.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

class QueryList extends StatefulWidget {
  const QueryList(
    this.queries,
    this.deleteQuery,
    this.newKey,
    this.page, {
    super.key,
  });
  final List<Query> queries;
  final dynamic deleteQuery;
  final GlobalKey<AnimatedListState> newKey;
  final int page;

  @override
  State<QueryList> createState() => _QueryListState();
}

class _QueryListState extends State<QueryList> {
  @override
  Widget build(BuildContext context) {
    final queriesStorageProvider =
        Provider.of<QueriesStorageProvider>(context, listen: false);
    return widget.queries.isEmpty
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconlyLight.document,
                color: Colors.grey,
                size: 50,
              ),
              Text(
                "No Queries to Show!",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : AnimatedList(
            initialItemCount: widget.queries.length,
            key: widget.newKey,
            itemBuilder: (context, index, animation) {
              final query = widget.queries[index];
              final sourceInfo = (sourceMaps
                  .firstWhere((source) => source["value"] == query.source));
              final colour = sourceInfo["colour"];
              final icon = sourceInfo["icon"];

              return SizeTransition(
                sizeFactor: animation,
                child: Dismissible(
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (widget.page == 0) {
                      queriesStorageProvider.removeSavedQuery(query);
                    } else {
                      queriesStorageProvider.removeHistoryQuery(query);
                    }
                    widget.deleteQuery(query);
                    widget.newKey.currentState?.removeItem(
                      index,
                      (context, animation) => const SizedBox.shrink(),
                    );
                  },
                  key: Key(query.hashCode.toString()),
                  background: Container(
                    color: Colors.red.withAlpha(50),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      final sourceProvider =
                          Provider.of<SourceProvider>(context, listen: false);
                      final queryProvider =
                          Provider.of<QueryProvider>(context, listen: false);
                      final wallhavenApiKey =
                          Provider.of<SettingsProvider>(context, listen: false)
                              .wallhavenApiKey;
                      final wallpaperListProvider =
                          Provider.of<WallpaperListProvider>(context,
                              listen: false);

                      // Change source without notifying listeners
                      sourceProvider.shouldNotifyListeners(false);
                      sourceProvider.changeSource(query.source);
                      sourceProvider.shouldNotifyListeners(true);

                      // Empty wallpaper list and switch query
                      wallpaperListProvider.emptyWallpaperList();
                      queryProvider.switchAndSetQuery(query, wallhavenApiKey);

                      // Add query to history
                      queriesStorageProvider
                          .addHistoryQuery(queryProvider.currentQuery);
                      Provider.of<QueriesProvider>(context, listen: false)
                          .addHistoryQuery(queryProvider.currentQuery);

                      Provider.of<FiltersStorageProvider>(context,
                              listen: false)
                          .updateFilters(
                              source: query.source,
                              matureContent: query.matureContent,
                              tag: query.tag,
                              topic: query.topic,
                              communityName: query.communityName,
                              subredditName: query.subredditName,
                              wallhavenSortType: query.wallhavenSortType,
                              wallhavenSortRange: query.wallhavenSortRange,
                              purities: query.purities,
                              redditSortType: query.redditSortType,
                              redditSortRange: query.redditSortRange,
                              lemmySortType: query.lemmySortType,
                              tag1: query.tag1,
                              tag2: query.tag2,
                              includeTag1: query.includeTag1,
                              includeTag2: query.includeTag2,
                              categories: query.categories,
                              ratio: query.ratio,
                              redditFiltersStorageProvider:
                                  Provider.of<RedditFiltersStorageProvider>(
                                      context,
                                      listen: false),
                              wallhavenFiltersStorageProvider:
                                  Provider.of<WallhavenFiltersStorageProvider>(
                                      context,
                                      listen: false),
                              lemmyFiltersStorageProvider:
                                  Provider.of<LemmyFiltersStorageProvider>(
                                      context,
                                      listen: false),
                              deviantArtFiltersStorageProvider:
                                  Provider.of<DeviantArtFiltersStorageProvider>(
                                      context,
                                      listen: false));

                      Navigator.of(context).pop();
                    },
                    child: Card(
                      color: colour as Color,
                      child: ListTile(
                        leading: Icon(
                          icon as IconData,
                          color: Colors.white,
                        ),
                        title: Row(
                          children: [
                            Text(
                              widget.queries[index].source.string,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            query.matureContent
                                ? const Icon(Icons.no_adult_content,
                                    color: Colors.white)
                                : const SizedBox.shrink()
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Wrap(
                            children: getFeatures(
                              tag: query.tag,
                              topic: query.topic,
                              includeTag1: query.includeTag1,
                              includeTag2: query.includeTag2,
                              categories: query.categories,
                              ratio: query.ratio,
                              communityName: query.communityName,
                              subredditName: query.subredditName,
                              wallhavenSortType: query.wallhavenSortType,
                              wallhavenSortRange: query.wallhavenSortRange,
                              purities: query.purities,
                              redditSortType: query.redditSortType,
                              redditSortRange: query.redditSortRange,
                              lemmySortType: query.lemmySortType,
                              tag1: query.tag1,
                              tag2: query.tag2,
                            )
                                .map(
                                  (feature) => ClipRRect(
                                      child: Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(
                                        right: 5, bottom: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      feature,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  )),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
