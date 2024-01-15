import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/scroll_handling_provider.dart';
import 'package:wallpaper_app/widgets/image_preview_widget.dart';

class MasonryGridWidget extends StatefulWidget {
  const MasonryGridWidget({super.key});

  @override
  State<MasonryGridWidget> createState() => _MasonryGridWidgetState();
}

class _MasonryGridWidgetState extends State<MasonryGridWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double layoutHeight = constraints.maxHeight;
        return Container(
          color: Colors.blueGrey,
          child: CustomGridView(layoutHeight: layoutHeight),
        );
      },
    );
  }
}

class CustomGridView extends StatefulWidget {
  const CustomGridView({
    super.key,
    required this.layoutHeight,
  });
  final double layoutHeight;

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        Provider.of<ScrollHandlingProvider>(context, listen: false)
            .setScrollOffset(notification.metrics.pixels);

        return true;
      },
      child: MasonryGridView.builder(
          padding: const EdgeInsets.only(top: 0),
          controller: _scrollController,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          itemCount: 100,
          itemBuilder: (context, index) {
            return Container(
                color: Colors.black,
                height: index == 1
                    ? widget.layoutHeight * 0.45
                    : widget.layoutHeight * 0.5,
                width: double.infinity,
                child: const ImagePreviewWidget(
                    "https://i.redd.it/ux572cwbymba1.gif"));
          }),
    );
  }
}
