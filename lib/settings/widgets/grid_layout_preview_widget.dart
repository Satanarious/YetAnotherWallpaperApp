import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/common/widgets/custom_drop_down_menu.dart';
import 'package:wallpaper_app/settings/widgets/settings_row.dart';

class GridLayoutPreviewWidget extends StatefulWidget {
  const GridLayoutPreviewWidget({super.key});

  @override
  State<GridLayoutPreviewWidget> createState() =>
      _GridLayoutPreviewWidgetState();
}

class _GridLayoutPreviewWidgetState extends State<GridLayoutPreviewWidget> {
  var roundedCorners = false;
  var gridLayout = "Staggered";
  var columnSize = "Adaptive";
  var columnWidth = 200.0;
  var columnNumber = 2;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final previewHeight = size.height * 0.20;
    final previewWidth = size.width * 0.20;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    height: previewHeight + 10,
                    width: previewWidth + 10,
                    color: Colors.grey,
                    child: Center(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                            height: previewHeight,
                            width: previewWidth,
                            color: Colors.grey,
                            child: MasonryGridView.builder(
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columnSize == "Adaptive"
                                      ? (size.width / columnWidth).toInt() > 0
                                          ? (size.width / columnWidth).toInt()
                                          : 1
                                      : columnNumber.toInt(),
                                ),
                                padding: const EdgeInsets.only(top: 0),
                                itemCount: 20,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                itemBuilder: (context, index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          roundedCorners ? 5 : 0),
                                      child: Container(
                                        color:
                                            const Color.fromRGBO(50, 50, 50, 1),
                                        height: gridLayout == "Staggered"
                                            ? index % 7 == 0
                                                ? previewHeight * 0.4
                                                : previewHeight * 0.15
                                            : previewHeight * 0.4,
                                      ),
                                    ))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    height: previewWidth + 10,
                    width: previewHeight + 10,
                    color: Colors.grey,
                    child: Center(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                            height: previewWidth,
                            width: previewHeight,
                            color: Colors.grey,
                            child: MasonryGridView.builder(
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columnSize == "Adaptive"
                                      ? (size.height / columnWidth).toInt() > 0
                                          ? (size.height / columnWidth).toInt()
                                          : 1
                                      : columnNumber.toInt(),
                                ),
                                padding: const EdgeInsets.only(top: 0),
                                itemCount: 20,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                itemBuilder: (context, index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          roundedCorners ? 5 : 0),
                                      child: Container(
                                        color:
                                            const Color.fromRGBO(50, 50, 50, 1),
                                        height: gridLayout == "Staggered"
                                            ? index % 5 == 0
                                                ? previewHeight * 0.4
                                                : previewHeight * 0.15
                                            : previewHeight * 0.4,
                                      ),
                                    ))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        SettingsRow(
          settingIcon: Icons.rounded_corner,
          settingName: "Rounded Corners",
          settingWidget: Switch(
            value: roundedCorners,
            onChanged: (value) {
              setState(
                () {
                  roundedCorners = value;
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SettingsRow(
          settingIcon: Icons.grid_view,
          settingName: "Grid Style",
          settingWidget: CustomDropDownMenu(
            height: 40,
            width: 155,
            dropdownMenuEntries: ["Staggered", "Fixed"]
                .map((layout) => DropdownMenuEntry(
                      labelWidget: Text(layout,
                          style: const TextStyle(color: Colors.white)),
                      label: layout,
                      value: layout,
                    ))
                .toList(),
            initialSelection: gridLayout,
            onSelected: (layout) {
              setState(() {
                gridLayout = layout;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        SettingsRow(
          settingIcon: Icons.view_column_outlined,
          settingName: "Column Size",
          settingWidget: CustomDropDownMenu(
            height: 40,
            width: 150,
            dropdownMenuEntries: ["Adaptive", "Fixed"]
                .map((size) => DropdownMenuEntry(
                      labelWidget: Text(size,
                          style: const TextStyle(color: Colors.white)),
                      label: size,
                      value: size,
                    ))
                .toList(),
            initialSelection: columnSize,
            onSelected: (size) {
              setState(() {
                columnSize = size;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.view_column_outlined, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              columnSize == "Adaptive"
                  ? "Column width(px): "
                  : "Number of columns: ",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 5),
        columnSize == "Adaptive"
            ? Row(
                children: [
                  Text("${(size.width * 0.1).toInt()}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  Expanded(
                    child: Slider(
                      value: columnWidth,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                      label: "${columnWidth.toInt()} px",
                      min: size.width * 0.1,
                      max: size.width * 0.5,
                      onChanged: (value) {
                        setState(() {
                          columnWidth = value;
                        });
                      },
                    ),
                  ),
                  Text("${(size.width * 0.5).toInt()}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ],
              )
            : Row(
                children: [
                  const Text("1",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  Expanded(
                    child: Slider(
                      value: columnNumber.toDouble(),
                      allowedInteraction: SliderInteraction.tapAndSlide,
                      divisions: 5,
                      label: "$columnNumber",
                      min: 1,
                      max: 6,
                      onChanged: (value) {
                        setState(() {
                          columnNumber = value.toInt();
                        });
                      },
                    ),
                  ),
                  const Text("6",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ],
              ),
      ],
    );
  }
}
