import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:wallpaper_app/common/widgets/custom_drop_down_menu.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/open_image/widgets/wallpaper_info_sheet.dart';
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
  var cacheLimit = 0.0;
  var historyLimit = 100;
  var autoWallpaper = false;
  var autoWallpaperInterval = 12;
  var dayNightMode = false;
  var dayChangeTime = const TimeOfDay(hour: 6, minute: 0);
  var nightChangeTime = const TimeOfDay(hour: 19, minute: 0);
  var wallpaperSource = "Favourites";
  var defaultSource = Sources.reddit;

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
                Row(
                  children: [
                    const Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "History Limit: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(historyLimit.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text("10",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                    Expanded(
                      child: Slider(
                        value: historyLimit.toDouble(),
                        allowedInteraction: SliderInteraction.tapAndSlide,
                        label: "$historyLimit",
                        min: 10,
                        max: 500,
                        onChanged: (value) {
                          setState(() {
                            historyLimit = value.toInt();
                          });
                        },
                      ),
                    ),
                    const Text("500",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
            const SectionContainer(
              sectionName: "Layout & Appearance",
              children: [
                GridLayoutPreviewWidget(),
              ],
            ),
            SectionContainer(
              sectionName: "Advanced",
              children: [
                SettingsRow(
                  settingIcon: Icons.history,
                  settingName: "Cache Limit",
                  settingWidget: SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid)),
                        hintText: "1024",
                        suffixText: "MB",
                        suffixStyle: TextStyle(color: Colors.white),
                        hintTextDirection: TextDirection.ltr,
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        cacheLimit = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(
                      Icons.key,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Wallhaven API Key: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      "Get it here: ",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    LinkWidget("https://wallhaven.cc/settings/account"),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          hintText: "e.g. 21Zf1LTmaGbXzzPlyovHKR5DeDbtqaIO",
                          hintTextDirection: TextDirection.ltr,
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          cacheLimit = double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SectionContainer(
              sectionName: "Auto Wallpaper",
              children: [
                SettingsRow(
                  settingIcon: Icons.auto_awesome,
                  settingName: "Enable Auto Wallpaper",
                  settingWidget: Switch(
                      value: autoWallpaper,
                      onChanged: (value) {
                        setState(() {
                          autoWallpaper = value;
                        });
                      }),
                ),
                SettingsRow(
                  settingIcon: Icons.nights_stay_outlined,
                  isDisabled: !autoWallpaper,
                  settingName: "Enable Day/Night Mode",
                  settingWidget: Switch(
                      value: dayNightMode,
                      onChanged: autoWallpaper
                          ? (value) {
                              setState(() {
                                dayNightMode = value;
                              });
                            }
                          : null),
                ),
                const SizedBox(height: 10),
                SettingsRow(
                  settingIcon: Icons.source_outlined,
                  settingName: "Source",
                  isDisabled: !autoWallpaper,
                  settingWidget: CustomDropDownMenu(
                    height: 40,
                    width: 170,
                    isEnabled: autoWallpaper,
                    dropdownMenuEntries: ["Query", "Favourites"]
                        .map((source) => DropdownMenuEntry(
                              labelWidget: Text(source,
                                  style: const TextStyle(color: Colors.white)),
                              label: source,
                              value: source,
                            ))
                        .toList(),
                    initialSelection: wallpaperSource,
                    onSelected: (source) {
                      setState(() {
                        wallpaperSource = source;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: autoWallpaper && !dayNightMode ? 130 : 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        wallpaperSource == "Query"
                            ? SettingsRow(
                                settingIcon: IconlyLight.document,
                                settingName: "Wallpaper Query",
                                settingWidget: OutlinedButton(
                                  onPressed: autoWallpaper ? () {} : null,
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: Colors.white,
                                  )),
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : SettingsRow(
                                settingIcon: Icons.favorite_border_rounded,
                                settingName: "Wallpaper Favourites Folder",
                                settingWidget: OutlinedButton(
                                  onPressed: autoWallpaper ? () {} : null,
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: Colors.white,
                                  )),
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.timer_outlined, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "Interval(Hrs): ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("1",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                            Expanded(
                              child: Slider(
                                value: autoWallpaperInterval.toDouble(),
                                allowedInteraction:
                                    SliderInteraction.tapAndSlide,
                                label: "$autoWallpaperInterval",
                                divisions: 23,
                                min: 1,
                                max: 24,
                                onChanged: (value) {
                                  setState(() {
                                    autoWallpaperInterval = value.toInt();
                                  });
                                },
                              ),
                            ),
                            const Text("24",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: autoWallpaper && dayNightMode ? 230 : 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SettingsRow(
                          settingIcon: Icons.wb_sunny_outlined,
                          settingName: "Day Mode Time",
                          isDisabled: (!autoWallpaper && !dayNightMode) ||
                              (autoWallpaper && !dayNightMode),
                          settingWidget: OutlinedButton(
                            onPressed: autoWallpaper
                                ? () async {
                                    final time = await showTimePicker(
                                        context: context,
                                        initialTime: dayChangeTime);

                                    if (time != null) {
                                      dayChangeTime = time;
                                    }
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              color: autoWallpaper && dayNightMode
                                  ? Colors.white
                                  : Colors.grey,
                            )),
                            child: Text(
                              "Set",
                              style: TextStyle(
                                color: autoWallpaper && dayNightMode
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SettingsRow(
                          settingIcon: Icons.nightlight_outlined,
                          settingName: "Night Mode Time",
                          isDisabled: (!autoWallpaper && !dayNightMode) ||
                              (autoWallpaper && !dayNightMode),
                          settingWidget: OutlinedButton(
                            onPressed: autoWallpaper
                                ? () async {
                                    final time = await showTimePicker(
                                        context: context,
                                        initialTime: nightChangeTime);

                                    if (time != null) {
                                      nightChangeTime = time;
                                    }
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              color: autoWallpaper && dayNightMode
                                  ? Colors.white
                                  : Colors.grey,
                            )),
                            child: Text(
                              "Set",
                              style: TextStyle(
                                color: autoWallpaper && dayNightMode
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        wallpaperSource == "Query"
                            ? SettingsRow(
                                settingIcon: IconlyLight.document,
                                settingName: "Day Mode Query",
                                settingWidget: OutlinedButton(
                                  onPressed: autoWallpaper ? () {} : null,
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: Colors.white,
                                  )),
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : SettingsRow(
                                settingIcon: IconlyLight.document,
                                settingName: "Day Mode Favourites Folder",
                                settingWidget: OutlinedButton(
                                  onPressed: autoWallpaper ? () {} : null,
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: Colors.white,
                                  )),
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        wallpaperSource == "Query"
                            ? SettingsRow(
                                settingIcon: Icons.favorite_outline_rounded,
                                settingName: "Night Mode Query",
                                settingWidget: OutlinedButton(
                                  onPressed: autoWallpaper ? () {} : null,
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: Colors.white,
                                  )),
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : SettingsRow(
                                settingIcon: Icons.favorite_outline_rounded,
                                settingName: "Night Mode Favourites Folder",
                                settingWidget: OutlinedButton(
                                  onPressed: autoWallpaper ? () {} : null,
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: Colors.white,
                                  )),
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                SettingsRow(
                  settingIcon: Icons.rule,
                  settingName: "Constraints",
                  isDisabled: !autoWallpaper,
                  settingWidget: OutlinedButton(
                    onPressed: autoWallpaper ? () {} : null,
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                      color: autoWallpaper ? Colors.white : Colors.grey,
                    )),
                    child: Text(
                      "Choose",
                      style: TextStyle(
                        color: autoWallpaper ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
