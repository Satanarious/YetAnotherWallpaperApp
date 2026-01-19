import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/common/enums/purity.dart';
import 'package:wallpaper_app/common/models/wallpaper.dart';
import 'package:wallpaper_app/common/models/wallpaper_list.dart';
import 'package:wallpaper_app/history/providers/history_provider.dart';
import 'package:wallpaper_app/history/storage/history_storage_provider.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/widgets/image_pop_in_animation_widget.dart';
import 'package:wallpaper_app/open_image/screens/open_image_screen.dart';
import 'package:wallpaper_app/open_image/widgets/label_widget.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';

class MoreLikeThisWidget extends StatelessWidget {
  const MoreLikeThisWidget(this.wallpaper, this.moreLikeThis, {super.key});
  final Wallpaper wallpaper;
  final Future<List<WallpaperList>> moreLikeThis;
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final blurNSFW = settingsProvider.blurNsfw;
    return FutureBuilder(
        future: moreLikeThis,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final moreFromArtist = snapshot.data![0];
            final moreFromDA = snapshot.data![1];
            return SizedBox(
              height:
                  moreFromArtist.data.isNotEmpty && moreFromDA.data.isNotEmpty
                      ? 400
                      : moreFromArtist.data.isEmpty && moreFromDA.data.isEmpty
                          ? 0
                          : 200,
              child: Column(children: [
                wallpaper.source == Sources.deviantArt &&
                        moreFromArtist.data.isNotEmpty
                    ? const Row(
                        children: [
                          LabelWidget("More from this artist"),
                        ],
                      )
                    : const SizedBox.shrink(),
                wallpaper.source == Sources.deviantArt &&
                        moreFromArtist.data.isNotEmpty
                    ? SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => SizedBox(
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ImagePopInAnimation(
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: (blurNSFW &&
                                            moreFromArtist.data[index].purity ==
                                                PurityType.adult)
                                        ? Stack(
                                            children: [
                                              Image.asset(
                                                "assets/blur.png",
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                bottom: 2,
                                                left: 2,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  color: Colors.black54,
                                                  child: const Text(
                                                    "NSFW",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 4),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              if (moreFromArtist.data[index].url
                                                      .isEmpty &&
                                                  moreFromArtist
                                                          .data[index].source !=
                                                      Sources.local) {
                                                return;
                                              }

                                              final historyLimit =
                                                  Provider.of<SettingsProvider>(
                                                          context,
                                                          listen: false)
                                                      .historyLimit;
                                              final added =
                                                  Provider.of<HistoryProvider>(
                                                          context,
                                                          listen: false)
                                                      .addToHistory(
                                                          moreFromArtist
                                                              .data[index],
                                                          historyLimit);
                                              if (added) {
                                                Provider.of<HistoryStorageProvider>(
                                                        context,
                                                        listen: false)
                                                    .addWallpaperToHistory(
                                                        moreFromArtist
                                                            .data[index]);
                                              }

                                              Navigator.of(context).pushNamed(
                                                OpenImageScreen.routeName,
                                                arguments:
                                                    moreFromArtist.data[index],
                                              );
                                            },
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child: Image.asset(
                                                        "assets/loading.gif",
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                                imageUrl: moreFromArtist
                                                    .data[index].thumbs.large),
                                          ),
                                  ),
                                ),
                              )),
                          itemCount: moreFromArtist.data.length,
                        ),
                      )
                    : const SizedBox.shrink(),
                wallpaper.source == Sources.deviantArt &&
                        moreFromDA.data.isNotEmpty
                    ? const Row(
                        children: [
                          LabelWidget("More like this"),
                        ],
                      )
                    : const SizedBox.shrink(),
                wallpaper.source == Sources.deviantArt &&
                        moreFromDA.data.isNotEmpty
                    ? SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: moreFromDA.data.length,
                          itemBuilder: (context, index) => SizedBox(
                            height: 100,
                            width: 100,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ImagePopInAnimation(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: (blurNSFW &&
                                          moreFromDA.data[index].purity ==
                                              PurityType.adult)
                                      ? Stack(
                                          children: [
                                            Image.asset(
                                              "assets/blur.png",
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              bottom: 2,
                                              left: 2,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                color: Colors.black54,
                                                child: const Text(
                                                  "NSFW",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 4),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (moreFromDA
                                                    .data[index].url.isEmpty &&
                                                moreFromDA.data[index].source !=
                                                    Sources.local) {
                                              return;
                                            }

                                            final historyLimit =
                                                Provider.of<SettingsProvider>(
                                                        context,
                                                        listen: false)
                                                    .historyLimit;
                                            final added =
                                                Provider.of<HistoryProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToHistory(
                                                        moreFromDA.data[index],
                                                        historyLimit);
                                            if (added) {
                                              Provider.of<HistoryStorageProvider>(
                                                      context,
                                                      listen: false)
                                                  .addWallpaperToHistory(
                                                      moreFromDA.data[index]);
                                            }

                                            Navigator.of(context).pushNamed(
                                              OpenImageScreen.routeName,
                                              arguments: moreFromDA.data[index],
                                            );
                                          },
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(
                                                    child: Image.asset(
                                                      "assets/loading.gif",
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                  ),
                                              imageUrl: moreFromDA
                                                  .data[index].thumbs.large),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ]),
            );
          } else {
            return Column(children: [
              wallpaper.source == Sources.deviantArt
                  ? const Row(
                      children: [
                        LabelWidget("More from this artist"),
                      ],
                    )
                  : const SizedBox.shrink(),
              wallpaper.source == Sources.deviantArt
                  ? SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => SizedBox(
                            height: 100,
                            width: 100,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ImagePopInAnimation(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.withAlpha(80),
                                    highlightColor: Colors.white70,
                                    enabled: true,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        itemCount: 6,
                      ),
                    )
                  : const SizedBox.shrink(),
              wallpaper.source == Sources.deviantArt
                  ? const Row(
                      children: [
                        LabelWidget("More like this"),
                      ],
                    )
                  : const SizedBox.shrink(),
              wallpaper.source == Sources.deviantArt
                  ? SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) => SizedBox(
                          height: 100,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ImagePopInAnimation(
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.withAlpha(80),
                                  highlightColor: Colors.white70,
                                  enabled: true,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ]);
          }
        });
  }
}
