import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/dialogs/animated_pop_in_dialog.dart';
import 'package:wallpaper_app/common/widgets/masonry_grid_widget.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  static const routeName = "/History";
  static const appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final limit =
        Provider.of<SettingsProvider>(context, listen: false).historyLimit;
    historyProvider.fixLimit(limit);

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
                  icon: const Icon(
                    Icons.clear_all_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => AnimatedPopInDialog.showCustomized(
                    context: context,
                    title: "Warning",
                    icon: Icons.warning_amber_rounded,
                    description:
                        "Are you sure? This will clear all the history of your previously visited wallpaper pages.",
                    buttonNameAndFunctionMap: {
                      "No": Navigator.of(context).pop,
                      "Yes": () {
                        historyProvider.clearAllHistory();
                        Provider.of<HistoryStorageProvider>(context,
                                listen: false)
                            .emptyHistory();
                        Navigator.of(context).pop();
                      },
                    },
                  ),
                )
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
