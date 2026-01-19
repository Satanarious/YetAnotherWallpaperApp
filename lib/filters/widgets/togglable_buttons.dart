import 'package:flutter/material.dart';

class TogglableButtons extends StatefulWidget {
  const TogglableButtons({
    required this.buttonList,
    required this.selected,
    super.key,
    this.controller,
    this.selectOnlyOne = false,
    this.wrapChildren = false,
  });
  final List<Map<String, dynamic>> buttonList;
  final List<bool> selected;
  final bool wrapChildren;
  final bool
      selectOnlyOne; // Configures whether to select only one or at least one
  final TextEditingController? controller;

  @override
  State<TogglableButtons> createState() => _TogglableButtonsState();
}

class _TogglableButtonsState extends State<TogglableButtons> {
  late ScrollController? _scrollController;

  @override
  void initState() {
    if (widget.buttonList.length > 3 && !widget.wrapChildren) {
      _scrollController = ScrollController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Scroll animation after list builds
        _scrollController!.jumpTo(50);
        _scrollController!.animateTo(
          -50,
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate,
        );
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.buttonList.length > 3 && !widget.wrapChildren) {
      _scrollController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children =
        List.generate(widget.selected.length, (index) => index).map((index) {
      final button = widget.buttonList[index];
      final isSelected = widget.selected[index];
      return Padding(
        padding: const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: () {
            if (widget.selected.where((element) => element == true).length ==
                    1 &&
                widget.selected[index]) {
              return; // Insure selection of atleast one button
            }
            if (widget.selectOnlyOne) {
              // Allow one selection at a time
              setState(() {
                for (int i = 0; i < widget.buttonList.length; i++) {
                  widget.selected[i] = (i == index);
                  if (widget.controller != null && widget.selected[i] == true) {
                    widget.controller?.text = widget.buttonList[i]['value'];
                  }
                }
              });
            } else {
              setState(() {
                widget.selected[index] = !widget.selected[index];
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.white : Colors.grey.shade500,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                button['icon'] == null
                    ? Container()
                    : Icon(
                        button['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.grey.shade500,
                      ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  button['name'] as String,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade500,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    final toggleButtons = widget.wrapChildren
        ? Wrap(
            children: children,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          );
    return widget.buttonList.length > 3 && !widget.wrapChildren
        ? SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: toggleButtons)
        : toggleButtons;
  }
}
