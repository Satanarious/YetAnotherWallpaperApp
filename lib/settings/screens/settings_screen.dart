import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/common/widgets/custom_drop_down_menu.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/settings/widgets/grid_layout_preview_widget.dart';
import 'package:wallpaper_app/settings/widgets/section_container.dart';
import 'package:wallpaper_app/settings/widgets/settings_row.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  static const appBarHeight = 50.0;

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var blurNsfw = false;
  var blurSketchy = false;
  var addToFavouritesOnDownload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, SettingsScreen.appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              elevation: 10,
              backgroundColor: Colors.transparent,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: SettingsScreen.appBarHeight * 2.2),
            SectionContainer(
              sectionName: "General",
              children: [
                SettingsRow(
                  settingIcon: Icons.wallpaper,
                  settingName: "Default Source",
                  settingWidget: ClipRRect(
                    child: CustomDropDownMenu(
                      height: 40,
                      width: 170,
                      dropdownMenuEntries: Sources.values
                          .map((source) => DropdownMenuEntry(
                                labelWidget: Text(source.string,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                label: source.string,
                                value: source,
                              ))
                          .toList(),
                      initialSelection: Sources.reddit,
                      onSelected: (source) {},
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SettingsRow(
                  settingIcon: Icons.blur_on,
                  settingName: "Blur Sketchy Wallpapers",
                  settingWidget: Switch(
                    value: blurSketchy,
                    onChanged: (value) {
                      setState(() {
                        blurSketchy = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SettingsRow(
                  settingIcon: Icons.no_adult_content_rounded,
                  settingName: "Blur NSFW Wallpapers",
                  settingWidget: Switch(
                    value: blurNsfw,
                    onChanged: (value) {
                      setState(() {
                        blurNsfw = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SettingsRow(
                  settingIcon: Icons.favorite_outline_rounded,
                  settingName: "Add to favourites on download",
                  settingWidget: Switch(
                    value: addToFavouritesOnDownload,
                    onChanged: (value) {
                      setState(() {
                        addToFavouritesOnDownload = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SectionContainer(
              sectionName: "Layout & Appearance",
              children: [
                GridLayoutPreviewWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
