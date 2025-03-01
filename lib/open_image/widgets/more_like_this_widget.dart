import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_app/common/models/wallpaper.dart';
import 'package:wallpaper_app/common/models/wallpaper_list.dart';
import 'package:wallpaper_app/home/providers/source_provider.dart';
import 'package:wallpaper_app/home/widgets/image_pop_in_animation_widget.dart';
import 'package:wallpaper_app/open_image/screens/open_image_screen.dart';
import 'package:wallpaper_app/open_image/widgets/label_widget.dart';

class MoreLikeThisWidget extends StatelessWidget {
  const MoreLikeThisWidget(this.wallpaper, this.moreLikeThis, {super.key});
  final Wallpaper wallpaper;
  final Future<List<WallpaperList>> moreLikeThis;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: moreLikeThis,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final moreFromArtist = snapshot.data![0];
            final moreFromDA = snapshot.data![1];
            return SizedBox(
              height: 400,
              child: Column(children: [
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
                                    child: GestureDetector(
                                      onTap: () {
                                        if (moreFromArtist
                                                .data[index].url.isEmpty &&
                                            moreFromArtist.data[index].source !=
                                                Sources.local) return;

                                        Navigator.of(context).pushNamed(
                                          OpenImageScreen.routeName,
                                          arguments: moreFromArtist.data[index],
                                        );
                                      },
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
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
                                  child: GestureDetector(
                                    onTap: () {
                                      if (moreFromDA.data[index].url.isEmpty &&
                                          moreFromDA.data[index].source !=
                                              Sources.local) return;

                                      Navigator.of(context).pushNamed(
                                        OpenImageScreen.routeName,
                                        arguments: moreFromDA.data[index],
                                      );
                                    },
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
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
