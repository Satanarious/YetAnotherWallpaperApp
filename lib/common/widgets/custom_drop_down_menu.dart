import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu({
    required this.dropdownMenuEntries,
    required this.initialSelection,
    required this.onSelected,
    this.isEnabled = true,
    this.icon,
    this.height = 50,
    this.width = 200,
    super.key,
  });
  final dynamic initialSelection;
  final List<DropdownMenuEntry> dropdownMenuEntries;
  final ValueChanged<dynamic> onSelected;
  final double height;
  final double width;
  final IconData? icon;
  final bool isEnabled;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      enabled: widget.isEnabled,
      leadingIcon: widget.icon != null
          ? Icon(widget.icon, color: Colors.white.withAlpha(180))
          : null,
      textStyle: TextStyle(
          color: widget.isEnabled ? Colors.white : Colors.grey, fontSize: 14),
      menuStyle: MenuStyle(
          backgroundColor: WidgetStateColor.resolveWith(
              (states) => Colors.black.withAlpha(210)),
          shape: WidgetStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          side: WidgetStateBorderSide.resolveWith((states) => const BorderSide(
                color: Colors.white,
              ))),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        constraints: BoxConstraints.tight(Size(widget.width, widget.height)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      initialSelection: widget.initialSelection,
      dropdownMenuEntries: widget.dropdownMenuEntries,
      onSelected: widget.onSelected,
    );
  }
}
