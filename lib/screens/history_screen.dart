import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/history_provider.dart';
import 'package:wallpaper_app/widgets/masonry_grid_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  static const routeName = "/History";

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                      surfaceTintColor: Colors.black,
                      title: const Text(
                        "Clear History",
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        "Are you sure you want to clear the history?",
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: Navigator.of(context).pop,
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            historyProvider.clearAllHistory();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  ),
              icon: const Icon(Icons.clear_all_rounded, color: Colors.white))
        ],
        backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
              listNeedsNetworkLoading: false,
              wallpaperList: historyProvider.history,
            ),
    );
  }
}
