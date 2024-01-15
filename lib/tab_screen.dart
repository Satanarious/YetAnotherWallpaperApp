import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/floating_button_provider.dart';
import 'package:wallpaper_app/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/tabs/reddit_tab_screen.dart';
import 'package:wallpaper_app/tabs/wallpaper_haven_tab_screen.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollHandlingProvider = Provider.of<ScrollHandlingProvider>(context);
    final floatingButtonProvider = Provider.of<FloatingButtonProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Stack(children: [
          const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Text("Hello 0"),
              Text("Hello 1"),
              WallpaperHavenTabScreen(),
              RedditTabScreen(),
            ],
          ),
          Positioned(
              bottom: scrollHandlingProvider.pillOffset,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PillTabBar(),
                  const SizedBox(
                    width: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: floatingButtonProvider.buttonAction,
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration:
                              BoxDecoration(color: Colors.black.withAlpha(210)),
                          child: Icon(
                            floatingButtonProvider.buttonIcon,
                            color: Colors.grey,
                          )),
                    ),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}

class PillTabBar extends StatefulWidget {
  const PillTabBar({super.key});

  @override
  State<PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<PillTabBar> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final scrollHandlingProvider =
        Provider.of<ScrollHandlingProvider>(context, listen: false);
    final floatingButtonProvider = Provider.of<FloatingButtonProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        height: scrollHandlingProvider.pillHeight,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 10,
          currentIndex: _tabIndex,
          backgroundColor: Colors.black.withAlpha(220),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.orange,
          onTap: (index) {
            floatingButtonProvider.indexChanged(index);
            DefaultTabController.of(context).animateTo(index);
            scrollHandlingProvider.resetOffsets();
            setState(() {
              _tabIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.wallpaper_outlined),
              label: "Changer",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favourite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.holiday_village),
              label: "Haven",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reddit),
              label: "Reddit",
            ),
          ],
        ),
      ),
    );
  }
}
