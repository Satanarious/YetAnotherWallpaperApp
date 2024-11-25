import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/widgets/masonry_grid_widget.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  static const routeName = "/History";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: const Text(
                "History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              elevation: 10,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    onPressed: () => showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, wid) {
                          return Transform.scale(
                            scale: a1.value,
                            child: Opacity(
                              opacity: a1.value,
                              child: Dialog(
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      height: 200,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(50),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Warning",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ]),
                                          const Text(
                                            "Are you sure? This will clear all the history of your previously visited wallpaper pages.",
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FilledButton(
                                                onPressed:
                                                    Navigator.of(context).pop,
                                                style: ButtonStyle(
                                                  side: WidgetStateProperty
                                                      .resolveWith((states) =>
                                                          const BorderSide(
                                                              color: Colors
                                                                  .white)),
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith((states) =>
                                                              Theme.of(context)
                                                                  .primaryColor
                                                                  .withAlpha(
                                                                      120)),
                                                ),
                                                child: const Text("No"),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  historyProvider
                                                      .clearAllHistory();
                                                  Provider.of<HistoryStorageProvider>(
                                                          context,
                                                          listen: false)
                                                      .emptyHistory();
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  side: WidgetStateProperty
                                                      .resolveWith((states) =>
                                                          const BorderSide(
                                                              color: Colors
                                                                  .white)),
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith((states) =>
                                                              Theme.of(context)
                                                                  .primaryColor
                                                                  .withAlpha(
                                                                      120)),
                                                ),
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) =>
                            Container()),
                    icon: const Icon(Icons.clear_all_rounded,
                        color: Colors.white))
              ],
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: historyProvider.history.data.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/empty.gif",
                    height: 200,
                    width: 300,
                    fit: BoxFit.fitWidth,
                  ),
                  const Text(
                    "Nothing Found!",
                    style: TextStyle(color: Colors.white54, fontSize: 20),
                  ),
                ],
              ),
            )
          : MasonryGridWidget(
              addPadding: true,
              listNeedsNetworkLoading: false,
              wallpaperList: historyProvider.history,
            ),
    );
  }
}
