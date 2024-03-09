import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../providers/wallpaper_list_provider.dart';
import '../widgets/community_list_widget.dart';
import '../widgets/togglable_buttons.dart';

class LemmyFilterDialog extends StatefulWidget {
  const LemmyFilterDialog({super.key});

  @override
  State<LemmyFilterDialog> createState() => _LemmyFilterDialogState();
}

class _LemmyFilterDialogState extends State<LemmyFilterDialog>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var communityNameController =
      TextEditingController(text: 'mobilewallpaper@lemmy.world');
  var sortSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    true,
  ];

  static const sortList = [
    {"name": "Active", "icon": Icons.arrow_upward},
    {"name": "New", "icon": Icons.new_releases},
    {"name": "Hot", "icon": Icons.fireplace},
    {"name": "Old", "icon": Icons.download},
    {"name": "Top Hour", "icon": Icons.timer},
    {"name": "Top Day", "icon": Icons.calendar_view_day},
    {"name": "Top Week", "icon": Icons.calendar_view_week},
    {"name": "Top Month", "icon": Icons.calendar_view_month},
    {"name": "Top Year", "icon": Icons.calendar_today},
    {"name": "Top All", "icon": Icons.all_inbox},
  ];

  static const communityList = [
    {
      'name': 'AI Generated',
      'value': 'imageai@sh.itjust.works',
      'description': 'Community for AI image generation',
      'url': "https://imgur.com/JFTaoDr.png"
    },
    {
      'name': 'Amoled Backgrounds',
      'value': 'amoledbackgrounds@lemmy.world',
      'description':
          'A community for posting AMOLED background images, these backgrounds are mostly true black which, on (am)oled displays, turns the pixels off entirely.',
      'url': "https://imgur.com/t1XTFuk.png"
    },
    {
      'name': 'Anime Wallpapers',
      'value': 'animewallpapers@ani.social',
      'description':
          'Unleash your otaku spirit and explore a treasure trove of breathtaking anime wallpapers. Join our passionate community and let your screen come alive with the captivating beauty of anime art!',
      'url': "https://imgur.com/u1OyICv.png"
    },
    {
      'name': 'Apocalyptical Art',
      'value': 'apocalypticalart@feddit.de',
      'description':
          'This is where the remnants of humanity’s past meet the promise of an uncertain future. This is the place for apocalyptic wastelands, remains of once-thriving metropolises and forgotten relics of a bygone era.',
      'url': "https://imgur.com/tkIDfb8.png"
    },
    {
      'name': 'Digital Art',
      'value': 'digitalart@lemmy.world',
      'description': 'A community for posting digital art',
      'url': "https://imgur.com/Nv2mwDS.png"
    },
    {
      'name': 'Earth Porn',
      'value': 'earthporn@lemmy.world',
      'description':
          'A community to post pictures of beautiful landscapes and earth in general.',
      'url': "https://imgur.com/zqiMxAF.png"
    },
    {
      'name': 'Mobile Wallpapers',
      'value': 'mobilewallpaper@lemmy.world',
      'description': 'This is a community for sharing mobile wallpapers.',
      'url': "https://imgur.com/dhoG6m3.png"
    },
    {
      'name': "Nature's Patterns",
      'value': 'natures_patterns@lemmy.world',
      'description':
          'Lots of communities are dedicated to nature’s big pictures, the breathtaking vistas and scenic landscapes. Those are all great, but I find the details of the natural world to be just as much of a draw.',
      'url': "https://imgur.com/lmTujsl.png"
    },
    {
      'name': 'Wallpapers',
      'value': 'wallpapers',
      'description': 'A community for posting wallpapers',
      'url': "https://imgur.com/b1dvUyw.png"
    },
    {
      'name': 'Wallpapers(Canada)',
      'value': 'wallpapers@lemmy.ca',
      'description': 'A community for posting wallpapers from Canada',
      'url': "https://imgur.com/KcZ36nl.png"
    },
    {
      'name': 'Wallpapers(World)',
      'value': 'wallpapers@lemmy.world',
      'description':
          'A community for posting wallpapers from all around the world',
      'url': "https://imgur.com/ig0Ns0T.png"
    }
  ];

  LemmySortType get sortType {
    return LemmySortType.values[sortSelected.indexOf(true)];
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

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
          height: isVertical ? 380 : 340,
          width: 350,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Filters",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 14,
                                ),
                                const Text(
                                  "Community",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: communityNameController,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        decoration: InputDecoration(
                                          prefixText: "!",
                                          suffixIcon: IconButton(
                                            tooltip: "Presets",
                                            icon: const Icon(
                                              Icons.list,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                tabController.animateTo(1),
                                          ),
                                          hintText: "Community Name",
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .symmetric(
                                                  horizontal: 10, vertical: 2),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Sort Type",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TogglableButtons(
                                  buttonList: sortList,
                                  selected: sortSelected,
                                  wrapChildren: true,
                                ),
                                const SizedBox(
                                  height: 10,
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
                                            Provider.of<QueryProvider>(context,
                                                listen: false);
                                        final wallpaperListProvider =
                                            Provider.of<WallpaperListProvider>(
                                                context,
                                                listen: false);
                                        queryProvider.setLemmyQuery(
                                            communityName:
                                                communityNameController.text,
                                            sortType: sortType);
                                        wallpaperListProvider
                                            .emptyWallpaperList();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommunityListWidget(
                      communityNameController: communityNameController,
                      tabController: tabController,
                      communityList: communityList,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
