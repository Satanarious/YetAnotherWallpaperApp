import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/common/widgets/custom_drop_down_menu.dart';
import 'package:wallpaper_app/settings/enums/enums.dart';
import 'package:wallpaper_app/settings/providers/settings_provider.dart';
import 'package:wallpaper_app/settings/storage/settings_storage_provider.dart';
import 'package:wallpaper_app/settings/widgets/settings_row.dart';

class GridLayoutPreviewWidget extends StatefulWidget {
  const GridLayoutPreviewWidget({super.key});

  @override
  State<GridLayoutPreviewWidget> createState() =>
      _GridLayoutPreviewWidgetState();
}

class _GridLayoutPreviewWidgetState extends State<GridLayoutPreviewWidget> {
  static const gridLayouts = ["Staggered", "Fixed"];
  static const columnSizes = ["Adaptive", "Fixed"];
  var roundedCorners = false;
  var gridLayout = gridLayouts[GridLayoutStyle.staggered.index];
  var columnSize = columnSizes[ColumnSizeType.adaptive.index];
  var columnWidth = 200.0;
  var columnNumber = 2;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final previewHeight = size.height * 0.20;
    final previewWidth = size.width * 0.20;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final settingsStorageProvider =
        Provider.of<SettingsStorageProvider>(context, listen: false);
    roundedCorners = settingsProvider.roundedCorners;
    gridLayout = gridLayouts[settingsProvider.gridLayoutStyle.index];
    columnSize = columnSizes[settingsProvider.columnSize.index];
    columnWidth = settingsProvider.columnWidth;
    columnNumber = settingsProvider.columnNumber;

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
                                  crossAxisCount: columnSize == columnSizes[0]
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
                                        height: gridLayout == gridLayouts[0]
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
                    height: previewWidth + 8,
                    width: previewHeight + 8,
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
                                  crossAxisCount: columnSize == columnSizes[0]
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
                                        height: gridLayout == gridLayouts[0]
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
              roundedCorners = value;
              settingsProvider.changeRoundedCorners(value);
              settingsStorageProvider.saveSettings(settingsProvider.toJson());
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
            dropdownMenuEntries: gridLayouts
                .map((layout) => DropdownMenuEntry(
                      labelWidget: Text(layout,
                          style: const TextStyle(color: Colors.white)),
                      label: layout,
                      value: layout,
                    ))
                .toList(),
            initialSelection: gridLayout,
            onSelected: (layout) {
              gridLayout = layout;
              settingsProvider.changeGridLayoutStyle(
                  GridLayoutStyle.values[gridLayouts.indexOf(layout)]);
              settingsStorageProvider.saveSettings(settingsProvider.toJson());
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
            dropdownMenuEntries: columnSizes
                .map((size) => DropdownMenuEntry(
                      labelWidget: Text(size,
                          style: const TextStyle(color: Colors.white)),
                      label: size,
                      value: size,
                    ))
                .toList(),
            initialSelection: columnSize,
            onSelected: (size) {
              columnSize = size;
              settingsProvider.changeColumnSize(
                  ColumnSizeType.values[columnSizes.indexOf(size)]);
              settingsStorageProvider.saveSettings(settingsProvider.toJson());
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.view_column_outlined, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              columnSize == columnSizes[0]
                  ? "Column width(px): ${columnWidth.toInt()}"
                  : "Number of columns: $columnNumber",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 5),
        columnSize == columnSizes[0]
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
                        settingsProvider.changeColumnWidth(value);
                        columnWidth = value;
                      },
                      onChangeEnd: (value) {
                        settingsStorageProvider
                            .saveSettings(settingsProvider.toJson());
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
                      min: 1,
                      max: 6,
                      onChanged: (value) {
                        settingsProvider.changeColumnNumber(value.toInt());
                        columnNumber = value.toInt();
                      },
                      onChangeEnd: (value) {
                        settingsStorageProvider
                            .saveSettings(settingsProvider.toJson());
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
