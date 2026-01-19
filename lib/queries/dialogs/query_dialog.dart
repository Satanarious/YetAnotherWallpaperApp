import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/home/providers/query_provider.dart';
import 'package:wallpaper_app/queries/providers/queries_provider.dart';
import 'package:wallpaper_app/queries/storage/queries_storage_provider.dart';
import 'package:wallpaper_app/queries/widgets/query_list.dart';

class QueryDialog extends StatefulWidget {
  const QueryDialog({super.key});

  @override
  State<QueryDialog> createState() => _QueryDialogState();
}

class _QueryDialogState extends State<QueryDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final GlobalKey<AnimatedListState> _savedQueryListKey = GlobalKey();
  final GlobalKey<AnimatedListState> _historyQueryListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final queriesProvider = Provider.of<QueriesProvider>(context);
    final savedQueryList = QueryList(queriesProvider.savedQueries,
        queriesProvider.removeSavedQuery, _savedQueryListKey, 0);

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
              children: [
                Row(
                  children: [
                    const Text(
                      "Queries",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        final query =
                            Provider.of<QueryProvider>(context, listen: false)
                                .currentQuery;
                        Provider.of<QueriesStorageProvider>(context,
                                listen: false)
                            .addSavedQuery(query);
                        queriesProvider.addSavedQuery(query);
                        _savedQueryListKey.currentState?.insertItem(0);
                      },
                      style: ButtonStyle(
                        side: WidgetStateProperty.resolveWith(
                            (states) => const BorderSide(color: Colors.white)),
                        backgroundColor: WidgetStateProperty.resolveWith(
                            (states) =>
                                Theme.of(context).primaryColor.withAlpha(120)),
                      ),
                      child: const Text("+ Add Current"),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TabBar(
                        tabs: ["Saved", "History"]
                            .map((tabName) => Text(
                                  tabName,
                                  style: const TextStyle(fontSize: 16),
                                ))
                            .toList(),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        controller: _tabController,
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            savedQueryList,
                            QueryList(
                                queriesProvider.historyQueries,
                                queriesProvider.removeHistoryQuery,
                                _historyQueryListKey,
                                1),
                          ],
                        ),
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
